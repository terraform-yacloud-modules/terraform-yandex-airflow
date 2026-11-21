data "yandex_client_config" "client" {}

locals {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
}

resource "yandex_airflow_cluster" "my_airflow_cluster" {
  name               = var.airflow_cluster_name
  folder_id          = local.folder_id
  subnet_ids         = var.subnet_ids
  service_account_id = var.service_account_id
  admin_password     = var.airflow_admin_password
  description        = var.description
  labels             = var.labels

  airflow_version     = var.airflow_version
  python_version      = var.python_version
  deletion_protection = var.deletion_protection

  code_sync = {
    s3 = {
      bucket = var.bucket_name
    }
  }

  webserver     = var.webserver_config
  scheduler     = var.scheduler_config
  dag_processor = var.dag_processor_config
  worker        = var.worker_config
  triggerer     = var.triggerer_config

  maintenance_window = var.maintenance_window

  datacatalog = var.datacatalog_enabled == null ? null : {
    enabled = var.datacatalog_enabled
  }

  airflow_config = var.airflow_config
  pip_packages   = var.pip_packages
  deb_packages   = coalesce(var.deb_packages, [])

  lockbox_secrets_backend = var.lockbox_secrets_backend
  security_group_ids      = var.security_group_ids

  logging = {
    enabled   = var.logging_enabled
    folder_id = local.folder_id
    min_level = var.logging_min_level
  }

}
