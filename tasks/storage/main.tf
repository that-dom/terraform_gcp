variable "env" {}

variable "bucket_default_settings" { type = "map" }
variable "bucket_backup_settings" { type = "map" }

/**
 * モジュール読み込み
 * https://www.terraform.io/docs/configuration/modules.html
 */

# バケット設定-----------------------------------------

# 通常バケット
module "bucket_default" {
  source = "../../modules/storage_bucket"

  storage_bucket_variables {
    name          = "${var.project_name}-default_bucket"
    location      = "${var.bucket_default_settings["location"]}"
    storage_class = "${var.bucket_default_settings["storage_class"]}"
    env           = "${var.env}"
  }
}

# バックアップ用バケット
module "bucket_backup" {
  source = "../../modules/storage_bucket"

  storage_bucket_variables {
    name                         = "${var.project_name}-backup_bucket"
    location                     = "${var.bucket_backup_settings["location"]}"
    storage_class                = "${var.bucket_backup_settings["storage_class"]}"
    lifecycle_rule_action_type   = "${var.bucket_backup_settings["lifecycle_rule_action_type"]}"
    lifecycle_rule_condition_age = "${var.bucket_backup_settings["lifecycle_rule_condition_age"]}"
    env                          = "${var.env}"
  }
}
