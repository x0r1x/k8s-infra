# Создание Backend Group для ALB
resource "yandex_alb_backend_group" "app_backend_group" {
    name = "app-backend-group"

    http_backend {
        name             = "app-http-backend"
        weight           = 1
        port             = 80
        target_group_ids = [yandex_compute_instance_group.node.application_load_balancer[0].target_group_id]

        healthcheck {
            timeout  = "10s"
            interval = "2s"

            http_healthcheck {
                path = "/app" # Проверка корневого пути
            }
        }
    }

    depends_on = [yandex_compute_instance_group.node] # Явная зависимость
}

# Создание HTTP Router для ALB
resource "yandex_alb_http_router" "app_router" {
    name = "app-http-router"
}

# Создание Virtual Host для ALB
resource "yandex_alb_virtual_host" "app_virtual_host" {
    name           = "app-virtual-host"
    http_router_id = yandex_alb_http_router.app_router.id

    route {
        name = "app-route"
        http_route {
            # Условие совпадения пути
            # route.http_route.http_match.path
            http_match {
                path {
                    prefix = "/app"
                }
            }
            # Действие маршрута
            http_route_action {
                backend_group_id = yandex_alb_backend_group.app_backend_group.id
            }
        }
    }
    depends_on = [yandex_alb_backend_group.app_backend_group] # Явная зависимость
}

# Создание Application Load Balancer (ALB)
resource "yandex_alb_load_balancer" "app_alb" {
    name = "app-alb"
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
        name = "app-http-listener"
        endpoint {
            address {
                external_ipv4_address {}
            }
            ports = [80]
        }
        http {
            handler {
                http_router_id = yandex_alb_http_router.app_router.id
            }
        }
    }
    depends_on = [yandex_alb_http_router.app_router] # Явная зависимость
}