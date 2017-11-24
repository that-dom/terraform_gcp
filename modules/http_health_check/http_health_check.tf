variable "health_check_variables" {
  type        = "map"
  description = "health_check変数"
  default = {
    name               = ""
    request_path       = ""
    timeout_sec        = ""
    check_interval_sec = ""
  }
}

/**
 * httpヘルスチェック作成
 * https://www.terraform.io/docs/providers/google/r/compute_http_health_check.html
 */
resource "google_compute_http_health_check" "health_check" {
  name               = "${var.health_check_variables["name"]}"
  request_path       = "${var.health_check_variables["request_path"]}"
  timeout_sec        = "${var.health_check_variables["timeout_sec"]}"
  check_interval_sec = "${var.health_check_variables["check_interval_sec"]}"
}

output "health_check_link" {
    value = ["${google_compute_http_health_check.health_check.self_link}"]
}
