locals {
  webservers = [
    for inst in yandex_compute_instance.web : {
      name    = inst.name
      nat_ip  = inst.network_interface[0].nat_ip_address
      fqdn    = "${inst.name}.ru-central1.internal"
    }
  ]

  databases = [
    for inst in yandex_compute_instance.database : {
      name    = inst.name
      nat_ip  = inst.network_interface[0].nat_ip_address
      fqdn    = "${inst.name}.ru-central1.internal"
    }
  ]

  storage = [
    {
      name    = yandex_compute_instance.storage.name
      nat_ip  = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn    = "${yandex_compute_instance.storage.name}.ru-central1.internal"
    }
  ]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/hosts.tftpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })
  filename = "${path.module}/inventory/hosts.ini"
}