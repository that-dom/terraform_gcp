// リージョン名
region="asia-northeast1"
// ゾーン名リスト
zones=["asia-northeast1-a", "asia-northeast1-b", "asia-northeast1-c"]

// TCPロードバランサの設定---------------------------------------------------------
health_check_mail_settings {
  timeout_sec        = 5
  check_interval_sec = 5
  tcp_health_check_port = 25
}

backend_service_mail_settings {
  timeout_sec       = 10
  protocol          = "TCP"
  session_affinity  = "CLIENT_IP"
}

forwarding_rule_internal_mail_settings {
  ip_protocol  = "TCP"
}
forwarding_rule_ports = [25]

