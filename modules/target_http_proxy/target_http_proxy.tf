variable "target_http_proxy_variables" {
  type        = "map"
  description = "target_http_proxy変数"
  default = {
    name    = ""
    url_map = ""
  }
}

/**
 * http proxy作成
 * https://www.terraform.io/docs/providers/google/r/compute_target_http_proxy.html
 */
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.target_http_proxy_variables["name"]}"
  url_map = "${var.target_http_proxy_variables["url_map"]}"
}

output "http_proxy_link" {
    value = "${google_compute_target_http_proxy.http_proxy.self_link}"
}
