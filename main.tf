# Network Module - VPC dan Subnet untuk GKE
module "network" {
  source        = "./modules/network"
  network_name  = var.network_name
  subnet_name   = var.subnet_name
  subnet_cidr   = var.subnet_cidr
  region        = var.region
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr
}

# Compute Module - VM Instances (optional)
module "compute" {
  count          = length(var.instance_names) > 0 ? 1 : 0
  source         = "./modules/compute"
  instance_names = var.instance_names
  disk_size      = var.disk_size
}

# Firewall Module (optional - uncomment if needed)
# module "firewall" {
#   source        = "./modules/firewall"
#   network       = module.network.network_name
#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = length(var.instance_names) > 0 ? tolist(module.compute[0].instance_tags) : []
#   rules         = var.firewall_rules
# }

# Service Account Module - untuk GKE Nodes
module "service_account" {
  count                        = var.enable_gke ? 1 : 0
  source                       = "./modules/service_account"
  project_id                   = var.project_id
  service_account_name         = var.service_account_name
  service_account_display_name = "GKE Node Service Account"
}

# GKE Module - Kubernetes Cluster
module "gke" {
  count                    = var.enable_gke ? 1 : 0
  source                   = "./modules/gke"
  project_id               = var.project_id
  cluster_name             = var.cluster_name
  location                 = coalesce(var.gke_location_zone, var.gke_location_region)
  network                  = module.network.network_self_link
  subnetwork               = module.network.subnetwork_self_link
  cluster_secondary_range  = module.network.pod_range_name
  services_secondary_range = module.network.service_range_name
  node_service_account     = module.service_account[0].email
  node_machine_type        = var.gke_node_machine_type
  node_disk_size           = var.gke_node_disk_size
  node_disk_type           = var.gke_node_disk_type
  node_image_type          = var.gke_node_image_type
  node_count               = var.gke_node_count
  min_nodes                = var.gke_min_nodes
  max_nodes                = var.gke_max_nodes
  release_channel          = var.gke_release_channel
  deletion_protection       = var.gke_deletion_protection

  depends_on = [
    module.network,
    module.service_account
  ]
}

# Cleanup resource untuk menghapus GKE resources sebelum network dihapus
# Resource ini akan cleanup firewall rules, forwarding rules, dan addresses
# yang dibuat otomatis oleh GKE cluster
resource "null_resource" "cleanup_before_network_destroy" {
  depends_on = [module.gke]

  # Trigger cleanup sebelum network dihapus
  # Triggers akan menyimpan nilai untuk digunakan saat destroy
  triggers = {
    cluster_name = var.enable_gke ? var.cluster_name : ""
    project_id   = var.project_id
    network_name  = var.network_name
  }

  # Cleanup saat destroy
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      if [ -n "${self.triggers.cluster_name}" ]; then
        echo "Cleaning up GKE resources before network destroy..."
        PROJECT_ID="${self.triggers.project_id}"
        CLUSTER_NAME="${self.triggers.cluster_name}"
        
        # Cleanup firewall rules
        gcloud compute firewall-rules list \
          --project="$PROJECT_ID" \
          --format="value(name)" 2>/dev/null | \
          grep -E "^gke-$CLUSTER_NAME-" | \
          while read fw; do
            gcloud compute firewall-rules delete "$fw" \
              --project="$PROJECT_ID" \
              --quiet 2>/dev/null || true
          done
        
        # Cleanup forwarding rules
        for region in us-central1 us-east1 us-west1; do
          gcloud compute forwarding-rules list \
            --project="$PROJECT_ID" \
            --regions="$region" \
            --format="value(name)" 2>/dev/null | \
            grep -E "^gk3-$CLUSTER_NAME-" | \
            while read fr; do
              gcloud compute forwarding-rules delete "$fr" \
                --region="$region" \
                --project="$PROJECT_ID" \
                --quiet 2>/dev/null || true
            done
        done
        
        # Cleanup addresses
        for region in us-central1 us-east1 us-west1; do
          gcloud compute addresses list \
            --project="$PROJECT_ID" \
            --regions="$region" \
            --format="value(name)" 2>/dev/null | \
            grep -E "^gk3-$CLUSTER_NAME-" | \
            while read addr; do
              gcloud compute addresses delete "$addr" \
                --region="$region" \
                --project="$PROJECT_ID" \
                --quiet 2>/dev/null || true
            done
        done
      fi
    EOT
  }
}

