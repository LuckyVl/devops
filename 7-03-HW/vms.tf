
#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion" #Имя ВМ в облачной консоли
  hostname    = "bastion" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.bastion.id]
  }
}


resource "yandex_compute_instance" "server-1" {
  name        = "server-1" #Имя ВМ в облачной консоли
  hostname    = "server-1" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 4
    memory        = 8
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  }
}

resource "yandex_compute_instance" "server-2" {
  name        = "server-2" #Имя ВМ в облачной консоли
  hostname    = "server-2" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 4
    memory        = 8
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]

  }
}

resource "yandex_compute_instance" "server-3" {
  name        = "server-3" #Имя ВМ в облачной консоли
  hostname    = "server-3" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 4
    memory        = 8
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  }
}


resource "yandex_compute_instance" "server-4" {
  name        = "server-4" #Имя ВМ в облачной консоли
  hostname    = "server-4" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 4
    memory        = 8
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  }
}

resource "local_file" "inventory" {
  content  = <<-XYZ
  [bastion]
  # hostname = ${yandex_compute_instance.bastion.hostname}
  ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} ansible_user=user

  [server]
  # hostname = ${yandex_compute_instance.server-1.hostname}
  ${yandex_compute_instance.server-1.network_interface.0.ip_address} ansible_user=user
  # hostname = ${yandex_compute_instance.server-2.hostname}
  ${yandex_compute_instance.server-2.network_interface.0.ip_address} ansible_user=user
  # hostname = ${yandex_compute_instance.server-3.hostname}
  ${yandex_compute_instance.server-3.network_interface.0.ip_address} ansible_user=user
  # hostname = ${yandex_compute_instance.server-4.hostname}
  ${yandex_compute_instance.server-4.network_interface.0.ip_address} ansible_user=user

  [webservers:vars]
  ansible_ssh_common_args='-o ProxyJump="user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

  [hw-hosts:vars]
  ansible_ssh_common_args='-o ProxyJump="user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

  [connect-ssh-hosts]
  ssh user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} user@${yandex_compute_instance.server-1.network_interface.0.ip_address}
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} user@${yandex_compute_instance.server-2.network_interface.0.ip_address}
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} user@${yandex_compute_instance.server-3.network_interface.0.ip_address}
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} user@${yandex_compute_instance.server-4.network_interface.0.ip_address}

  [connect-proxy-hosts]
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} -L 8080:${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}:80 user@${yandex_compute_instance.server-1.network_interface.0.ip_address} -N
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} -L 8080:${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}:80 user@${yandex_compute_instance.server-2.network_interface.0.ip_address} -N
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} -L 8080:${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}:80 user@${yandex_compute_instance.server-3.network_interface.0.ip_address} -N
  ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} -L 8080:${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}:80 user@${yandex_compute_instance.server-4.network_interface.0.ip_address} -N


  XYZ
  filename = "./hosts.ini"
}



