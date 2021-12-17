variable "project" {
  description = "google cloud project name"
  default     = "gads21"
}

variable "region" {
  description = "deployment regions"
  default     = "us-east1"
}


variable "creds_path"{
description = "google cloud service account path"
default = "./gads21-service.json"
}
