variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
  default     = "gke-node-sa"
}

variable "service_account_display_name" {
  description = "Display name of the service account"
  type        = string
  default     = "GKE Node Service Account"
}

