variable "region_backend_service_variables" {
  type        = "map"
  description = "region_backend_service変数"
  default = {
    name             = ""
    region           = ""
    timeout_sec      = ""
    backend_group1   = ""
    backend_group2   = ""
    protocol         = ""
    session_affinity = ""
  }
}

variable "health_check_links" {
  type        = "list"
  description = "ヘルスチェックURL"
}

/**
 * バックエンドサービス作成
 * https://www.terraform.io/docs/providers/google/r/compute_region_backend_service.html
 */
resource "google_compute_region_backend_service" "region_backend_service" {
  name             = "${var.region_backend_service_variables["name"]}"
  region           = "${var.region_backend_service_variables["region"]}"
  timeout_sec      = "${var.region_backend_service_variables["timeout_sec"]}"
  protocol         = "${var.region_backend_service_variables["protocol"]}"
  session_affinity = "${var.region_backend_service_variables["session_affinity"]}"

  backend {
    group = "${var.region_backend_service_variables["backend_group1"]}"
  }

  backend {
    group = "${var.region_backend_service_variables["backend_group2"]}"
  }

  # バグあり
  # https://github.com/hashicorp/terraform/issues/9123
  health_checks = ["${var.health_check_links}"]
}

output "region_backend_service_link" {
    value = "${google_compute_region_backend_service.region_backend_service.self_link}"
}
