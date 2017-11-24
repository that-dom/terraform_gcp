variable "global_address_variables" {
  type        = "map"
  description = "global_address変数"
  default = {
    name  = ""
  }
}

/**
 * Global Address作成
 * https://www.terraform.io/docs/providers/google/r/compute_global_address.html
 */
resource "google_compute_global_address" "global_address" {
  name = "${var.global_address_variables["name"]}"
}

output "global_address" {
    value = "${google_compute_global_address.global_address.address}"
}
