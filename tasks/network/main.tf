/**
 * モジュール読み込み
 * https://www.terraform.io/docs/configuration/modules.html
 */

# ネットワーク設定
module "network" {
  source = "../../modules/network"

  network_variables {
    network_name = "${var.project_name}-network"
  }
}
