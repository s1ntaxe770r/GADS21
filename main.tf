terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.3.0"
    }
  }
}

terraform {
  backend "gcs" {
    bucket = "gads21-tfstate"
    prefix = "terraform/state"
  }
}

module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id   = var.project
  cluster_name = google_container_cluster.primary.name
  location     = var.region
}




provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.creds_path)
}

data "google_service_account" "gke_sa" {
  account_id = var.sa_id
}

data "google_container_cluster" "cluster" {
  name = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
}

resource "google_container_cluster" "primary" {
  name                     = "gads21-${terraform.workspace}"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_node_pool" {
  name       = "gads21-${terraform.workspace}-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible     = true
    machine_type    = var.machine_type
    service_account = data.google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
    host                   = module.gke_auth.host
    token                  = module.gke_auth.token
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo/argo-cd"
  version    = "3.29.4"

}
