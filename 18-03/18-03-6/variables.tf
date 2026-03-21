variable "token" {
  type        = string
  description = "OAuth-token"
  sensitive   = true
}

variable "cloud_id" {
  type        = string
  description = "Cloud ID"
  default     = "b1gn3ndpua1j6jaabf79"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
  default     = "b1gfu61oc15cb99nqmfe"
}

variable "public_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHN1wGZ1Jr2e3uJ9XJuURt54YhehJGtriEcOzFlXtAi+ filatov.v.k@gmail.com"
}

variable "env" {
  type    = string
  default = "production"
}

variable "external_acess_bastion" {
  type    = bool
  default = true
}