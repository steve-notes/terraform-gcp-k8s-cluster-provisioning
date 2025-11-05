# VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false

  # Lifecycle rules untuk memastikan subnetwork dihapus dulu
  lifecycle {
    create_before_destroy = false
  }
}

# Subnet untuk GKE
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  # Secondary IP ranges untuk GKE (pod dan service)
  secondary_ip_range {
    range_name    = "${var.subnet_name}-pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "${var.subnet_name}-services"
    ip_cidr_range = var.services_cidr
  }

  # Lifecycle rules untuk memastikan cleanup
  lifecycle {
    create_before_destroy = false
  }
}

