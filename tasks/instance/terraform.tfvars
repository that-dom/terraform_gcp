// 環境
env = "prd"

// リージョン名
region = "asia-northeast1"
// ゾーン名リスト
zones = ["asia-northeast1-a", "asia-northeast1-b", "asia-northeast1-c"]

# machine_type
# [f1-micro, g1-small]
# [n1-standard-1, n1-standard-2, n1-standard-4, n1-standard-8, n1-standard-16, n1-standard-32, n1-standard-64]
# [n1-highmem-2, n1-highmem-4, n1-highmem-8, n1-highmem-16, n1-highmem-32, n1-highmem-64]
# [n1-highcpu-2, n1-highcpu-4, n1-highcpu-8, n1-highcpu-16, n1-highcpu-32, n1-highcpu-64]

# add_disk_type
# [pd-standard, pd-ssd]


// instance: ansible設定
instance_ansible_settings {
  count        = 1
  machine_type = "n1-standard-1"
  image        = "centos-6-v20171018"
  size         = 10
}
instance_ansible_instance_tags = ["prd", "ansible", "consul"]
instance_ansible_service_accounts = []

// instance: web設定
instance_web_settings {
  count        = 2
  machine_type = "n1-standard-1"
  image        = "centos-6-v20171018"
  size         = 100
}
instance_web_instance_tags = ["prd", "web", "consul"]
instance_web_service_accounts = [
  "https://www.googleapis.com/auth/devstorage.full_control",
  "https://www.googleapis.com/auth/bigquery",
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/userinfo.email"
]

// instance: mysql設定
instance_db_settings {
  count                    = 2
  machine_type             = "n1-standard-1"
  image                    = "centos-6-v20171018"
  size                     = 20
  add_disk_size            = "100"
  add_disk_type            = "pd-ssd"
  private_key              = "../../keys/ssh/access_key"
  disk_partition_file_path = "../../scripts/disk_partition/disk_partition.sh"
  mount_path               = "/var/lib/mysql5.7"
}
instance_db_instance_tags = ["prd", "db", "consul"]
instance_db_service_accounts = []

// instance: ladder設定
instance_ladder_settings {
  count        = 1
  machine_type = "f1-micro"
  image        = "centos-6-v20171018"
  size         = 10
}
instance_ladder_instance_tags = ["prd", "ladder", "consul"]
instance_ladder_service_accounts = [
  "https://www.googleapis.com/auth/devstorage.full_control",
  "https://www.googleapis.com/auth/bigquery",
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/userinfo.email"
]

// instance: consul設定
instance_consul_settings {
  count        = 1
  machine_type = "g1-small"
  image        = "centos-6-v20171018"
  size         = 10
}
instance_consul_instance_tags = ["prd", "consul"]
instance_consul_service_accounts = []
