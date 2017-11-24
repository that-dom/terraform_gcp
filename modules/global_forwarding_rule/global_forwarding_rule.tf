variable "global_forwarding_rule_variables" {
  type        = "map"
  description = "global_forwarding_rule変数"
  default = {
    name       = ""
    target     = ""
    port_range = ""
    ip_address = ""
  }
}

/**
 * GLOBAL_FORWARDING_RULE作成
 * https://www.terraform.io/docs/providers/google/r/compute_global_forwarding_rule.html
 */
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "${var.global_forwarding_rule_variables["name"]}"
  target     = "${var.global_forwarding_rule_variables["target"]}"
  port_range = "${var.global_forwarding_rule_variables["port_range"]}"
  ip_address = "${var.global_forwarding_rule_variables["ip_address"]}"
}
