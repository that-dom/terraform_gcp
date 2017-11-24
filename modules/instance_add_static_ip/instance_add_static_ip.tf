variable "instance_add_static_ip_variables" {
  type        = "map"
  description = "compute instance変数"
  default = {
    count        = 0
    machine_type = ""
    name         = ""
    image        = ""
    size         = ""
    subnetwork   = ""
    env          = ""
  }
}

variable "instance_zones" {
  type    = "list"
  default = []
}

variable "instance_tags" {
  type    = "list"
  default = []
}

variable "service_accounts" {
  type    = "list"
  default = []
}

/**
 * 静的アドレス取得
 * https://www.terraform.io/docs/providers/google/r/compute_address.html
 */
resource "google_compute_address" "compute_address" {
  count = "${var.instance_add_static_ip_variables["count"]}"
  name  = "${format("${var.instance_add_static_ip_variables["name"]}-address", count.index+1)}"
}

output "compute_address" {
    value = "${google_compute_address.compute_address.0.address}"
}

/**
 * インスタンス作成
 * https://www.terraform.io/docs/providers/google/r/compute_instance.html
 */
resource "google_compute_instance" "instance" {
  count        = "${var.instance_add_static_ip_variables["count"]}"
  name         = "${format(var.instance_add_static_ip_variables["name"], count.index+1)}"
  machine_type = "${var.instance_add_static_ip_variables["machine_type"]}"
  zone         = "${element(var.instance_zones, count.index)}"
  tags         = "${var.instance_tags}"

  labels {
    env = "${var.instance_add_static_ip_variables["env"]}"
  }

  boot_disk {
    device_name = "${format(var.instance_add_static_ip_variables["name"], count.index+1)}"
    initialize_params {
      image = "${var.instance_add_static_ip_variables["image"]}"
      size  = "${var.instance_add_static_ip_variables["size"]}"
    }
  }

  network_interface {
    subnetwork = "${var.instance_add_static_ip_variables["subnetwork"]}"
    access_config {
      nat_ip = "${element(google_compute_address.compute_address.*.address, count.index)}"
    }
  }

  service_account {
    scopes = "${var.service_accounts}"
  }

  lifecycle {
    ignore_changes = ["boot_disk.0.initialize_params.0.image"]
  }
}
