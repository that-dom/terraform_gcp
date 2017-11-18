variable "storage_bucket_variables" {
    type = "map"
    description = "バケット変数"

    default = {
      name                                    = ""
      location                                = ""
      storage_class                           = ""
      lifecycle_rule_action_type              = ""
      lifecycle_rule_condition_age            = ""
      lifecycle_rule_condition_created_before = ""
      env                                     = ""
    }
}

/**
 * バケット作成
 * https://www.terraform.io/docs/providers/google/r/storage_bucket.html
 */
resource "google_storage_bucket" "bucket" {
  name          = "${var.storage_bucket_variables["name"]}"
  location      = "${var.storage_bucket_variables["location"]}"
  storage_class = "${var.storage_bucket_variables["storage_class"]}"

  lifecycle_rule {
    action {
      type = "${var.storage_bucket_variables["lifecycle_rule_action_type"]}"
    }

    condition {
      age = "${var.storage_bucket_variables["lifecycle_rule_condition_age"]}"
      created_before = "${var.storage_bucket_variables["lifecycle_rule_condition_created_before"]}"
    }
  }

  labels {
    env = "${var.storage_bucket_variables["env"]}"
  }
}
