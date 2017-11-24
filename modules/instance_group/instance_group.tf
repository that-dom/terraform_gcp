variable "instance_group_variables" {
  type        = "map"
  description = "instance group変数"
  default = {
    count   = 0
    name    = ""
    network = ""
  }
}

variable "instance_zones" {
  type    = "list"
  default = []
}

/**
 * インスタンスグループ作成
 * https://www.terraform.io/docs/providers/google/r/compute_instance_group.html
 */
resource "google_compute_instance_group" "instance_group" {
  count   = "${ var.instance_group_variables["count"] <= length(var.instance_zones) ? var.instance_group_variables["count"] : length(var.instance_zones) }"
  name    = "${format(var.instance_group_variables["name"], count.index+1)}"
  network = "${ var.instance_group_variables["network"]}"
  zone    = "${element(var.instance_zones, count.index)}"
}

output "instance_group_links" {
  value = "${split(",", join(",", google_compute_instance_group.instance_group.*.self_link))}"
}
