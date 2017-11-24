/**
 * network取得
 * https://www.terraform.io/docs/providers/google/d/datasource_compute_network.html
 */
data "google_compute_network" "network" {
  name = "${var.project_name}-network"
}

/**
 * モジュール読み込み
 * https://www.terraform.io/docs/configuration/modules.html
 */

# ファイアーウォール設定
# 共通===========================================================

# all-allow-google-ssh
# google-web-consoleでの全サーバへのssh
module "firewall-all-allow-google-ssh" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "all-allow-google-ssh"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "tcp"
      description    = "google-web-consoleでの全サーバへのssh. gcp web console: ${var.google_web_console_ip[0]}"
    }

    allow_ports   = ["22"]
    source_ranges = "${var.google_web_console_ip}"
}

# all-allow-google-rdp
# google-web-consoleでの全サーバへのrdp
module "firewall-all-allow-google-rdp" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "all-allow-google-rdp"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "tcp"
      description    = "google-web-consoleでの全サーバへのrdp. gcp web console: ${var.google_web_console_ip[0]}"
    }

    allow_ports   = ["3389"]
    source_ranges = "${var.google_web_console_ip}"
}

# all-allow-terraform-ssh
# terraformから全サーバへのssh
module "firewall-all-allow-terraform-ssh" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "all-allow-terraform-ssh"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "tcp"
      description    = "terraformから全サーバへのssh. terraform: ${var.terraform_ip[0]}"
    }

    allow_ports   = ["22"]
    source_ranges = ["${var.terraform_ip[0]}"]
}

# all-allow-ansible-ssh
# ansibleから全サーバへのssh
module "firewall-all-allow-ansible-ssh" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "all-allow-ansible-ssh"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "tcp"
      description    = "ansibleから全サーバへのssh"
    }

    allow_ports   = ["22"]
    source_tags = ["ansible"]
}

# all-allow-ladder-ssh
# 踏み台サーバから全サーバへのssh
module "firewall-all-allow-ladder-ssh" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "all-allow-ladder-ssh"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "tcp"
      description    = "踏み台サーバから全サーバへのssh"
    }

    allow_ports   = ["22"]
    source_tags   = ["ladder"]
}

# web-allow-lb-http
# lbのwebへのヘルスチェック
module "firewall-web-allow-lb-http" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "web-allow-lb-http"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "tcp"
      description    = "lbのwebへのヘルスチェック"
    }

    allow_ports   = ["80"]
    source_ranges = "${var.lb_health_check_source_ranges}"
    target_tags   = ["web"]
}

# consul-allow-consul-tcp
# consulからconsulへのtcpアクセス
module "firewall-consul-allow-consul-tcp" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "consul-allow-consul-tcp"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "tcp"
      description    = "consulからconsulへのtcpアクセス"
    }

    allow_ports   = ["8300", "8301", "8302", "8400", "8500", "8600"]
    source_tags   = ["consul"]
    target_tags   = ["consul"]
}

# consul-allow-consul-udp
# consulからconsulへのudpアクセス
module "firewall-consul-allow-consul-udp" {
    source = "../../modules/firewall"

    firewall_variables {
      firewall_name  = "consul-allow-consul-udp"
      network        = "${data.google_compute_network.network.self_link}"
      allow_protocol = "udp"
      description    = "consulからconsulへのudpアクセス"
    }

    allow_ports   = ["8301", "8302", "8600"]
    source_tags   = ["consul"]
    target_tags   = ["consul"]
}

# dev===========================================================

# stg===========================================================

# prd===========================================================
