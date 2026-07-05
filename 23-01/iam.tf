# Сервисный аккаунт для Master ноды
resource "yandex_iam_service_account" "k8s_master_sa" {
  name = "${var.cluster_name}-master-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "master_sa_roles" {
  for_each = toset([
    "k8s.clusters.agent",      # Управление кластером
    "vpc.publicAdmin",         # Выдача публичного IP мастеру
    "load-balancer.admin",     # Создание балансировщиков для сервисов
    "vpc.admin"                # Управление сетевыми ресурсами
  ])
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.k8s_master_sa.id}"
}

# Сервисный аккаунт для Worker нод
resource "yandex_iam_service_account" "k8s_node_sa" {
  name = "${var.cluster_name}-node-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "node_sa_roles" {
  for_each = toset([
    "container-registry.images.puller"  # Скачивание образов из Container Registry
  ])
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.k8s_node_sa.id}"
}