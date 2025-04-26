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

family_id = "ubuntu-2404-lts-oslogin"