# =============================================================================
# Описание: Локальные переменные для инфраструктуры
# =============================================================================

locals {
  # Имена ВМ через интерполяцию нескольких переменных
  vm_web_name = "netology-${var.vpc_name}-platform-web"
  vm_db_name  = "netology-${var.vpc_name}-platform-db"

  # Общие метаданные для всех ВМ
  common_metadata = {
    serial-port-enable = var.vm_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}