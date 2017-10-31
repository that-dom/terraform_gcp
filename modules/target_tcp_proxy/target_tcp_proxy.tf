variable "target_tcp_proxy_variables" {
  type = "map"
  description = "target_tcp_proxy変数"
  default = {
    name            = ""
    backend_service = ""
  }
}

/**
 * tcp proxy作成
 * https://www.terraform.io/docs/providers/google/r/compute_target_tcp_proxy.html
 */
resource "google_compute_target_tcp_proxy" "tcp_proxy" {
  name             = "${var.target_tcp_proxy_variables["name"]}"
  backend_service  = "${var.target_tcp_proxy_variables["backend_service"]}"
}

output "tcp_proxy_link" {
    value = "${google_compute_target_tcp_proxy.tcp_proxy.self_link}"
}
