resource "google_compute_firewall" "k8s_firewall" {
  for_each  = var.rules
  name      = each.key
  network   = var.network
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = each.value.protocol
    ports    = each.value.port
  }


  source_ranges = var.source_ranges

  target_tags = var.target_tags

  # For Dynamically fetch VM tags
  #target_tags   = var.google_compute_instance.vm_instance[*].target_tags

}
