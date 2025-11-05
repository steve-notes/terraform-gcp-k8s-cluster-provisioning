variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "Location (region or zone) for the GKE cluster"
  type        = string
}

variable "network" {
  description = "VPC network name or self link"
  type        = string
}

variable "subnetwork" {
  description = "Subnet name or self link"
  type        = string
}

variable "cluster_secondary_range" {
  description = "Name of the secondary IP range for pods"
  type        = string
}

variable "services_secondary_range" {
  description = "Name of the secondary IP range for services"
  type        = string
}

variable "release_channel" {
  description = "GKE release channel (UNSPECIFIED, RAPID, REGULAR, STABLE)"
  type        = string
  default     = "REGULAR"
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_disk_size" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 100
}

variable "node_disk_type" {
  description = "Disk type for GKE nodes (pd-standard, pd-balanced, pd-ssd)"
  type        = string
  default     = "pd-balanced"
}

variable "node_image_type" {
  description = "OS image type for GKE nodes (COS, UBUNTU, UBUNTU_CONTAINERD, WINDOWS_LTSC)"
  type        = string
  default     = "COS"
}

variable "node_count" {
  description = "Initial number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "min_nodes" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 3
}

variable "node_service_account" {
  description = "Service account email for GKE nodes"
  type        = string
}

variable "preemptible" {
  description = "Use preemptible instances for nodes"
  type        = bool
  default     = false
}

variable "auto_repair" {
  description = "Enable auto repair for nodes"
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enable auto upgrade for nodes"
  type        = bool
  default     = true
}

variable "enable_network_policy" {
  description = "Enable network policy"
  type        = bool
  default     = false
}

variable "enable_private_nodes" {
  description = "Enable private nodes (no external IP)"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint (master only accessible from VPC)"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for master nodes (required if private_cluster enabled)"
  type        = string
  default     = "172.16.0.0/28"
}

variable "cluster_labels" {
  description = "Labels to apply to the cluster"
  type        = map(string)
  default     = {}
}

variable "node_labels" {
  description = "Labels to apply to the nodes"
  type        = map(string)
  default     = {}
}

variable "node_tags" {
  description = "Tags to apply to the nodes"
  type        = list(string)
  default     = []
}

variable "workload_metadata_mode" {
  description = "Workload metadata mode (GCE_METADATA, GKE_METADATA)"
  type        = string
  default     = "GKE_METADATA"
}

variable "deletion_protection" {
  description = "Enable deletion protection for the cluster. Set to false to allow cluster deletion."
  type        = bool
  default     = true
}

