module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account?ref=v1.0.0"

  name      = "iam-yandex-airflow"
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
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

provider "yandex" {
}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v3.0.0"

  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)

  blank_name = "vpc-nat-gateway"
  azs        = ["ru-central1-a", "ru-central1-d"]

  private_subnets = [["10.10.0.0/24"], ["10.12.0.0/24"]]

}

resource "yandex_storage_bucket" "dags" {
  bucket    = "airflow-dags-${coalesce(var.folder_id, data.yandex_client_config.client.folder_id)}"
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
}

module "airflow" {
  source = "../../"

  airflow_cluster_name   = "airflow-created-with-terraform"
  airflow_admin_password = "1qaz2wsx3edc4rfvQWERT!@#"

  subnet_ids = [
    module.network.private_subnets_ids[0],
    module.network.private_subnets_ids[1]
  ]

  webserver_config = {
    count              = 1
    resource_preset_id = "c1-m4"
  }

  scheduler_config = {
    count              = 1
    resource_preset_id = "c1-m4"
  }

  dag_processor_config = {
    count              = 1
    resource_preset_id = "c1-m4"
  }

  worker_config = {
    min_count          = 1
    max_count          = 2
    resource_preset_id = "c1-m4"
  }

  pip_packages = ["dbt"]

  # Cloud Logging is disabled at the cloud level in some environments.
  # Set to true to ship Airflow logs to Cloud Logging.
  logging_enabled = false

  bucket_name        = yandex_storage_bucket.dags.bucket
  service_account_id = module.iam_accounts.id

  depends_on = [
    module.iam_accounts,
    module.network
  ]
}
