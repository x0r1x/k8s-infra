output "registry_id" {
  value = "cr.yandex/${yandex_container_registry.main.id}"
}

output "repository_url" {
  value = "cr.yandex/${yandex_container_registry.main.id}/${var.repository_name}"
}