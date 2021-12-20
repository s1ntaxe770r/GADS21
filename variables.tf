variable "project" {
  description = "google cloud project name"
  default     = "gads21"
}

variable "region" {
  description = "deployment regions"
  default     = "us-east1"
}


variable "creds_path" {
  description = "google cloud service account path"
  default     = "./gads21-service.json"
}

variable "node_count" {
  description = "kubernetes node count (defaults to 1)"
  default     = 1
}

variable "machine_type" {
  description = "gke machine to be used for a node(defaults to e2.medium)"
  default     = "e2-medium"
}

variable "sa_id" {
  description = "gcp service account id"
  default     = "projects/gads21/serviceAccounts/gads21@gads21.iam.gserviceaccount.com"
}


