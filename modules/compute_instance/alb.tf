# Создание Backend Group для ALB
resource "yandex_alb_backend_group" "backend_group" {
    name = "backend-group"

    http_backend {
        name             = "http-backend"
        weight           = 1
        port             = 80
        target_group_ids = [yandex_compute_instance_group.node.application_load_balancer[0].target_group_id]

        healthcheck {
            timeout  = "10s"
            interval = "2s"

            http_healthcheck {
                path = "/" # Проверка корневого пути
            }
        }
    }

    depends_on = [yandex_compute_instance_group.node] # Явная зависимость
}

# Создание HTTP Router для ALB
resource "yandex_alb_http_router" "router" {
    name = "http-router"
}

# Создание Virtual Host для ALB
resource "yandex_alb_virtual_host" "virtual_host" {
    name           = "virtual-host"
    http_router_id = yandex_alb_http_router.router.id

    route {
        name = "route"
        http_route {
            http_route_action {
                backend_group_id = yandex_alb_backend_group.backend_group.id
            }
        }
    }
    depends_on = [yandex_alb_backend_group.backend_group] # Явная зависимость
}

# Создание Application Load Balancer (ALB)
resource "yandex_alb_load_balancer" "alb" {
    name = "application-lb"
    network_id = var.network_id

    allocation_policy {
        dynamic location {
            for_each = yandex_compute_instance_group.master.instances
            content {
                zone_id   = location.value.zone_id
                subnet_id = location.value.network_interface[0].subnet_id
            }
        }
    }

    listener {
        name = "http-listener"
        endpoint {
            address {
                external_ipv4_address {}
            }
            ports = [80]
        }
        http {
            handler {
                http_router_id = yandex_alb_http_router.router.id
            }
        }
    }
    depends_on = [yandex_alb_http_router.router] # Явная зависимость
}