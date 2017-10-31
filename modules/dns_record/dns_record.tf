variable "dns_record_variables" {
  type = "map"
  description = "DNSレコード変数"
  default = {
    dns_record_name   = ""
    ttl               = ""
    managed_zone      = ""
    dns_record_ipaddr = ""
  }
}

/**
 * DNSレコード作成
 * https://www.terraform.io/docs/providers/google/r/dns_record_set.html
 */
resource "google_dns_record_set" "dns-record" {
  name =  "${var.dns_record_variables["dns_record_name"]}"
  type = "A"
  ttl  = "${var.dns_record_variables["ttl"]}"

  managed_zone = "${var.dns_record_variables["managed_zone"]}"

  # バグあり
  # https://github.com/hashicorp/terraform/issues/9123
  rrdatas = ["${var.dns_record_variables["dns_record_ipaddr"]}"]
}
