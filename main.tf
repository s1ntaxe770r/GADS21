terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.3.0"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.creds_path)
}

data "google_service_account" "gke_sa" {
  account_id = var.sa_id
}


resource "google_container_cluster" "primary" {
  name                     = "gads21-${terraform.workspace}"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_node_pool" {
  name       = "gads21-${terraform.workspace}-node-pool"
  location   = var.region
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

