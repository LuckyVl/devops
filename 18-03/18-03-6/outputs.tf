output "vm_list" {
  description = "Список всех виртуальных машин с name, id, fqdn"
  value = concat(
    [
      for inst in yandex_compute_instance.example : {
      name = inst.name
      id   = inst.id
      fqdn = "${inst.hostname}.ru-central1.internal"
    }
    ],

      length(yandex_compute_instance.bastion) > 0 ? [
      {
        name = yandex_compute_instance.bastion[0].name
        id   = yandex_compute_instance.bastion[0].id
        fqdn = "${yandex_compute_instance.bastion[0].hostname}.ru-central1.internal"
      }
    ] : []
  )
}

output "webservers" {
  description = "Список web-серверов"
  value = [
    for inst in yandex_compute_instance.example : {
      name = inst.name
      id   = inst.id
      fqdn = "${inst.hostname}.ru-central1.internal"
    }
  ]
}

output "bastion" {
  description = "Bastion сервер"
  value = length(yandex_compute_instance.bastion) > 0 ? {
    name = yandex_compute_instance.bastion[0].name
    id   = yandex_compute_instance.bastion[0].id
    fqdn = "${yandex_compute_instance.bastion[0].hostname}.ru-central1.internal"
    nat_ip = yandex_compute_instance.bastion[0].network_interface[0].nat_ip_address
  } : null
}

output "passwords" {
  description = "Сгенерированные пароли для ВМ"
  value = {
    solo   = random_password.solo.result
    count  = [for p in random_password.count : p.result]
    each   = { for k, v in random_password.each : k => v.result }
  }
  sensitive = true
}