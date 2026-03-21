resource "random_password" "solo" {
  length = 17
}

resource "random_password" "count" {
  count  = length(yandex_compute_instance.example)
  length = 17
}

resource "random_password" "each" {
  for_each = toset([for inst in yandex_compute_instance.example : inst.name])
  length   = 17
}