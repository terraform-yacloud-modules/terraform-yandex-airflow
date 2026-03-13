variable "airflow_cluster_name" {
  description = "Name of the Airflow cluster"
  type        = string
}

variable "airflow_admin_password" {
  description = "Admin password for Airflow cluster"
  type        = string
  sensitive   = true
}

variable "description" {
  description = "Description of the Airflow cluster"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels assigned to the Airflow cluster"
  type        = map(string)
  default     = null
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
  default     = []
}

variable "deb_packages" {
  description = "Set of system (deb) packages to install in the cluster"
  type        = set(string)
  default     = null
}

variable "service_account_id" {
  description = "ID of the IAM service account that is used by the trail"
  type        = string
}


variable "bucket_name" {
  description = "Name of the Object Storage bucket for Airflow DAGs (service account must have access)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Airflow cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the Airflow cluster"
  type        = list(string)
  default     = null
}

variable "airflow_config" {
  description = "Airflow application configuration (two-level map: section -> option -> value)"
  type        = map(map(string))
  default = {
    "api" = {
      "auth_backends" = "airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session"
    }
  }
}

variable "lockbox_secrets_backend" {
  description = "Lockbox Secrets Backend configuration"
  type = object({
    enabled = bool
  })
  default = {
    enabled = true
  }
}

variable "logging_enabled" {
  description = "Enable delivery of Airflow logs to Cloud Logging"
  type        = bool
  default     = true
}

variable "logging_min_level" {
  description = "Minimum log level for Cloud Logging (TRACE, DEBUG, INFO, WARN, ERROR, FATAL)"
  type        = string
  default     = "INFO"
}
