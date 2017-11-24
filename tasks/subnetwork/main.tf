variable "region" {}

variable "ip_cidr_range_dev" {}
variable "ip_cidr_range_stg" {}
variable "ip_cidr_range_prd" {}
variable "ip_cidr_range_shd" {}

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

# サブネットワーク設定
module "subnetwork_dev" {
    source = "../../modules/subnetwork"

    subnetwork_variables {
      subnetwork_name = "${var.project_name}-dev"
      ip_cidr_range   = "${var.ip_cidr_range_dev}"
      network         = "${data.google_compute_network.network.self_link}"
      region          = "${var.region}"
    }
}

# サブネットワーク設定
module "subnetwork_stg" {
    source = "../../modules/subnetwork"

    subnetwork_variables {
      subnetwork_name = "${var.project_name}-stg"
      ip_cidr_range   = "${var.ip_cidr_range_stg}"
      network         = "${data.google_compute_network.network.self_link}"
      region          = "${var.region}"
    }
}

# サブネットワーク設定
module "subnetwork_prd" {
    source = "../../modules/subnetwork"

    subnetwork_variables {
      subnetwork_name = "${var.project_name}-prd"
      ip_cidr_range   = "${var.ip_cidr_range_prd}"
      network         = "${data.google_compute_network.network.self_link}"
      region          = "${var.region}"
    }
}

# サブネットワーク設定
module "subnetwork_shd" {
    source = "../../modules/subnetwork"

    subnetwork_variables {
      subnetwork_name = "${var.project_name}-shd"
      ip_cidr_range   = "${var.ip_cidr_range_shd}"
      network         = "${data.google_compute_network.network.self_link}"
      region          = "${var.region}"
    }
}
