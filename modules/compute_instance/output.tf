output "master_public_ips" {
  value = yandex_compute_instance_group.master.instances[*].network_interface[0].nat_ip_address
}

output "master_private_ips" {
  value = yandex_compute_instance_group.master.instances[*].network_interface[0].ip_address
}

output "node_public_ips" {
  value = yandex_compute_instance_group.node.instances[*].network_interface[0].nat_ip_address
}

output "node_private_ips" {
  value = yandex_compute_instance_group.node.instances[*].network_interface[0].ip_address
}
