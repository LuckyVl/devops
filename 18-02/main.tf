# =============================================================================
# Описание: Основные ресурсы инфраструктуры
# =============================================================================

# --------------------------
# Network Resources
# --------------------------
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop_web" {
  name           = "${var.vpc_name}-web"
  zone           = var.subnet_web_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet_web_cidr
}

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
  name        = var.vm_web_name
  platform_id = var.vm_platform_id
  zone        = var.vm_web_zone

  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_web.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_web.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = var.vm_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

# --------------------------
# VM DB
# --------------------------
data "yandex_compute_image" "ubuntu_db" {
  family = var.vm_image_family
}

resource "yandex_compute_instance" "platform_db" {
  name        = var.vm_db_name
  platform_id = var.vm_platform_id
  zone        = var.vm_db_zone

  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = var.vm_db_nat
  }

  metadata = {
    serial-port-enable = var.vm_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}