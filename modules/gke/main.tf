# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location

  # Remove default node pool
  remove_default_node_pool = true
  # initial_node_count       = 0  # Set to 0 karena kita akan membuat custom node pool
  initial_node_count       = 1  

  # Network configuration
  network    = var.network
  subnetwork = var.subnetwork

  # IP allocation policy untuk VPC-native cluster
  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range
    services_secondary_range_name = var.services_secondary_range
  }

  # Release channel
  release_channel {
    channel = var.release_channel
  }

  # Master auth configuration
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Enable Workload Identity (required for GKE_METADATA mode)
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Resource labels
  resource_labels = var.cluster_labels

  # Enable network policy
  network_policy {
    enabled = var.enable_network_policy
  }

  # Enable private cluster (optional)
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # Deletion protection (set to false to allow cluster deletion)
  deletion_protection = var.deletion_protection

  # Lifecycle rules untuk memastikan cleanup
  lifecycle {
    create_before_destroy = false
  }
}

# Node Pool untuk GKE
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    preemptible  = var.preemptible
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    disk_type    = var.node_disk_type

    # OS Image Configuration
    image_type = var.node_image_type

    service_account = var.node_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = var.node_labels
    tags   = var.node_tags

    # Workload metadata config
    workload_metadata_config {
      mode = var.workload_metadata_mode
    }
  }
}

