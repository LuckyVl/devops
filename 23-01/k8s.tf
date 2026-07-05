# Ждём распространения IAM прав перед созданием кластера
resource "null_resource" "iam_propagation_delay" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.master_sa_roles,
    yandex_resourcemanager_folder_iam_member.node_sa_roles
  ]

  provisioner "local-exec" {
    command = "sleep 120"
  }
}
# Создаем сам Kubernetes кластер (Master)
resource "yandex_kubernetes_cluster" "k8s_cluster" {
  depends_on = [null_resource.iam_propagation_delay]

  name       = var.cluster_name
  network_id = yandex_vpc_network.k8s_network.id

  master {
    public_ip = true

    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.k8s_subnet.id
    }

    security_group_ids = [yandex_vpc_security_group.k8s_master_sg.id]
  }

  service_account_id      = yandex_iam_service_account.k8s_master_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_node_sa.id

  release_channel = "REGULAR"
}

# Создаем группу нод (Worker nodes)
resource "yandex_kubernetes_node_group" "k8s_nodes" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "${var.cluster_name}-node-group"

  instance_template {
    platform_id = "standard-v3"

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 100
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.k8s_subnet.id]
      nat        = false  # ← ИЗМЕНИТЬ: был true, стал false

      security_group_ids = [yandex_vpc_security_group.k8s_nodes_sg.id]
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 1
      min     = 1
      max     = 5
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }
}

# получаем информацию для подключения к кубу
resource "null_resource" "get_credentials" {
  depends_on = [yandex_kubernetes_cluster.k8s_cluster]

  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials --name ${yandex_kubernetes_cluster.k8s_cluster.name} --external --force"
  }
}
