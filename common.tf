# 実行時に変数指定----------------------------
variable "key_path" {
  type        = "string"
  description = "アクセスkeyへのpath"
}
# -----------------------------------------

# common.tfvarsで変数指定--------------------
variable "project_id" {
  type        = "string"
  description = "プロジェクトID"
}
variable "project_name" {
  type        = "string"
  description = "プロジェクト名"
}
variable "default_region" {
  type        = "string"
  description = "デフォルトリージョン名"
}

variable "google_web_console_ip" { type = "list" }
variable "lb_health_check_source_ranges" { type = "list" }
variable "common_instance_service_accounts" { type = "list" }
variable "terraform_ip" { type = "list" }
# -----------------------------------------

/**
 * terraform対応バージョン
 * https://www.terraform.io/docs/configuration/terraform.html
 */
terraform {
  required_version = "= 0.11.0"
}
