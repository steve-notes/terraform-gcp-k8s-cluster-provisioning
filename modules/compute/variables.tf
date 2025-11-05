variable "instance_names" {
  type = list(string)
  #default = ["masternode", "workernode1", "workernode2"]
  #default = ["workernode1"]
  # default = ["test"]
  default = []
}

variable "image_name" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "default_disk_type" {
  type    = string
  default = "pd-balanced" # pd-standard, pd-balanced, pd-ssd
}

variable "disk_type" {
  type    = map(string)
  default = {}
}

variable "default_disk_size" {
  type    = number
  default = 50
}

variable "disk_size" {
  type    = map(number)
  default = {}
}

