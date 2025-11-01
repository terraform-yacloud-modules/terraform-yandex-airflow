data "yandex_client_config" "client" {}

resource "yandex_vpc_network" "airflow-network" {
  name = var.vpc_network_name
}

resource "yandex_vpc_subnet" "subnets" {
  for_each = { for idx, subnet in var.airflow_subnets : idx => subnet }

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.airflow-network.id
  v4_cidr_blocks = each.value.v4_cidr_blocks
}

resource "yandex_iam_service_account" "for-airflow" {
  name        = var.service_account_name
  description = "Service account for Airflow cluster"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.for-airflow.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "storage_editor" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "storage.admin"
  members = [
    "serviceAccount:${yandex_iam_service_account.for-airflow.id}"
  ]
}

resource "yandex_storage_bucket" "airflow_dags_bucket" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.airflow_bucket_access_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.airflow_bucket_access_key.secret_key
  force_destroy = true

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.storage_editor
  ]
}

resource "yandex_iam_service_account_static_access_key" "airflow_bucket_access_key" {
  service_account_id = yandex_iam_service_account.for-airflow.id
  description        = "Static access key for Airflow DAGs bucket"

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.storage_editor
  ]
}

resource "yandex_airflow_cluster" "my_airflow_cluster" {
  name               = var.airflow_cluster_name
  subnet_ids         = [for subnet in yandex_vpc_subnet.subnets : subnet.id]
  service_account_id = yandex_iam_service_account.for-airflow.id
  admin_password     = var.airflow_admin_password

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.storage_editor,
    yandex_storage_bucket.airflow_dags_bucket
  ]

  code_sync = {
    s3 = {
      bucket     = yandex_storage_bucket.airflow_dags_bucket.bucket
      access_key = yandex_iam_service_account_static_access_key.airflow_bucket_access_key.access_key
      secret_key = yandex_iam_service_account_static_access_key.airflow_bucket_access_key.secret_key
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
