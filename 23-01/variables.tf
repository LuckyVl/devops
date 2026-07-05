variable "cloud_id" {
  type    = string
  default = "b1goo5pkjq9ldvqkgp0l"
}

variable "folder_id" {
  type    = string
  default = "b1g7c66oo5q6sjc4bdlt"
}

variable "allowed_ips" {
  description = "Список IP-адресов, которым разрешен доступ к API Kubernetes (порт 443)"
  type        = list(string)
  default     = ["95.24.9.243/32"] # Ваш IP с маской /32 (один адрес)
}