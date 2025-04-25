terraform {
  required_version = "~>1.11"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    key                         = "terraform/state.tfstate" # Путь к файлу состояния
    region                      = "ru-central1"
    bucket                      = "kashin-terraform-state-infra" # Переопределяется через -backend-config
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
}


provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_default_zone
  service_account_key_file = base64decode(var.yc_sa_key)
}