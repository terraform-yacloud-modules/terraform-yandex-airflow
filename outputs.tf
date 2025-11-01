output "airflow_cluster_id" {
  description = "ID созданного кластера Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.id
}

output "airflow_cluster_name" {
  description = "Имя созданного кластера Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.name
}

output "airflow_cluster_status" {
  description = "Статус кластера Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.status
}

# output "airflow_webserver_url" {
#   description = "URL веб-сервера Airflow"
#   value       = yandex_airflow_cluster.my_airflow_cluster.webserver.url
# }

output "airflow_service_account_id" {
  description = "ID сервисного аккаунта, используемого кластером Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.service_account_id
}

output "airflow_subnet_ids" {
  description = "Список ID подсетей, используемых кластером Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.subnet_ids
}

output "airflow_created_at" {
  description = "Время создания кластера Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.created_at
}

# Выводы для мониторинга и отладки
output "airflow_health" {
  description = "Состояние здоровья кластера Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.health
}

output "airflow_log_group_id" {
  description = "ID группы логов Cloud Logging для кластера Airflow"
  value       = yandex_airflow_cluster.my_airflow_cluster.logging.log_group_id
}

# Чувствительные данные (если необходимо)
# output "airflow_admin_password" {
#   description = "Пароль администратора Airflow"
#   value       = var.airflow_admin_password
#   sensitive   = true
# }