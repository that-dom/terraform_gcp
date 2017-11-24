variable "ssl_certificate_variables" {
  type        = "map"
  description = "ssl_certificate変数"
  default = {
    name        = ""
    description = ""
    private_key = ""
    certificate = ""
    chain_key   = ""
  }
}

/**
 * SSL_CERTIVICATE作成
 * https://www.terraform.io/docs/providers/google/r/compute_ssl_certificate.html
 */
resource "google_compute_ssl_certificate" "ssl_certificate" {
  name        = "${var.ssl_certificate_variables["name"]}"
  description = "${var.ssl_certificate_variables["description"]}"
  private_key = "${file(var.ssl_certificate_variables["private_key"])}"
  certificate = "${file(var.ssl_certificate_variables["certificate"])}\n${file(var.ssl_certificate_variables["chain_key"])}"
}

output "ssl_certificate_link" {
    value = ["${google_compute_ssl_certificate.ssl_certificate.self_link}"]
}
