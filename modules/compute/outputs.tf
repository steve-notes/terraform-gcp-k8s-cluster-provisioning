# if only have 1 instance 
#output "instance_tags" {
#value = google_compute_instance.vm_instance[0].name
#}

# if have multiple instance
output "instance_tags" {
  value = flatten([for instance in google_compute_instance.vm_instance : instance.name])
}

output "instance_external_ips" {
  description = "Ephemeral external IPv4 per instance."
  value = {
    for name, instance in google_compute_instance.vm_instance :
    name => try(instance.network_interface[0].access_config[0].nat_ip, null)
  }
}
