output "instance_ip_addr" {
  value       = google_compute_address.vm_static_ip.address[count.index]
  description = "The private IP address of the main server instance."
}