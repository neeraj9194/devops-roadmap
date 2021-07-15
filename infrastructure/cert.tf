resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "self_cert" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.private_key.private_key_pem

  subject {
    common_name  = "application-lb-1333012772.ap-south-1.elb.amazonaws.com"
    organization = "Neeraj"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.private_key.private_key_pem
  certificate_body = tls_self_signed_cert.self_cert.cert_pem
}

resource local_file private_key {
    sensitive_content = tls_private_key.private_key.private_key_pem
    filename = "${var.output_cert_path}/ca-key.pem"
    file_permission = "0600"
}
resource local_file ca_file {
    sensitive_content = tls_self_signed_cert.self_cert.cert_pem
    filename = "${var.output_cert_path}/ca-cert.crt"
    file_permission = "0600"
}
resource local_file ca_pem_bundle {
    sensitive_content = "${tls_private_key.private_key.private_key_pem}${tls_self_signed_cert.self_cert.cert_pem}"
    filename = "${var.output_cert_path}/ca-bundle.pem"
    file_permission = "0600"
}