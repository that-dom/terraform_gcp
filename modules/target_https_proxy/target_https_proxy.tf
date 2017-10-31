variable "target_https_proxy_variables" {
  type = "map"
  description = "target_https_proxy変数"
  default = {
    name            = ""
    url_map         = ""
  }
}

variable "ssl_certificate_links" {
  type = "list"
  description = "SSL証明書"
}

/**
 * https proxy作成
 * https://www.terraform.io/docs/providers/google/r/compute_target_https_proxy.html
 */
resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${var.target_https_proxy_variables["name"]}"
  url_map          = "${var.target_https_proxy_variables["url_map"]}"
  ssl_certificates = ["${var.ssl_certificate_links}"]
}

output "https_proxy_link" {
    value = "${google_compute_target_https_proxy.https_proxy.self_link}"
}
