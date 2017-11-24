variable "firewall_variables" {
  type        = "map"
  description = "ファイアーウォール変数"
  default = {
    firewall_name  = ""
    network        = ""
    allow_protocol = ""
    description    = ""
  }
}

variable "allow_ports" {
  type    = "list"
  default = []
}

variable "source_ranges" {
  type    = "list"
  default = []
}

variable "source_tags" {
  type    = "list"
  default = []
}

variable "target_tags" {
  type    = "list"
  default = []
}

/**
 * FWルール作成
 * https://www.terraform.io/docs/providers/google/r/compute_firewall.html
 */
resource "google_compute_firewall" "firewall" {
  name    = "${var.firewall_variables["firewall_name"]}"
  network = "${var.firewall_variables["network"]}"

  allow {
    protocol = "${var.firewall_variables["allow_protocol"]}"
    ports    = "${var.allow_ports}"
  }

  source_ranges = "${var.source_ranges}"
  source_tags   = "${var.source_tags}"
  target_tags   = "${var.target_tags}"
  description   = "${var.firewall_variables["description"]}"
}
