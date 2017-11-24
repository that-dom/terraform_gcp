variable "url_map_variables" {
  type        = "map"
  description = "url_map変数"
  default = {
    name            = ""
    default_service = ""
  }
}

/**
 * URL_MAP作成
 * https://www.terraform.io/docs/providers/google/r/compute_url_map.html
 */
resource "google_compute_url_map" "url_map" {
  name            = "${var.url_map_variables["name"]}"
  default_service = "${var.url_map_variables["default_service"]}"
}

output "url_map_link" {
    value = "${google_compute_url_map.url_map.self_link}"
}
