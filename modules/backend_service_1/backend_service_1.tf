variable "backend_service_variables" {
  type        = "map"
  description = "backend_service変数"
  default = {
    name            = ""
    timeout_sec     = ""
    backend_group   = ""
    protocol        = ""
    port_name       = ""
    max_utilization = ""
  }
}
variable "health_check_links" {
  type        = "list"
  description = "ヘルスチェックURL"
}

/**
 * バックエンドサービス作成
 * https://www.terraform.io/docs/providers/google/r/compute_backend_service.html
 */
resource "google_compute_backend_service" "backend_service" {
  name        = "${var.backend_service_variables["name"]}"
  timeout_sec = "${var.backend_service_variables["timeout_sec"]}"
  protocol    = "${var.backend_service_variables["protocol"]}"
  port_name   = "${var.backend_service_variables["port_name"]}"

  backend {
    group           = "${var.backend_service_variables["backend_group"]}"
    max_utilization = "${var.backend_service_variables["max_utilization"]}"
  }

  # バグあり
  # https://github.com/hashicorp/terraform/issues/9123
  health_checks = ["${var.health_check_links}"]
}

output "backend_service_link" {
    value = "${google_compute_backend_service.backend_service.self_link}"
}
