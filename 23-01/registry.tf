# 1. Создаем сам Container Registry
resource "yandex_container_registry" "k8s_registry" {
  name      = "${var.cluster_name}-registry"
  folder_id = var.folder_id

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

# 2. Создаем репозиторий внутри реестра
resource "yandex_container_repository" "app_repo" {
  name = "${yandex_container_registry.k8s_registry.id}/app"
}