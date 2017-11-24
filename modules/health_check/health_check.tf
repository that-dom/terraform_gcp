variable "health_check_variables" {
  type        = "map"
  description = "health_check変数"
  default = {
    name                  = ""
    timeout_sec           = ""
    check_interval_sec    = ""
    tcp_health_check_port = ""
  }
}

/**
 * ヘルスチェック作成
 * https://www.terraform.io/docs/providers/google/r/compute_health_check.html
 */
resource "google_compute_health_check" "health_check" {
  name               = "${var.health_check_variables["name"]}"
  timeout_sec        = "${var.health_check_variables["timeout_sec"]}"
  check_interval_sec = "${var.health_check_variables["check_interval_sec"]}"

  tcp_health_check {
    port = "${var.health_check_variables["tcp_health_check_port"]}"
  }
}

output "health_check_link" {
    value = ["${google_compute_health_check.health_check.self_link}"]
}
