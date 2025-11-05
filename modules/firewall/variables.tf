variable "network" {
  description = "VPC network name"
  type        = string
  default     = "default"
}


variable "source_ranges" {
  description = "Allow IP ranges"
  type        = list(string)
  default     = ["0.0.0.0/0"]

}

variable "target_tags" {
  description = "Target tags for firewall rules"
  type        = list(string)
  default     = ["k8s-nodes"]
}

variable "rules" {
  description = "Map of firewall rules with port mappings"
  type = map(object({
    protocol = string
    port     = list(string)
  }))
  default = {
    "allow-apiserver" = {
      protocol = "tcp"
      port     = ["6443"]
    }
    "allow-etcd" = {
      protocol = "tcp"
      port     = ["2379-2380"]
    }
    "allow-kubelet" = {
      protocol = "tcp"
      port     = ["10250"]

    }
    "allow-kube-proxy" = {
      protocol = "tcp"
      port     = ["10256"]
    }
    "allow-nodeport" = {
      protocol = "tcp"
      port     = ["30000-32767"]
    }
    "allow-ingress-http" = {
      protocol = "tcp"
      port     = ["80"]
    }
    "allow-ingress-https" = {
      protocol = "tcp"
      port     = ["443"]
    }
    "allow-icmp" = {
      protocol = "icmp"
      port     = []
    }
  }
}
