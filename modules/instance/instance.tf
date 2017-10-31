variable "instance_variables" {
  type = "map"
  description = "compute instance変数"
  default = {
    count             = 0
    machine_type      = ""
    name              = ""
    image             = ""
    size              = ""
    network_interface = ""
    env               = ""
  }
}

variable "instance_zones" {
  type = "list"
  default = []
}

variable "instance_tags" {
  type = "list"
  default = []
}

variable "service_accounts" {
  type = "list"
  default = []
}

/**
 * インスタンス作成
 * https://www.terraform.io/docs/providers/google/r/compute_instance.html
 */
resource "google_compute_instance" "instance" {
  count        = "${var.instance_variables["count"]}"
  name         = "${format(var.instance_variables["name"], count.index+1)}"
  machine_type = "${var.instance_variables["machine_type"]}"
  zone         = "${element(var.instance_zones, count.index)}"
  tags         = "${var.instance_tags}"

  labels {
    env = "${var.instance_variables["env"]}"
  }

  boot_disk {
    device_name = "${format(var.instance_variables["name"], count.index+1)}"
    initialize_params {
      image = "${var.instance_variables["image"]}"
      size  = "${var.instance_variables["size"]}"
    }
  }

  network_interface {
    subnetwork = "${var.instance_variables["network_interface"]}"
    access_config {}
  }

  service_account {
    scopes = "${var.service_accounts}"
  }

  lifecycle {
    ignore_changes = ["boot_disk.0.initialize_params.0.image"]
  }
}
