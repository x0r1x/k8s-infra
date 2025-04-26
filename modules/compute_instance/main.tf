terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_compute_image" "vm_images" {
  family   = var.family_id
}

resource "yandex_compute_instance_group" "master" {
  name               = "k8s-master-group"
  service_account_id = var.service_account_id
  deletion_protection = false

  instance_template {
    name = "master-{instance.index}"
    platform_id = "standard-v2"
    resources {
      cores  = var.master_resources.cores
      memory = var.master_resources.memory
    }

    boot_disk {
      initialize_params {
        image_id = yandex_compute_image.vm_images.id
        size     = 30
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_ids         = var.subnet_ids
      nat                = var.nat
      security_group_ids = [var.security_group_id]
    }

    metadata = {
      ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
    }

    labels = {
      instance_group = "k8s-master"
    }
  }

  load_balancer {
    target_group_name        = "k8s-master"
    target_group_description = "Main group NLB Control plane"
  }

  scale_policy {
    fixed_scale {
      size = var.master_count
    }
  }

  allocation_policy {
    zones = var.zones
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
}

resource "yandex_compute_instance_group" "node" {
  name               = "k8s-node-group"
  service_account_id = var.service_account_id
  deletion_protection = false

  instance_template {
    name = "node-{instance.index}"
    platform_id = "standard-v2"
    resources {
      cores  = var.node_resources.cores
      memory = var.node_resources.memory
    }

    boot_disk {
      initialize_params {
        image_id = yandex_compute_image.vm_images.id
        size     = 30
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_ids         = var.subnet_ids
      nat                = var.nat
      security_group_ids = [var.security_group_id]
    }

    metadata = {
      ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
    }

    labels = {
      instance_group = "k8s-node"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }

  application_load_balancer {
    target_group_name        = "k8s-node"
    target_group_description = "Main group ALB workers"
  }

  allocation_policy {
    zones = var.zones
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
}