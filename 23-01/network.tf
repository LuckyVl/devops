resource "yandex_vpc_network" "k8s_network" {
  name = "${var.cluster_name}-network"
}

resource "yandex_vpc_subnet" "k8s_subnet" {
  name           = "${var.cluster_name}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = ["10.10.0.0/16"]
}