output "vm_list" {
  description = "Список всех виртуальных машин с name, id, fqdn"
  value = concat(
    [
      for inst in yandex_compute_instance.web : {
      name = inst.name
      id   = inst.id
      fqdn = "${inst.name}.ru-central1.internal"
    }
    ],

    [
      for inst in yandex_compute_instance.database : {
      name = inst.name
      id   = inst.id
      fqdn = "${inst.name}.ru-central1.internal"
    }
    ],

    [
      {
        name = yandex_compute_instance.storage.name
        id   = yandex_compute_instance.storage.id
        fqdn = "${yandex_compute_instance.storage.name}.ru-central1.internal"
      }
    ]
  )
}

output "webservers" {
  description = "Список web-серверов"
  value = [
    for inst in yandex_compute_instance.web : {
      name = inst.name
      id   = inst.id
      fqdn = "${inst.name}.ru-central1.internal"
    }
  ]
}

output "databases" {
  description = "Список баз данных"
  value = [
    for inst in yandex_compute_instance.database : {
      name = inst.name
      id   = inst.id
      fqdn = "${inst.name}.ru-central1.internal"
    }
  ]
}

output "storage" {
  description = "Хранилище"
  value = {
    name = yandex_compute_instance.storage.name
    id   = yandex_compute_instance.storage.id
    fqdn = "${yandex_compute_instance.storage.name}.ru-central1.internal"
  }
}