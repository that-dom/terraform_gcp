variable "dns_suffix" {}
variable "ttl" {}

variable "dns_record_ipaddr_web_dev" {}
variable "dns_record_ipaddr_web_stg" {}
variable "dns_record_ipaddr_web_prd" {}

/**
 * モジュール読み込み
 * https://www.terraform.io/docs/configuration/modules.html
 */

# DNSの設定-----------------------------------------

# DNSゾーン設定
module "dns_zone" {
  source = "../../modules/dns_zone"

  dns_zone_variables {
    dns_zone_name = "${var.project_name}-bayguh-jp"
    dns_name      = "${var.project_name}.${var.dns_suffix}"
  }
}

# web用DNSレコード設定 dev
module "dns_record-dev-web" {
  source = "../../modules/dns_record"

  dns_record_variables {
    dns_record_name   = "dev-web.${module.dns_zone.dns_name}"
    ttl               = "${var.ttl}"
    managed_zone      = "${module.dns_zone.dns_zone_name}"
    dns_record_ipaddr = "${var.dns_record_ipaddr_web_dev}"
  }
}

# web用DNSレコード設定 stg
module "dns_record-stg-web" {
  source = "../../modules/dns_record"

  dns_record_variables {
    dns_record_name   = "stg-web.${module.dns_zone.dns_name}"
    ttl               = "${var.ttl}"
    managed_zone      = "${module.dns_zone.dns_zone_name}"
    dns_record_ipaddr = "${var.dns_record_ipaddr_web_stg}"
  }
}

# web用DNSレコード設定 prd
module "dns_record-prd-web" {
  source = "../../modules/dns_record"

  dns_record_variables {
    dns_record_name   = "web.${module.dns_zone.dns_name}"
    ttl               = "${var.ttl}"
    managed_zone      = "${module.dns_zone.dns_zone_name}"
    dns_record_ipaddr = "${var.dns_record_ipaddr_web_prd}"
  }
}
