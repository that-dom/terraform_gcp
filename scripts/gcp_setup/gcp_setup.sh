#!/bin/sh

PROJECT_ID="bayguh"
PROJECT_NAME="bayguh_project"

INSTANCE_NAME="terraform"
MACHINE_TYPE="n1-standard-1"
REGION="asia-northeast1"
ZONE="asia-northeast1-a"


_usage() {
    echo "gcp_setup.sh <command>"
}

_command() {
    echo "command=project|terraform"
}

# GCP上にプロジェクト作成
_create_project() {

    echo "PROJECT_ID: ${PROJECT_ID}, PROJECT_NAME: ${PROJECT_NAME}"
    echo "こちらでプロジェクトを作成しますか？ [Y/n]"
    read ANSWER

    case $ANSWER in
        "Y" )
            gcloud projects create ${PROJECT_ID} --name=${PROJECT_NAME}
            echo "プロジェクトを作成しました."
            break;
            ;;

        * )
            echo "プロジェクトの作成をキャンセルしました."
            exit 0
            break;
            ;;
    esac
}

# terraformサーバ作成
_create_terraform_server() {
    # 静的IP作成
    gcloud compute addresses create ${INSTANCE_NAME}-address --region ${REGION} --project=${PROJECT_ID}
    # インスタンス作成
    gcloud compute instances create ${INSTANCE_NAME} --machine-type ${MACHINE_TYPE} --zone ${ZONE} --address ${INSTANCE_NAME}-address --image-family centos-6 --image-project centos-cloud --project=${PROJECT_ID}
}

if [ $# -ne 1 ]; then
    _usage
    exit 1
fi

if [ $1 == "project" ]; then
    _create_project
elif [ $1 == "terraform" ]; then
    _create_terraform_server
else
    _command
    exit 1
fi

