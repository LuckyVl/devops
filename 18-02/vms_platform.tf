# =============================================================================
# Описание: Переменные для виртуальных машин и их подсетей
# =============================================================================

# --------------------------
# Subnet Variables
# --------------------------
variable "subnet_web_zone" {
  type        = string
  description = "Availability zone for web subnet"
  default     = "ru-central1-a"
}

variable "subnet_web_cidr" {
  type        = list(string)
  description = "CIDR block for web subnet"
  default     = ["10.0.1.0/24"]
}

variable "subnet_db_zone" {
  type        = string
  description = "Availability zone for DB subnet"
  default     = "ru-central1-b"
}

variable "subnet_db_cidr" {
  type        = list(string)
  description = "CIDR block for DB subnet"
  default     = ["10.0.2.0/24"]
}

# =============================================================================
# ЗАКОММЕНТИРОВАНО: Более не используются
# =============================================================================
# variable "vm_web_name" {
#   type        = string
#   description = "Name of the web virtual machine"
#   default     = "netology-develop-platform-web"
# }

# variable "vm_web_cores" {
#   type        = number
#   description = "Number of CPU cores for web VM"
#   default     = 2
# }

# variable "vm_web_memory" {
#   type        = number
#   description = "RAM size in GB for web VM"
#   default     = 1
# }

# variable "vm_web_core_fraction" {
#   type        = number
#   description = "Core fraction percentage for web VM"
#   default     = 20
# }

# variable "vm_web_nat" {
#   type        = bool
#   description = "Assign NAT IP address to web VM"
#   default     = true
# }

# variable "vm_web_zone" {
#   type        = string
#   description = "Availability zone for web VM"
#   default     = "ru-central1-a"
# }

# variable "vm_db_name" {
#   type        = string
#   description = "Name of the database virtual machine"
#   default     = "netology-develop-platform-db"
# }

# variable "vm_db_cores" {
#   type        = number
#   description = "Number of CPU cores for DB VM"
#   default     = 2
# }

# variable "vm_db_memory" {
#   type        = number
#   description = "RAM size in GB for DB VM"
#   default     = 2
# }

# variable "vm_db_core_fraction" {
#   type        = number
#   description = "Core fraction percentage for DB VM"
#   default     = 20
# }

# variable "vm_db_nat" {
#   type        = bool
#   description = "Assign NAT IP address to DB VM"
#   default     = true
# }

# variable "vm_db_zone" {
#   type        = string
#   description = "Availability zone for DB VM"
#   default     = "ru-central1-b"
# }

# variable "vm_serial_port_enable" {
#   type        = number
#   description = "Enable serial console for all VMs (1 = enabled)"
#   default     = 1
# }