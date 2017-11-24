variable "instance_add_disk_variables" {
  type = "map"
  description = "compute instance(追加ディスク)変数"
  default = {
    count                    = 0
    machine_type             = ""
    name                     = ""
    image                    = ""
    size                     = ""
    subnetwork               = ""
    add_disk_name            = ""
    add_disk_size            = ""
    add_disk_type            = ""
    private_key              = ""
    disk_partition_file_path = ""
    mount_path               = ""
    env                      = ""
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
 * ディスク作成
 * https://www.terraform.io/docs/providers/google/r/compute_disk.html
 */
resource "google_compute_disk" "add_disk" {
  count = "${var.instance_add_disk_variables["count"]}"
  name  = "${format(var.instance_add_disk_variables["add_disk_name"], count.index+1)}"
  size  = "${var.instance_add_disk_variables["add_disk_size"]}"
  type  = "${var.instance_add_disk_variables["add_disk_type"]}"
  zone  = "${element(var.instance_zones, count.index)}"
}

/**
 * インスタンス作成
 * https://www.terraform.io/docs/providers/google/r/compute_instance.html
 */
resource "google_compute_instance" "instance" {
  count        = "${var.instance_add_disk_variables["count"]}"
  name         = "${format(var.instance_add_disk_variables["name"], count.index+1)}"
  machine_type = "${var.instance_add_disk_variables["machine_type"]}"
  zone         = "${element(var.instance_zones, count.index)}"
  tags         = "${var.instance_tags}"

  labels {
    env = "${var.instance_add_disk_variables["env"]}"
  }

  boot_disk {
    device_name = "${format(var.instance_add_disk_variables["name"], count.index+1)}"
    initialize_params {
      image = "${var.instance_add_disk_variables["image"]}"
      size  = "${var.instance_add_disk_variables["size"]}"
    }
  }

  attached_disk {
    source = "${element(google_compute_disk.add_disk.*.self_link, count.index)}"
    device_name = "${element(google_compute_disk.add_disk.*.name, count.index)}"
  }

  network_interface {
    subnetwork = "${var.instance_add_disk_variables["subnetwork"]}"
    access_config {}
  }

  service_account {
    scopes = "${var.service_accounts}"
  }

  lifecycle {
    ignore_changes = ["boot_disk.0.initialize_params.0.image"]
  }

  connection {
      type = "ssh"
      user = "terraform-user"
      private_key = "${file(var.instance_add_disk_variables["private_key"])}"
  }

  provisioner "file" {
    source      = "${var.instance_add_disk_variables["disk_partition_file_path"]}"
    destination = "/tmp/disk_partition.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /tmp/disk_partition.sh ${var.instance_add_disk_variables["mount_path"]}",
      "rm /tmp/disk_partition.sh"
    ]
  }
}
