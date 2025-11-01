variable "airflow_cluster_name" {
  description = "Name of the Airflow cluster"
  type        = string
}

variable "airflow_admin_password" {
  description = "Admin password for Airflow cluster"
  type        = string
  sensitive   = true
}

variable "webserver_config" {
  description = "Webserver configuration for Airflow cluster"
  type = object({
    count              = number
    resource_preset_id = string
  })
}

variable "scheduler_config" {
  description = "Scheduler configuration for Airflow cluster"
  type = object({
    count              = number
    resource_preset_id = string
  })
}

variable "worker_config" {
  description = "Worker configuration for Airflow cluster"
  type = object({
    min_count          = number
    max_count          = number
    resource_preset_id = string
  })
}

variable "pip_packages" {
  description = "List of pip packages to install in Airflow cluster"
  type        = list(string)
}

variable "service_account_id" {
  description = "ID of the IAM service account that is used by the trail"
  type        = string
}


variable "bucket_name" {
  description = "Name of the storage bucket for Airflow DAGs"
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}
