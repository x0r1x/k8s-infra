# Создание Backend Group для ALB
resource "yandex_alb_backend_group" "mon_backend_group" {
    name = "mon-backend-group"

    http_backend {
        name             = "mon-http-backend"
        weight           = 1
        port             = 24807
        target_group_ids = [yandex_compute_instance_group.node.application_load_balancer[0].target_group_id]

        healthcheck {
            timeout  = "10s"
            interval = "2s"

            http_healthcheck {
                path = "/api/health" # Проверка корневого пути
            }
        }
    }

    depends_on = [yandex_compute_instance_group.node] # Явная зависимость
}

# Создание HTTP Router для ALB
resource "yandex_alb_http_router" "mon_router" {
    name = "mon-http-router"
}

# Создание Virtual Host для ALB
resource "yandex_alb_virtual_host" "mon_virtual_host" {
    name           = "mon-virtual-host"
    http_router_id = yandex_alb_http_router.router.id

    route {
        name = "mon-route"
        http_route {
            http_route_action {
                backend_group_id = yandex_alb_backend_group.mon_backend_group.id
            }
        }
    }
    depends_on = [yandex_alb_backend_group.mon_backend_group] # Явная зависимость
}

# Создание Application Load Balancer (ALB)
resource "yandex_alb_load_balancer" "mon_alb" {
    name = "mon-alb"
    network_id = var.network_id
    security_group_ids = [var.security_group_id]

    allocation_policy {
        dynamic location {
            for_each = yandex_compute_instance_group.node.instances
            content {
                zone_id   = location.value.zone_id
                subnet_id = location.value.network_interface[0].subnet_id
            }
        }
    }

    listener {
        name = "mon-http-listener"
        endpoint {
            address {
                external_ipv4_address {}
            }
            ports = [80]
        }
        http {
            handler {
                http_router_id = yandex_alb_http_router.mon_router.id
            }
        }
    }
    depends_on = [yandex_alb_http_router.mon_router] # Явная зависимость
}