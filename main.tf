data "yandex_client_config" "client" {}


# resource "yandex_storage_bucket" "airflow_dags_bucket" {
#   bucket        = var.bucket_name
#   access_key    = yandex_iam_service_account_static_access_key.airflow_bucket_access_key.access_key
#   secret_key    = yandex_iam_service_account_static_access_key.airflow_bucket_access_key.secret_key
#   force_destroy = true
# }

# resource "yandex_iam_service_account_static_access_key" "airflow_bucket_access_key" {
#   service_account_id = var.service_account_id
#   description        = "Static access key for Airflow DAGs bucket"
# }

resource "yandex_airflow_cluster" "my_airflow_cluster" {
  name               = var.airflow_cluster_name
  subnet_ids         = var.subnet_ids
  service_account_id = var.service_account_id
  admin_password     = var.airflow_admin_password

  # depends_on = [
  #   yandex_storage_bucket.airflow_dags_bucket
  # ]

  code_sync = {
    s3 = {
      bucket     = var.bucket_name # yandex_storage_bucket.airflow_dags_bucket.bucket
      access_key = var.access_key  # yandex_iam_service_account_static_access_key.airflow_bucket_access_key.access_key
      secret_key = var.secret_key  # yandex_iam_service_account_static_access_key.airflow_bucket_access_key.secret_key
    }
  }

  webserver = var.webserver_config

  scheduler = var.scheduler_config

  worker = var.worker_config

  airflow_config = {
    "api" = {
      "auth_backends" = "airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session"
    }
  }

  pip_packages = var.pip_packages

  lockbox_secrets_backend = {
    enabled = true
  }

  logging = {
    enabled   = true
    folder_id = data.yandex_client_config.client.folder_id
    min_level = "INFO"
  }
}
