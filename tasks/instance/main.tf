variable "env" {}
variable "zones" { type = "list" }

variable "instance_ansible_settings" { type = "map" }
variable "instance_ansible_instance_tags" { type = "list" }
variable "instance_ansible_service_accounts" { type = "list" }

variable "instance_web_settings" { type = "map" }
variable "instance_web_instance_tags" { type = "list" }
variable "instance_web_service_accounts" { type = "list" }

variable "instance_db_settings" { type = "map" }
variable "instance_db_instance_tags" { type = "list" }
variable "instance_db_service_accounts" { type = "list" }

variable "instance_ladder_settings" { type = "map" }
variable "instance_ladder_instance_tags" { type = "list" }
variable "instance_ladder_service_accounts" { type = "list" }

variable "instance_consul_settings" { type = "map" }
variable "instance_consul_instance_tags" { type = "list" }
variable "instance_consul_service_accounts" { type = "list" }

/**
 * モジュール読み込み
 * https://www.terraform.io/docs/configuration/modules.html
 */

# インスタンス設定-----------------------------------------

# ansible
module "instance_ansible" {
  source = "../../modules/instance_add_static_ip"

  instance_add_static_ip_variables {
    count             = "${var.instance_ansible_settings["count"]}"
    machine_type      = "${var.instance_ansible_settings["machine_type"]}"
    name              = "${var.env == "prd" ? "ansible%04d" : "${var.env}-ansible%04d"}"
    image             = "${var.instance_ansible_settings["image"]}"
    size              = "${var.instance_ansible_settings["size"]}"
    network_interface = "${var.project_name}-${var.env}"
    env               = "${var.env}"
  }

  instance_zones = "${var.zones}"
  instance_tags = "${var.instance_ansible_instance_tags}"
  service_accounts = "${concat(var.common_instance_service_accounts, var.instance_ansible_service_accounts)}"
}

# web
module "instance_web" {
  source = "../../modules/instance"

  instance_variables {
    count             = "${var.instance_web_settings["count"]}"
    machine_type      = "${var.instance_web_settings["machine_type"]}"
    name              = "${var.env == "prd" ? "web%04d" : "${var.env}-web%04d"}"
    image             = "${var.instance_web_settings["image"]}"
    size              = "${var.instance_web_settings["size"]}"
    network_interface = "${var.project_name}-${var.env}"
    env               = "${var.env}"
  }

  instance_zones = "${var.zones}"
  instance_tags = "${var.instance_web_instance_tags}"
  service_accounts = "${concat(var.common_instance_service_accounts, var.instance_web_service_accounts)}"
}

# mysql
module "instance_db" {
  source = "../../modules/instance_add_disk"

  instance_add_disk_variables {
    count                    = "${var.instance_db_settings["count"]}"
    machine_type             = "${var.instance_db_settings["machine_type"]}"
    name                     = "${var.env == "prd" ? "db%04d" : "${var.env}-db%04d"}"
    image                    = "${var.instance_db_settings["image"]}"
    size                     = "${var.instance_db_settings["size"]}"
    network_interface        = "${var.project_name}-${var.env}"
    add_disk_name            = "${var.env == "prd" ? "db-data%04d" : "${var.env}-db-data%04d"}"
    add_disk_size            = "${var.instance_db_settings["add_disk_size"]}"
    add_disk_type            = "${var.instance_db_settings["add_disk_type"]}"
    private_key              = "${var.instance_db_settings["private_key"]}"
    disk_partition_file_path = "${var.instance_db_settings["disk_partition_file_path"]}"
    mount_path               = "${var.instance_db_settings["mount_path"]}"
    env                      = "${var.env}"
  }

  instance_zones = "${var.zones}"
  instance_tags = "${var.instance_db_instance_tags}"
  service_accounts = "${concat(var.common_instance_service_accounts, var.instance_db_service_accounts)}"
}

# ladder shd, prd
module "instance_ladder" {
  source = "../../modules/instance_add_static_ip"

  instance_add_static_ip_variables {
    count             = "${var.instance_ladder_settings["count"]}"
    machine_type      = "${var.instance_ladder_settings["machine_type"]}"
    name              = "${var.env == "prd" ? "ladder%04d" : "${var.env}-ladder%04d"}"
    image             = "${var.instance_ladder_settings["image"]}"
    size              = "${var.instance_ladder_settings["size"]}"
    network_interface = "${var.project_name}-${var.env}"
    env               = "${var.env}"
  }

  instance_zones = "${var.zones}"
  instance_tags = "${var.instance_ladder_instance_tags}"
  service_accounts = "${concat(var.common_instance_service_accounts, var.instance_ladder_service_accounts)}"
}

# consul shd, prd
module "instance_consul" {
  source = "../../modules/instance"

  instance_variables {
    count             = "${var.instance_consul_settings["count"]}"
    machine_type      = "${var.instance_consul_settings["machine_type"]}"
    name              = "${var.env == "prd" ? "consul%04d" : "${var.env}-consul%04d"}"
    image             = "${var.instance_consul_settings["image"]}"
    size              = "${var.instance_consul_settings["size"]}"
    network_interface = "${var.project_name}-${var.env}"
    env               = "${var.env}"
  }

  instance_zones = "${var.zones}"
  instance_tags = "${var.instance_consul_instance_tags}"
  service_accounts = "${concat(var.common_instance_service_accounts, var.instance_consul_service_accounts)}"
}
