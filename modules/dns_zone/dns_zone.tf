variable "dns_zone_variables" {
  type = "map"
  description = "DNSゾーン変数"
  default = {
    dns_zone_name   = ""
    dns_name        = ""
  }
}

/**
 * DNSゾーン作成
 * https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html
 */

resource "google_dns_managed_zone" "dns-zone" {
  name     = "${var.dns_zone_variables["dns_zone_name"]}"
  dns_name = "${var.dns_zone_variables["dns_name"]}"
}

output "dns_zone_name" {
    value = "${google_dns_managed_zone.dns-zone.name}"
}

output "dns_name" {
    value = "${google_dns_managed_zone.dns-zone.dns_name}"
}
