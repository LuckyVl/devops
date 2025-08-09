variable "flow" {
  type    = string
  default = "24-01"
}

variable "cloud_id" {
  type    = string
  default = "b1goo5pkjq9ldvqkgp0l"
}
variable "folder_id" {
  type    = string
  default = "b1g7c66oo5q6sjc4bdlt"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

