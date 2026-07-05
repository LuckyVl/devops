# Security Group для Master ноды
resource "yandex_vpc_security_group" "k8s_master_sg" {
  name        = "${var.cluster_name}-master-sg"
  description = "Security group для Kubernetes Master"
  network_id  = yandex_vpc_network.k8s_network.id

  # Правило 1: Доступ к API с вашего IP
  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API (HTTPS)"
    from_port      = 443
    to_port        = 443
    v4_cidr_blocks = var.allowed_ips
  }

  # Правило 2: Альтернативный порт API
  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API (alternative)"
    from_port      = 6443
    to_port        = 6443
    v4_cidr_blocks = var.allowed_ips
  }

  # Правило 3: Трафик от нод (через CIDR подсети)
  ingress {
    protocol       = "TCP"
    description    = "Traffic from nodes"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [yandex_vpc_subnet.k8s_subnet.v4_cidr_blocks[0]]
  }

  # Исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    from_port      = 0
    to_port        = 0
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group для Worker нод
resource "yandex_vpc_security_group" "k8s_nodes_sg" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group для Kubernetes Nodes"
  network_id  = yandex_vpc_network.k8s_network.id

  # Правило 1: Трафик между нодами
  ingress {
    protocol          = "ANY"
    description       = "Traffic between nodes"
    from_port         = 0
    to_port           = 0
    predefined_target = "self_security_group"
  }

  # Правило 2: Трафик от мастера (через CIDR подсети)
  ingress {
    protocol       = "ANY"
    description    = "Traffic from master"
    from_port      = 0
    to_port        = 0
    v4_cidr_blocks = [yandex_vpc_subnet.k8s_subnet.v4_cidr_blocks[0]]
  }

  # Правило 3: Доступ к kubelet от мастера
  ingress {
    protocol       = "TCP"
    description    = "Kubelet from master"
    from_port      = 10250
    to_port        = 10250
    v4_cidr_blocks = [yandex_vpc_subnet.k8s_subnet.v4_cidr_blocks[0]]
  }

  # Исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    from_port      = 0
    to_port        = 0
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}