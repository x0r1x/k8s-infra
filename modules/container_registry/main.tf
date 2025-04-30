terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_container_registry" "main" {
  name      = var.registry_name
  folder_id = var.folder_id
}

resource "yandex_container_registry_iam_binding" "pull_access" {
  registry_id = yandex_container_registry.main.id
  role        = "container-registry.images.puller"
  members     = ["serviceAccount:${var.service_account_id}"]
}

resource "yandex_container_registry_iam_binding" "push_access" {
  registry_id = yandex_container_registry.main.id
  role        = "container-registry.images.pusher"
  members     = ["serviceAccount:${var.service_account_id}"]
}

resource "yandex_container_repository" "app_repo" {
  name = "${yandex_container_registry.main.id}/${var.repository_name}"
}
