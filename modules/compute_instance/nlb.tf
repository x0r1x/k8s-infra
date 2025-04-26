# Создание Network Load Balancer (NLB)
resource "yandex_lb_network_load_balancer" "controllers-lb" {
    name = "controllers-lb"

    listener {
        name = "controllers-lb-listener"
        port = 6443
        external_address_spec {
        ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.master.load_balancer[0].target_group_id

    healthcheck {
        name = "tcp"
        tcp_options {
            port = 6443
        }
    }
  }
}