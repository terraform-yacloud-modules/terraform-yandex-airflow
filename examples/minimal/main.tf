module "airflow" {
  source = "../../"

  airflow_cluster_name   = "airflow-created-with-terraform"
  airflow_admin_password = "1qaz2wsx3edc4rfvQWERT!@#"

  airflow_subnets = [
    {
      name           = "subnet-a"
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["192.168.10.0/24"]
    },
    {
      name           = "subnet-b"
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["192.168.20.0/24"]
    },
    {
      name           = "subnet-d"
      zone           = "ru-central1-d"
      v4_cidr_blocks = ["192.168.30.0/24"]
    }
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

  service_account_name = "airflow-service-account-v3"
  bucket_name          = "bucket-for-airflow-dags-v3"
  vpc_network_name     = "airflow-network"

}