variable "storage_bucket_variables" {
    type        = "map"
    description = "バケット変数"

    default = {
      name          = ""
      location      = ""
      storage_class = ""
      env           = ""
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

  labels {
    env = "${var.storage_bucket_variables["env"]}"
  }
}
