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
  service_account_key_file = var.yc_sa_key
}

module "network" {
  source = "./modules/network"

  network_name    = var.network.network_name
  subnets_config  = var.network.subnets
}

module "container_registry" {
  source = "./modules/container_registry"

  folder_id          = var.yc_folder_id
  registry_name      = var.registry.registry_name
  repository_name    = var.registry.repository_name
}

module "compute_instance" {
  source = "./modules/compute_instance"

  family_id = var.family_id
  network_id = module.network.network_id
  subnet_ids = module.network.subnet_ids
  zones = module.network.zones
  security_group_id = module.network.security_group_id
  ssh_username = var.ssh_username
  ssh_public_key = var.ssh_public_key
  service_account_id = var.yc_sa_id
}