# Network Outputs
output "network_name" {
  description = "Name of the VPC network"
  value       = module.network.network_name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = module.network.subnet_name
}

# Compute Outputs (conditional)
output "instance_names" {
  description = "Nama instance yang berhasil dibuat."
  value       = length(var.instance_names) > 0 ? module.compute[0].instance_tags : []
}

output "instance_external_ips" {
  description = "Ephemeral external IP per instance."
  value       = length(var.instance_names) > 0 ? module.compute[0].instance_external_ips : {}
}

output "instance_report" {
  description = "Ringkasan nama dan IP instance untuk ditampilkan di terminal."
  value = length(var.instance_names) > 0 ? [
    for name, ip in module.compute[0].instance_external_ips :
    format("%s: %s", name, coalesce(ip, "no external IP assigned"))
  ] : []
}

# GKE Outputs (conditional)
output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = var.enable_gke ? module.gke[0].cluster_name : null
}

output "gke_cluster_endpoint" {
  description = "Endpoint for the GKE cluster"
  value       = var.enable_gke ? module.gke[0].cluster_endpoint : null
  sensitive   = true
}

output "gke_cluster_location" {
  description = "Location of the GKE cluster"
  value       = var.enable_gke ? module.gke[0].cluster_location : null
}

output "gke_node_pool_name" {
  description = "Name of the node pool"
  value       = var.enable_gke ? module.gke[0].node_pool_name : null
}

# Output untuk konfigurasi kubectl
output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value = var.enable_gke ? format(
    "gcloud container clusters get-credentials %s --location %s --project %s",
    module.gke[0].cluster_name,
    module.gke[0].cluster_location,
    var.project_id
  ) : null
}
