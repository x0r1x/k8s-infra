output "instance_ips" {
  description = "IP-adress all node of cluster"
  value = module.compute_instance.instance_ips
}