variable "forwarding_rule_internal_variables" {
  type        = "map"
  description = "forwarding_rule_internal変数"
  default = {
    name            = ""
    backend_service = ""
    ip_protocol     = ""
    network         = ""
    subnetwork      = ""
    ports           = ""
  }
}

variable "forwarding_rule_ports" {
  type    = "list"
  default = []
}

/**
 * FORWARDING_RULE作成
 * https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html
 */
resource "google_compute_forwarding_rule" "forwarding_rule_internal" {
  name                  = "${var.forwarding_rule_internal_variables["name"]}"
  backend_service       = "${var.forwarding_rule_internal_variables["backend_service"]}"
  ip_protocol           = "${var.forwarding_rule_internal_variables["ip_protocol"]}"
  load_balancing_scheme = "INTERNAL"
  network               = "${var.forwarding_rule_internal_variables["network"]}"
  subnetwork            = "${var.forwarding_rule_internal_variables["subnetwork"]}"
  ports                 = "${var.forwarding_rule_ports}"
}
