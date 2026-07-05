terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.213"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  service_account_key_file = file("~/.authorized_key.json")
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-b"
}

variable "cluster_name" {
  description = "Имя Kubernetes кластера"
  type        = string
  default     = "netology-dev-k8s-cluster"
}