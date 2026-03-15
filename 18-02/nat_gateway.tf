# =============================================================================
# Описание: Только NAT Gateway
# =============================================================================

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "netology-${var.vpc_name}-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat_routes" {
  name       = "netology-${var.vpc_name}-nat-routes"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}