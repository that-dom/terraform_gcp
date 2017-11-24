// ゾーン名リスト
zones = ["asia-northeast1-a", "asia-northeast1-b", "asia-northeast1-c"]

http_health_check_web_settings {
  request_path       = "/"
  timeout_sec        = 5
  check_interval_sec = 5
}

backend_service_web_settings {
  timeout_sec     = 10
  port_name       = "http"
  protocol        = "HTTP"
  max_utilization = 0.4
}
