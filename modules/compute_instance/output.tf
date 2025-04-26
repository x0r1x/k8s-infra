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

output "instance_ips" {
  description = "IP-adress all node of cluster"
  value = concat(
    [for instance in yandex_compute_instance_group.master.instances : instance.network_interface[0].nat_ip_address],
    [for instance in yandex_compute_instance_group.node.instances : instance.network_interface[0].nat_ip_address]
  )
}