variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    { vm_name = "main", cpu = 4, ram = 8, disk_volume = 50 },
    { vm_name = "replica", cpu = 2, ram = 4, disk_volume = 30 }
  ]
}

locals {
  vm_map = { for vm in var.each_vm : vm.vm_name => vm }
}

resource "yandex_compute_instance" "database" {
  for_each = local.vm_map

  name        = each.value.vm_name
  platform_id = var.platform_id
  zone        = var.default_zone
  hostname    = each.value.vm_name

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.disk_type
      size     = each.value.disk_volume
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

  depends_on = [yandex_compute_instance.web]
}