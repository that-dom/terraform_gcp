variable "subnetwork_variables" {
    type        = "map"
    description = "サブネットワーク変数"

    default = {
      subnetwork_name = ""
      ip_cidr_range   = ""
      network         = ""
      region          = ""
    }
}

/**
 * サブネットワーク作成
 * https://www.terraform.io/docs/providers/google/d/datasource_compute_subnetwork.html
 */
resource "google_compute_subnetwork" "subnetwork" {
  name          = "${var.subnetwork_variables["subnetwork_name"]}"
  ip_cidr_range = "${var.subnetwork_variables["ip_cidr_range"]}"
  network       = "${var.subnetwork_variables["network"]}"
  region        = "${var.subnetwork_variables["region"]}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.subnetwork.name}"
}

output "subnetwork_link" {
  value = "${google_compute_subnetwork.subnetwork.self_link}"
}
