variable "airflow_cluster_name" {
  description = "Name of the Airflow cluster"
  type        = string
}

variable "airflow_admin_password" {
  description = "Admin password for Airflow cluster"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "ID of the folder where the Airflow cluster is created. If not set, the provider folder is used."
  type        = string
  default     = null
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

variable "airflow_version" {
  description = "Apache Airflow version in `<major>.<minor>` format, for example `3.1`. If not set, the cloud default version is used."
  type        = string
  default     = null

  validation {
    condition     = var.airflow_version == null || can(regex("^\\d+\\.\\d+$", var.airflow_version))
    error_message = "airflow_version must be in `<major>.<minor>` format, for example 3.1."
  }
}

variable "python_version" {
  description = "Python version used by Airflow in `<major>.<minor>` format, for example `3.12`. If not set, the cloud default version is used."
  type        = string
  default     = null

  validation {
    condition     = var.python_version == null || can(regex("^\\d+\\.\\d+$", var.python_version))
    error_message = "python_version must be in `<major>.<minor>` format, for example 3.12."
  }
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

variable "dag_processor_config" {
  description = "DAG processor configuration for Airflow cluster. Required for Airflow 3.x"
  type = object({
    count              = number
    resource_preset_id = string
  })
  default = null
}

variable "worker_config" {
  description = "Worker configuration for Airflow cluster"
  type = object({
    min_count          = number
    max_count          = number
    resource_preset_id = string
  })
}

variable "triggerer_config" {
  description = "Triggerer configuration for Airflow cluster. If not set, the component is not created"
  type = object({
    count              = number
    resource_preset_id = string
  })
  default = null
}

variable "maintenance_window" {
  description = "Maintenance window configuration. `type` is either `ANYTIME` or `WEEKLY`; for `WEEKLY` the `day` (`MON`..`SUN`) and `hour` (1-24, UTC) are required"
  type = object({
    type = string
    day  = optional(string)
    hour = optional(number)
  })
  default = null

  validation {
    condition     = var.maintenance_window == null ? true : contains(["ANYTIME", "WEEKLY"], var.maintenance_window.type)
    error_message = "maintenance_window.type must be either ANYTIME or WEEKLY."
  }

  validation {
    condition     = var.maintenance_window == null ? true : var.maintenance_window.type == "ANYTIME" ? true : var.maintenance_window.day != null && var.maintenance_window.hour != null
    error_message = "For a WEEKLY maintenance window both day and hour must be set."
  }

  validation {
    condition     = var.maintenance_window == null ? true : var.maintenance_window.day == null ? true : contains(["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"], var.maintenance_window.day)
    error_message = "maintenance_window.day must be one of MON, TUE, WED, THU, FRI, SAT, SUN."
  }
}

variable "datacatalog_enabled" {
  description = "Enable integration with Yandex Data Catalog. If not set, the setting is not sent and the cloud default applies"
  type        = bool
  default     = null
}

variable "deletion_protection" {
  description = "Protect the Airflow cluster from accidental deletion"
  type        = bool
  default     = false
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
  description = "ID of the IAM service account used by the Airflow cluster"
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
