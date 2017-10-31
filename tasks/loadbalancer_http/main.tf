variable "zones" { type = "list" }

variable "http_health_check_web_settings" { type = "map" }
variable "backend_service_web_settings" { type = "map" }

/**
 * モジュール読み込み
 * https://www.terraform.io/docs/configuration/modules.html
 */

# httpロードバランサの設定-----------------------------------------

# ヘルスチェック
module "http_health_check_web" {
  source = "../../modules/http_health_check"

  health_check_variables {
    name               = "web-hc"
    request_path       = "${var.http_health_check_web_settings["request_path"]}"
    timeout_sec        = "${var.http_health_check_web_settings["timeout_sec"]}"
    check_interval_sec = "${var.http_health_check_web_settings["check_interval_sec"]}"
  }
}

# instance group web
module "instance_group_web" {
  source = "../../modules/instance_group"

  instance_group_variables {
    count   = "${ length(var.zones) }"
    name    = "web-group-%02d"
    network = "https://www.googleapis.com/compute/v1/projects/${var.project_name}/global/networks/${var.project_name}-network"
  }

  instance_zones = "${var.zones}"
}

# バックエンドサービス
module "backend_service_web" {
  source = "../../modules/backend_service_3"

  backend_service_variables {
    name            = "web-bs"
    timeout_sec     = "${var.backend_service_web_settings["timeout_sec"]}"
    backend_group1  = "${element(module.instance_group_web.instance_group_links, 0)}"
    backend_group2  = "${element(module.instance_group_web.instance_group_links, 1)}"
    backend_group3  = "${element(module.instance_group_web.instance_group_links, 2)}"
    protocol        = "${var.backend_service_web_settings["protocol"]}"
    port_name       = "${var.backend_service_web_settings["port_name"]}"
    max_utilization = "${var.backend_service_web_settings["max_utilization"]}"
  }

  health_check_links = ["${module.http_health_check_web.health_check_link}"]
}

# urlマップ
module "url_map_web" {
  source = "../../modules/url_map"

  url_map_variables {
    name            = "web-lb"
    default_service = "${module.backend_service_web.backend_service_link}"
  }
}

# target_http_proxy
module "target_http_proxy_web" {
  source = "../../modules/target_http_proxy"

  target_http_proxy_variables {
    name        = "web-proxy"
    url_map     = "${module.url_map_web.url_map_link}"
  }
}

# グローバルアドレス取得
module "global_address_web" {
  source = "../../modules/global_address"

  global_address_variables {
    name  = "web-address"
  }
}

# global_forwarding_rule
module "global_forwarding_rule_web" {
  source = "../../modules/global_forwarding_rule"

  global_forwarding_rule_variables {
    name       = "web-fr"
    target     = "${module.target_http_proxy_web.http_proxy_link}"
    port_range = "80"
    ip_address = "${module.global_address_web.global_address}"
  }
}
