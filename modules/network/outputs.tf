output "network_id" {
  value       = yandex_vpc_network.network.id
  description = "ID of the created VPC network"
}

output "zones" {
  value = [for s in yandex_vpc_subnet.subnet : s.zone]
  description = "List of all zones"
}

output "subnet_ids" {
  value = [for s in yandex_vpc_subnet.subnet : s.id]
  description = "List of all created subnet IDs"
}

output "security_group_id" {
  value = yandex_vpc_security_group.k8s_sg.id
  description = "ID of Security group "
}
