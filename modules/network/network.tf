variable "network_variables" {
    type = "map"
    description = "ネットワーク変数"

    default = {
      network_name = ""
    }
}

/**
 * ネットワーク作成
 * https://www.terraform.io/docs/providers/google/d/datasource_compute_network.html
 */
resource "google_compute_network" "network" {
  name  = "${var.network_variables["network_name"]}"
  auto_create_subnetworks = "false"
}

output "network_name" {
  value = "${google_compute_network.network.name}"
}

output "network_link" {
  value = "${google_compute_network.network.self_link}"
}
