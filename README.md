# アプリで使用するterraformコードのテンプレート

terraform version: 0.10.8


## 各環境の構築

1.各環境のterraform.tfstateファイルをGCSで管理します。<br />
  GCSで管理用のバケットを作成し、tasks以下の各環境ディレクトリ以下にある`backend.tf`にパスを記載します。

2.terraformでアクセスするためのサービスアカウント登録してkeyを紐付け、「keys/service_account/access.json」に配置します。

(3.) provisionersを設定しているmoduleではssh接続が必要です。<br />
     対象のmoduleを使用する場合ssh鍵を登録し、「keys/ssh/access_key」に配置します。(terraform-user)<br />
     ```
     ssh-keygen -t rsa -f ./access_key -C terraform-user
     ```

     ※ 現在の対象module: [instance_add_disk][instance_add_disk_add_static_ip]
     ※ こちらを利用する際は別途ファイアーウォール設定が必要です。常に許可出来ない場合はterraform実行用サーバを用意し、そこからのFWルールを設定しておきましょう。

4.ssh証明書を登録する場合は 証明書:「keys/ssl/certificate.pem」中間証明書:「keys/ssl/chain_certificate.pem」プライベートキー:「keys/ssl/private.key」をそれぞれ配置して下さい。

5.プロジェクト毎の設定を`common.tfvars`に記載します。

6.各タスク毎の設定を各環境ディレクトリ以下にある`terraform.tfvars`に記載します。

7.実行はトップにある`terraform_execute.sh`を利用して実行します。

実行例:
```shell
./terraform_execute.sh plan network
./terraform_execute.sh apply network
./terraform_execute.sh destroy network
```

## その他
・ GCPプロジェクト作成は「scripts/gcp_setup/gcp_setup.sh」で行います。
・ terraformサーバの作成は「scripts/gcp_setup/terraform_setup.sh」で行います。

## 現在のディレクトリ構造
```
├── README.md
├── common.tf
├── common.tfvars
├── keys
│   ├── service_account
│   │   └── access.json
│   ├── ssh
│   │   ├── access_key
│   │   └── access_key.pub
│   └── ssl
│       ├── certificate.pem
│       ├── chain_certificate.pem
│       └── private.key
├── modules
│   ├── backend_service_1
│   │   └── backend_service_1.tf
│   ├── backend_service_2
│   │   └── backend_service_2.tf
│   ├── backend_service_3
│   │   └── backend_service_3.tf
│   ├── dns_record
│   │   └── dns_record.tf
│   ├── dns_zone
│   │   └── dns_zone.tf
│   ├── firewall
│   │   └── firewall.tf
│   ├── forwarding_rule_internal
│   │   └── forwarding_rule_internal.tf
│   ├── global_address
│   │   └── global_address.tf
│   ├── global_forwarding_rule
│   │   └── global_forwarding_rule.tf
│   ├── health_check
│   │   └── health_check.tf
│   ├── http_health_check
│   │   └── http_health_check.tf
│   ├── instance
│   │   └── instance.tf
│   ├── instance_add_disk
│   │   └── instance_add_disk.tf
│   ├── instance_add_disk_add_static_ip
│   │   └── instance_add_disk_add_static_ip.tf
│   ├── instance_add_static_ip
│   │   └── instance_add_static_ip.tf
│   ├── instance_group
│   │   └── instance_group.tf
│   ├── network
│   │   └── network.tf
│   ├── region_backend_service_1
│   │   └── region_backend_service_1.tf
│   ├── region_backend_service_2
│   │   └── region_backend_service_2.tf
│   ├── region_backend_service_3
│   │   └── region_backend_service_3.tf
│   ├── ssl_certificate
│   │   └── ssl_certificate.tf
│   ├── subnetwork
│   │   └── subnetwork.tf
│   ├── target_http_proxy
│   │   └── target_http_proxy.tf
│   ├── target_https_proxy
│   │   └── target_https_proxy.tf
│   ├── target_tcp_proxy
│   │   └── target_tcp_proxy.tf
│   └── url_map
│       └── url_map.tf
├── provider.tf
├── scripts
│   ├── disk_partition
│   │   └── disk_partition.sh
│   └── gcp_setup
│       ├── gcp_setup.sh
│       └── terraform_setup.sh
├── tasks
│   ├── dns
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   ├── firewall
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   ├── instance
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   ├── loadbalancer_http
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   ├── loadbalancer_https
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   ├── loadbalancer_tcp
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   ├── network
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   └── subnetwork
│       ├── backend.tf
│       ├── main.tf
│       └── terraform.tfvars
└── terraform_execute.sh
```
