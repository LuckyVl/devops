# =============================================================================
# Описание: Локальные переменные для инфраструктуры
# =============================================================================

locals {
  vm_web_name = "netology-${var.vpc_name}-platform-web"
  vm_db_name  = "netology-${var.vpc_name}-platform-db"

  common_metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}