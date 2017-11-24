// 環境
env="prd"

# location
# MULTI_REGIONAL: [us, eu, asia]
# その他: [asia-east1, asia-northeast1, europe-west1, us-central1, us-east1, us-west1]

# storage_class
# [MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE]

# 通常バケット設定
bucket_default_settings {
  location      = "asia-northeast1"
  storage_class = "REGIONAL"
}

// バックアップ用バケット設定
bucket_backup_settings {
  location                     = "asia-northeast1"
  storage_class                = "REGIONAL"
  lifecycle_rule_action_type   = "Delete"
  lifecycle_rule_condition_age = 30
}
