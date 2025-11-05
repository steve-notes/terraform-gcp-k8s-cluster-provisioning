output "email" {
  description = "Email of the service account"
  value       = google_service_account.gke_node.email
}

output "name" {
  description = "Name of the service account"
  value       = google_service_account.gke_node.name
}

