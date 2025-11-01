module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account?ref=v1.0.0"

  name = "iam-yandex-compute-instance-group"
  folder_roles = [
    "editor",
    "storage.admin",
  ]
  cloud_roles              = []
  enable_static_access_key = false
  enable_api_key           = false
  enable_account_key       = false

}

data "yandex_client_config" "client" {}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v3.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "vpc-nat-gateway"
  azs = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  private_subnets = [["10.10.0.0/24"], ["10.11.0.0/24"], ["10.12.0.0/24"]]

}


module "storage_buckets" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-storage-bucket?ref=v1.40.0"

  bucket_name   = "my-unique-bucket-name"
  storage_roles = ["storage.admin", "storage.viewer"]
}

####

module "airflow" {
  source = "../../"

  airflow_cluster_name   = "airflow-created-with-terraform"
  airflow_admin_password = "1qaz2wsx3edc4rfvQWERT!@#"

  subnet_ids = [
    module.network.private_subnets_ids[0],
    module.network.private_subnets_ids[1],
    module.network.private_subnets_ids[2]
  ]

  webserver_config = {
    count              = 1
    resource_preset_id = "c1-m4"
  }

  scheduler_config = {
    count              = 1
    resource_preset_id = "c1-m4"
  }

  worker_config = {
    min_count          = 1
    max_count          = 2
    resource_preset_id = "c1-m4"
  }

  pip_packages = ["dbt"]

  bucket_name          = "bucket-for-airflow-dags-v3"
  vpc_network_name     = "airflow-network"
  service_account_id   = module.iam_accounts.id

  depends_on = [
    module.iam_accounts,
    module.network,
    module.storage_buckets
    ]

}