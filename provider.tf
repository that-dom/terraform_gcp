/**
 * プロバイダー設定
 * https://www.terraform.io/docs/providers/google/index.html
 */
provider "google" {
  credentials = "${file(var.key_path)}"
  project     = "${var.project_id}"
  region      = "${var.default_region}"
}
