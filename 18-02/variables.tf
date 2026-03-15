# =============================================================================
# Описание: Общие переменные облака
# =============================================================================

# --------------------------
# Cloud Variables
# --------------------------
variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  default     = "b1goo5pkjq9ldvqkgp0l"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
  default     = "b1g7c66oo5q6sjc4bdlt"
}

# --------------------------
# Network Variables
# --------------------------

variable "vpc_name" {
  type        = string
  description = "VPC network & subnet name prefix"
  default     = "develop"
}

# --------------------------
# SSH Variables
# --------------------------
variable "vms_ssh_root_key" {
  type        = string
  description = "SSH public key for VM access"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJf3ksspcHYrhvtvNKfw6CcljIupIoH+4J+kiT6093FHwqaAmQvsBdB6kkLsSxEpsZBixlVcGQY+zkVy9BvdrBHnG5bdBdEZYe0rKRk4ILhwbLCMfQ4CJPq549tmqUILGCy3NArkr6+EDCW6hTUY6+ngwq/eFKNoxl/OV30b3eWdm7zGBnwLwOcUdSiGokyDgwW/JjAK3D84r4+Cn4pNj2w2/kcDPXHEI6vjENrT0/xyrwdZCsAijxQSD6ePMPg+ylM0Ve6glv1OR6NCHdAZ1St7jvxZe7OdqsY87QfK2goMunP0ur/JdJtzNSm4tLzg7+ynRfywY9PzRrzdJ3g+mHzWpXmjNUAQJGZ5XMuIUk5AumVthKaErpAEmRBWKIcY0wMFef1bmRqKu2upf7bYwSNTopFcKMmsvdF20qdF4kpD8Oz5vGRn10tSi9dV0F4ZOb7cV00KipTmU6IyvpWcsz4gRris+TWL8Jk1DRWG0XKiDz5p/YigEzDV7aSmLlmME= filatovk@server"
}

# --------------------------
# Common VM Variables
# --------------------------
variable "vm_platform_id" {
  type        = string
  description = "Platform type for all VMs (e.g., standard-v3)"
  default     = "standard-v3"
}

variable "vm_image_family" {
  type        = string
  description = "Image family for all VMs (e.g., ubuntu-2004-lts)"
  default     = "ubuntu-2004-lts"
}

variable "vm_preemptible" {
  type        = bool
  description = "Preemptible mode for all VMs"
  default     = true
}

# --------------------------
# Resources Map
# --------------------------
variable "vms_resources" {
  type = map(object({
    zone          = string
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
    nat           = bool
  }))
  description = "Resources configuration for all VMs"
  default = {
    web = {
      zone          = "ru-central1-a"
      cores         = 2
      memory        = 1
      core_fraction = 20
      hdd_size      = 5
      hdd_type      = "network-hdd"
      nat           = true
    }
    db = {
      zone          = "ru-central1-b"
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 5
      hdd_type      = "network-hdd"
      nat           = true
    }
  }
}

# --------------------------
# Common Metadata Map
# --------------------------
variable "vm_metadata" {
  type = object({
    serial-port-enable = number
    ssh-keys           = string
  })
  description = "Common metadata for all VMs"
  default = {
    serial-port-enable = 1
    ssh-keys           = ""
  }
}

variable "test" {
  type = list(map(list(string)))
  description = "Complex structure for SSH configs"
  default = [
    {
      "dev1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
        "10.0.1.7"
      ]
    },
    {
      "dev2" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
        "10.0.2.29"
      ]
    },
    {
      "prod1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
        "10.0.1.30"
      ]
    }
  ]
}

# =============================================================================
# ЗАКОММЕНТИРОВАНО: Более не используются
# =============================================================================
# variable "default_zone" {
#  type        = string
#  description = "Default availability zone for provider and resources"
#  default     = "ru-central1-a"
#}