resource "yandex_compute_disk" "additional" {
  count = 3

  name = "disk-${count.index + 1}"
  type = var.disk_type
  zone = var.default_zone
  size = 1
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.platform_id
  zone        = var.default_zone
  hostname    = "storage"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.disk_type
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional
    content {
      disk_id = secondary_disk.value.id
      mode    = "READ_WRITE"
    }
  }

  depends_on = [yandex_compute_disk.additional]
}