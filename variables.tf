# Project configuration
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

# Compute module variables
variable "instance_names" {
  type        = list(string)
  description = "List of VM instance names"
  default     = []
}

variable "disk_size" {
  type        = map(number)
  description = "Disk size map per instance"
  default     = {}
}

# Network module variables
variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "gke-network"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "gke-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "pods_cidr" {
  description = "CIDR range for GKE pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "services_cidr" {
  description = "CIDR range for GKE services"
  type        = string
  default     = "10.2.0.0/20"
}

# Service Account module variables
variable "service_account_name" {
  description = "Name of the service account for GKE nodes"
  type        = string
  default     = "gke-node-sa"
}

# GKE module variables
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "gke_location_zone" {
  description = "Zone for GKE cluster (e.g., us-central1-a). Set this for single-zone cluster. Leave empty if using region."
  type        = string
  default     = ""
}

variable "gke_location_region" {
  description = "Region for GKE cluster (e.g., us-central1). Set this for regional cluster. Leave empty if using zone."
  type        = string
  default     = ""
}

variable "gke_node_machine_type" {
  description = "Machine type for GKE nodes (e.g., e2-medium, e2-standard-4, n1-standard-2)"
  type        = string
  default     = "e2-medium"
}

variable "gke_node_disk_size" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 20
}

variable "gke_node_disk_type" {
  description = "Disk type for GKE nodes (pd-standard, pd-balanced, pd-ssd)"
  type        = string
  default     = "pd-balanced"
}

variable "gke_node_image_type" {
  description = "OS image type for GKE nodes (COS, UBUNTU, UBUNTU_CONTAINERD, WINDOWS_LTSC). Use UBUNTU_CONTAINERD for Ubuntu 22.04 LTS"
  type        = string
  default     = "COS"
}

variable "gke_node_count" {
  description = "Initial number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "gke_min_nodes" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "gke_max_nodes" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 3
}

variable "gke_release_channel" {
  description = "GKE release channel (UNSPECIFIED, RAPID, REGULAR, STABLE)"
  type        = string
  default     = "REGULAR"
}

variable "gke_deletion_protection" {
  description = "Enable deletion protection for GKE cluster. Set to false to allow cluster deletion."
  type        = bool
  default     = false
}

variable "enable_gke" {
  description = "Enable GKE cluster provisioning"
  type        = bool
  default     = true
}
