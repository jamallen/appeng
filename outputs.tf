output "instance_ip_addr" {
  count = var.instance_count
  value       = google_compute_address.vm_static_ip.*.address
  description = "The private IP address of the main server instance."
}