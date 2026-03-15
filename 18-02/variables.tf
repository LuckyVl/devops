###cloud vars


variable "cloud_id" {
  type = string
  default = "b1goo5pkjq9ldvqkgp0l"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type = string
  default = "b1g7c66oo5q6sjc4bdlt"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJf3ksspcHYrhvtvNKfw6CcljIupIoH+4J+kiT6093FHwqaAmQvsBdB6kkLsSxEpsZBixlVcGQY+zkVy9BvdrBHnG5bdBdEZYe0rKRk4ILhwbLCMfQ4CJPq549tmqUILGCy3NArkr6+EDCW6hTUY6+ngwq/eFKNoxl/OV30b3eWdm7zGBnwLwOcUdSiGokyDgwW/JjAK3D84r4+Cn4pNj2w2/kcDPXHEI6vjENrT0/xyrwdZCsAijxQSD6ePMPg+ylM0Ve6glv1OR6NCHdAZ1St7jvxZe7OdqsY87QfK2goMunP0ur/JdJtzNSm4tLzg7+ynRfywY9PzRrzdJ3g+mHzWpXmjNUAQJGZ5XMuIUk5AumVthKaErpAEmRBWKIcY0wMFef1bmRqKu2upf7bYwSNTopFcKMmsvdF20qdF4kpD8Oz5vGRn10tSi9dV0F4ZOb7cV00KipTmU6IyvpWcsz4gRris+TWL8Jk1DRWG0XKiDz5p/YigEzDV7aSmLlmME= filatovk@server"
  description = "ssh-keygen -t rsa -b 4096"
}
