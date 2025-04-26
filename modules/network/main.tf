terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "${var.network_name}-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat_route" {
  name       = "${var.network_name}-nat-route"
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id        = yandex_vpc_gateway.nat_gateway.id
  }
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = var.subnets_config

  name           = "${var.network_name}-subnet-${each.key}"
  zone           = each.key
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [each.value]
  route_table_id = yandex_vpc_route_table.nat_route.id
}