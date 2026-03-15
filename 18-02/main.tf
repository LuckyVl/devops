# =============================================================================
# Описание: Основные ресурсы инфраструктуры
# =============================================================================

# --------------------------
# Network Resources
# --------------------------
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# Подсеть для Web (зона A)
resource "yandex_vpc_subnet" "develop_web" {
  name           = "${var.vpc_name}-web"
  zone           = var.subnet_web_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet_web_cidr
}

# Подсеть для DB (зона B)
resource "yandex_vpc_subnet" "develop_db" {
  name           = "${var.vpc_name}-db"
  zone           = var.subnet_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet_db_cidr
}

# --------------------------
# VM WEB
# --------------------------
data "yandex_compute_image" "ubuntu_web" {
  family = var.vm_image_family
}

resource "yandex_compute_instance" "platform_web" {
  name        = local.vm_web_name
  platform_id = var.vm_platform_id
  zone        = var.vms_resources["web"].zone

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_web.image_id
      size        = var.vms_resources["web"].hdd_size
      type        = var.vms_resources["web"].hdd_type
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_web.id
    nat       = var.vms_resources["web"].nat
  }

  metadata = local.common_metadata

  metadata_options {
    aws_v1_http_endpoint = 1
    aws_v1_http_token    = 2
    gce_http_endpoint    = 1
    gce_http_token       = 1
  }
}

# --------------------------
# VM DB
# --------------------------
data "yandex_compute_image" "ubuntu_db" {
  family = var.vm_image_family
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_name
  platform_id = var.vm_platform_id
  zone        = var.vms_resources["db"].zone

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_db.image_id
      size        = var.vms_resources["db"].hdd_size
      type        = var.vms_resources["db"].hdd_type
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = var.vms_resources["db"].nat
  }

  metadata = local.common_metadata

  metadata_options {
    aws_v1_http_endpoint = 1
    aws_v1_http_token    = 2
    gce_http_endpoint    = 1
    gce_http_token       = 1
  }
}