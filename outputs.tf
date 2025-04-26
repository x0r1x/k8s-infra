# Output для GitHub Actions
output "kubespray_inventory" {
  value = templatefile("${path.module}/templates/inventory.yml.tpl", {
    master_public_ips  = module.compute_instance.master_public_ips
    master_private_ips = module.compute_instance.master_private_ips
    node_public_ips   = module.compute_instance.node_public_ips
    node_private_ips   = module.compute_instance.node_private_ips
  })
}