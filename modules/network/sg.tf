resource "yandex_vpc_security_group" "k8s_sg" {
  name        = "k8s-security-group"
  description = "Security group for Kubernetes cluster"
  network_id  = yandex_vpc_network.network.id

  ingress {
    protocol          = "TCP"
    description       = "healthchecks"
    predefined_target = "loadbalancer_healthchecks"
  }

  ingress {
    protocol          = "ICMP"
    description       = "ICMP"
    predefined_target = "self_security_group"
  }

  ingress {
    protocol          = "ANY"
    description       = "any traffic inside group"
    predefined_target = "self_security_group"
  }

  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API server"
    port          = 6443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "SSH access"
    port          = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   protocol       = "TCP"
  #   description    = "NodePort services"
  #   from_port      = 30000
  #   to_port        = 32767
  #   v4_cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    protocol       = "TCP"
    description    = "NodePort services"
    from_port      = 20000
    to_port        = 25000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}