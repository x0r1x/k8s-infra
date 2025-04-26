network = {
  network_name = "k8s-network"
  subnets = {
    "ru-central1-a" = "10.130.0.0/24",
    "ru-central1-b" = "10.129.0.0/24",
    "ru-central1-d" = "10.128.0.0/24"
  }
}

registry = {
  registry_name = "app-registry"
  repository_name = "test-app"
}

source_image = "fd84b1mojb8650b9luqd"