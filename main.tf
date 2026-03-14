data "yandex_client_config" "client" {}

resource "yandex_airflow_cluster" "my_airflow_cluster" {
  name               = var.airflow_cluster_name
  subnet_ids         = var.subnet_ids
  service_account_id = var.service_account_id
  admin_password     = var.airflow_admin_password
  description        = var.description
  labels             = var.labels

  code_sync = {
    s3 = {
      bucket = var.bucket_name
    }
  }

  webserver = var.webserver_config
  scheduler = var.scheduler_config
  worker    = var.worker_config

  airflow_config = var.airflow_config
  pip_packages   = var.pip_packages
  deb_packages   = coalesce(var.deb_packages, [])

  lockbox_secrets_backend = var.lockbox_secrets_backend
  security_group_ids      = var.security_group_ids

  logging = {
    enabled   = var.logging_enabled
    folder_id = data.yandex_client_config.client.folder_id
    min_level = var.logging_min_level
  }

}
