// プロジェクトID
project_id = "bayguh"

// プロジェクト名
project_name = "bayguh_project"

// デフォルトリージョン名
default_region = "asia-northeast1"

# -----------------------------------------
// googleのwebコンソールIP
google_web_console_ip = ["74.125.0.0/16", "64.18.0.0/20", "64.233.160.0/19", "66.102.0.0/20", "66.249.80.0/20", "72.14.192.0/18", "108.177.8.0/21", "173.194.0.0/16", "207.126.144.0/20", "209.85.128.0/17", "216.58.192.0/19", "216.239.32.0/19", "172.217.0.0/19", "108.177.96.0/19"]

// LBヘルスチェックIP範囲
lb_health_check_source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

// インスタンスのコモンサービスアカウント
common_instance_service_accounts = [
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring.write",
  "https://www.googleapis.com/auth/servicecontrol",
  "https://www.googleapis.com/auth/service.management.readonly",
  "https://www.googleapis.com/auth/trace.append"
]

// terraformサーバのIP
terraform_ip = ["111.111.111.111/32"]
