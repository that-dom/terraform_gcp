variable "region" {}
variable "zones" { type = "list" }

variable "health_check_mail_settings" { type = "map" }
variable "backend_service_mail_settings" { type = "map" }
variable "forwarding_rule_internal_mail_settings" { type = "map" }
variable "forwarding_rule_ports" { type = "list" }

/**
 * network取得
 * https://www.terraform.io/docs/providers/google/d/datasource_compute_network.html
 */
data "google_compute_network" "network" {
  name = "${var.project_name}-network"
}

/**
 * subnetwork取得
 * https://www.terraform.io/docs/providers/google/d/datasource_compute_subnetwork.html
 */
data "google_compute_subnetwork" "dev" {
  name   = "${var.project_name}-dev"
  region = "${var.region}"
}

data "google_compute_subnetwork" "stg" {
  name   = "${var.project_name}-stg"
  region = "${var.region}"
}

data "google_compute_subnetwork" "prd" {
  name   = "${var.project_name}-prd"
  region = "${var.region}"
}

/**
 * モジュール読み込み
 * https://www.terraform.io/docs/configuration/modules.html
 */

# TCPロードバランサの設定-------------------------------

# ヘルスチェック
module "tcp_health_check_mail" {
  source = "../../modules/health_check"

  health_check_variables {
    name                  = "mail-hc"
    timeout_sec           = "${var.health_check_mail_settings["timeout_sec"]}"
    check_interval_sec    = "${var.health_check_mail_settings["check_interval_sec"]}"
    tcp_health_check_port = "${var.health_check_mail_settings["tcp_health_check_port"]}"
  }
}

# instance group cluster1
module "instance_group_mail" {
  source = "../../modules/instance_group"

  instance_group_variables {
    count   = "${length(var.zones)}"
    name    = "mail-group-%02d"
    network = "${data.google_compute_network.network.self_link}"
  }

  instance_zones = "${var.zones}"
}

# バックエンドサービス
module "backend_service_mail" {
  source = "../../modules/region_backend_service_3"

  region_backend_service_variables {
    name             = "mail-bs"
    region           = "${var.region}"
    timeout_sec      = "${var.backend_service_mail_settings["timeout_sec"]}"
    backend_group1   = "${element(module.instance_group_mail.instance_group_links, 0)}"
    backend_group2   = "${element(module.instance_group_mail.instance_group_links, 1)}"
    backend_group3   = "${element(module.instance_group_mail.instance_group_links, 2)}"
    protocol         = "${var.backend_service_mail_settings["protocol"]}"
    session_affinity = "${var.backend_service_mail_settings["session_affinity"]}"
  }

  health_check_links = ["${module.tcp_health_check_mail.health_check_link}"]
}

# target_tcp_proxy
module "target_tcp_proxy_mail" {
  source = "../../modules/target_tcp_proxy"

  target_tcp_proxy_variables {
    name            = "mail-proxy"
    backend_service = "${module.backend_service_mail.region_backend_service_link}"
  }
}

# forwarding_rule_internal dev
module "forwarding_rule_internal_mail_dev" {
  source = "../../modules/forwarding_rule_internal"

  forwarding_rule_internal_variables {
    name            = "mail-dev-fr"
    backend_service = "${module.backend_service_mail.region_backend_service_link}"
    ip_protocol     = "${var.forwarding_rule_internal_mail_settings["ip_protocol"]}"
    network         = "${data.google_compute_network.network.self_link}"
    subnetwork      = "${data.google_compute_subnetwork.dev.self_link}"
  }

  forwarding_rule_ports = "${var.forwarding_rule_ports}"
}

# forwarding_rule_internal stg
module "forwarding_rule_internal_mail_stg" {
  source = "../../modules/forwarding_rule_internal"

  forwarding_rule_internal_variables {
    name            = "mail-stg-fr"
    backend_service = "${module.backend_service_mail.region_backend_service_link}"
    ip_protocol     = "${var.forwarding_rule_internal_mail_settings["ip_protocol"]}"
    network         = "${data.google_compute_network.network.self_link}"
    subnetwork      = "${data.google_compute_subnetwork.stg.self_link}"
  }

  forwarding_rule_ports = "${var.forwarding_rule_ports}"
}

# forwarding_rule_internal prd
module "forwarding_rule_internal_mail_prd" {
  source = "../../modules/forwarding_rule_internal"

  forwarding_rule_internal_variables {
    name            = "mail-prd-fr"
    backend_service = "${module.backend_service_mail.region_backend_service_link}"
    ip_protocol     = "${var.forwarding_rule_internal_mail_settings["ip_protocol"]}"
    network         = "${data.google_compute_network.network.self_link}"
    subnetwork      = "${data.google_compute_subnetwork.prd.self_link}"
  }

  forwarding_rule_ports = "${var.forwarding_rule_ports}"
}
