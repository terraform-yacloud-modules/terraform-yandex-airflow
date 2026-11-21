# Yandex Cloud Airflow Terraform module

Terraform-модуль создаёт кластер [Yandex Managed Service for Apache Airflow](https://yandex.cloud/ru/docs/managed-airflow/) и управляет его параметрами.

Ресурс: [yandex_airflow_cluster](https://yandex.cloud/ru/docs/terraform/resources/airflow_cluster).

## Что создаёт модуль

Модуль создаёт только кластер Airflow. Сеть, подсети, сервисный аккаунт и бакет для DAG-файлов
создаются отдельно — в примерах это делают модули `terraform-yandex-vpc` и
`terraform-yandex-iam`, а бакет — ресурс `yandex_storage_bucket`.

Модуль настраивает:

- версии Apache Airflow и Python (`airflow_version`, `python_version`);
- конфигурацию компонентов кластера: `webserver`, `scheduler`, `dag_processor`, `worker`,
  `triggerer`;
- источник DAG-файлов — бакет Object Storage (`bucket_name`);
- окно технического обслуживания (`maintenance_window`);
- интеграцию с Yandex Data Catalog (`datacatalog_enabled`);
- защиту кластера от случайного удаления (`deletion_protection`);
- дополнительные пакеты `pip` и `deb`, параметры `airflow_config`;
- Lockbox Secrets Backend, доставку логов в Cloud Logging, группы безопасности и метки.

## Требования

- Terraform >= 1.3;
- провайдер `yandex-cloud/yandex` >= 0.72.0;
- сервисный аккаунт с правами на создание кластера Airflow и доступом к бакету с DAG-файлами;
- подсети в зонах, где доступен сервис. В тестовом облаке рабочие зоны — `ru-central1-a`
  и `ru-central1-d`.

## Примеры

В каталоге [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-airflow/tree/main/examples)
два примера:

- [`examples/minimal`](https://github.com/terraform-yacloud-modules/terraform-yandex-airflow/tree/main/examples/minimal) —
  минимальный набор параметров: одна подсеть на зону, бакет Object Storage, кластер с одним
  экземпляром каждого компонента;
- [`examples/complete`](https://github.com/terraform-yacloud-modules/terraform-yandex-airflow/tree/main/examples/complete) —
  все параметры модуля: явные версии Airflow и Python, triggerer, окно обслуживания,
  Data Catalog, метки, описание и защита от удаления.

Примеры рассчитаны на последовательный запуск: они создают сети и бакеты с разными именами,
но в одном каталоге. Перед запуском задайте каталог одним из способов:

```bash
export YC_FOLDER_ID=<идентификатор каталога>
```

или через переменную `folder_id` в `terraform.tfvars`:

```hcl
folder_id = "<идентификатор каталога>"
```

Запуск примера:

```bash
cd examples/complete
terraform init
terraform apply
terraform destroy
```

### Минимальный вызов модуля

Пароль администратора передавайте через переменную, чтобы он не попал в конфигурацию,
например `TF_VAR_airflow_admin_password`.

```hcl
module "airflow" {
  source = "terraform-yacloud-modules/airflow/yandex"

  airflow_cluster_name   = "airflow"
  airflow_admin_password = var.airflow_admin_password

  subnet_ids         = [yandex_vpc_subnet.a.id, yandex_vpc_subnet.d.id]
  service_account_id = yandex_iam_service_account.airflow.id

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

  bucket_name = yandex_storage_bucket.dags.bucket
}
```

### Версии Airflow и Python

Поддерживаются следующие пары версий:

| Apache Airflow | Python |
| --- | --- |
| 2.10 | 3.10 |
| 2.10 | 3.12 |
| 2.11 | 3.10 |
| 2.11 | 3.12 |
| 3.0 | 3.12 |
| 3.1 | 3.12 |

Если `airflow_version` или `python_version` не заданы, применяется версия по умолчанию,
которую предлагает облако. `dag_processor_config` нужен только для Airflow 3.x.

### Окно обслуживания

Параметр `maintenance_window` задаёт время технических работ:

```hcl
maintenance_window = {
  type = "WEEKLY"
  day  = "SUN"   # MON, TUE, WED, THU, FRI, SAT, SUN
  hour = 3       # 1-24, UTC
}
```

Для `type = "ANYTIME"` поля `day` и `hour` указывать не нужно.

### Triggerer и Data Catalog

`triggerer_config` добавляет в кластер экземпляры triggerer — они нужны для deferred-задач
(например, сенсоров, которые ждут события):

```hcl
triggerer_config = {
  count              = 1
  resource_preset_id = "c1-m4"
}
```

`datacatalog_enabled = true` включает отправку данных в Yandex Data Catalog. Если параметр не
задан, настройка не передаётся и действует значение по умолчанию.

### Защита от удаления

`deletion_protection = true` запрещает удаление кластера, в том числе через `terraform destroy`.
Перед удалением переключите параметр на `false` и примените изменения.

### Логирование

По умолчанию логи компонентов Airflow отправляются в Cloud Logging — в лог-группу по
умолчанию того каталога, где создаётся кластер. Уровень задаётся `logging_min_level`
(`TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`, `FATAL`). Если в облаке доставка логов в
Cloud Logging отключена, установите `logging_enabled = false` — так сделано в примерах.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.72.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [yandex_airflow_cluster.my_airflow_cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/airflow_cluster) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_airflow_admin_password"></a> [airflow\_admin\_password](#input\_airflow\_admin\_password) | Admin password for Airflow cluster | `string` | n/a | yes |
| <a name="input_airflow_cluster_name"></a> [airflow\_cluster\_name](#input\_airflow\_cluster\_name) | Name of the Airflow cluster | `string` | n/a | yes |
| <a name="input_airflow_config"></a> [airflow\_config](#input\_airflow\_config) | Airflow application configuration (two-level map: section -> option -> value) | `map(map(string))` | <pre>{<br/>  "api": {<br/>    "auth_backends": "airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session"<br/>  }<br/>}</pre> | no |
| <a name="input_airflow_version"></a> [airflow\_version](#input\_airflow\_version) | Apache Airflow version in `<major>.<minor>` format, for example `3.1`. If not set, the cloud default version is used. | `string` | `null` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the Object Storage bucket for Airflow DAGs (service account must have access) | `string` | n/a | yes |
| <a name="input_dag_processor_config"></a> [dag\_processor\_config](#input\_dag\_processor\_config) | DAG processor configuration for Airflow cluster. Required for Airflow 3.x | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | `null` | no |
| <a name="input_datacatalog_enabled"></a> [datacatalog\_enabled](#input\_datacatalog\_enabled) | Enable integration with Yandex Data Catalog. If not set, the setting is not sent and the cloud default applies | `bool` | `null` | no |
| <a name="input_deb_packages"></a> [deb\_packages](#input\_deb\_packages) | Set of system (deb) packages to install in the cluster | `set(string)` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Protect the Airflow cluster from accidental deletion | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Airflow cluster | `string` | `null` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID of the folder where the Airflow cluster is created. If not set, the provider folder is used. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels assigned to the Airflow cluster | `map(string)` | `null` | no |
| <a name="input_lockbox_secrets_backend"></a> [lockbox\_secrets\_backend](#input\_lockbox\_secrets\_backend) | Lockbox Secrets Backend configuration | <pre>object({<br/>    enabled = bool<br/>  })</pre> | <pre>{<br/>  "enabled": true<br/>}</pre> | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Enable delivery of Airflow logs to Cloud Logging | `bool` | `true` | no |
| <a name="input_logging_min_level"></a> [logging\_min\_level](#input\_logging\_min\_level) | Minimum log level for Cloud Logging (TRACE, DEBUG, INFO, WARN, ERROR, FATAL) | `string` | `"INFO"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window configuration. `type` is either `ANYTIME` or `WEEKLY`; for `WEEKLY` the `day` (`MON`..`SUN`) and `hour` (1-24, UTC) are required | <pre>object({<br/>    type = string<br/>    day  = optional(string)<br/>    hour = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_pip_packages"></a> [pip\_packages](#input\_pip\_packages) | List of pip packages to install in Airflow cluster | `list(string)` | `[]` | no |
| <a name="input_python_version"></a> [python\_version](#input\_python\_version) | Python version used by Airflow in `<major>.<minor>` format, for example `3.12`. If not set, the cloud default version is used. | `string` | `null` | no |
| <a name="input_scheduler_config"></a> [scheduler\_config](#input\_scheduler\_config) | Scheduler configuration for Airflow cluster | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the Airflow cluster | `list(string)` | `null` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | ID of the IAM service account used by the Airflow cluster | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the Airflow cluster | `list(string)` | n/a | yes |
| <a name="input_triggerer_config"></a> [triggerer\_config](#input\_triggerer\_config) | Triggerer configuration for Airflow cluster. If not set, the component is not created | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | `null` | no |
| <a name="input_webserver_config"></a> [webserver\_config](#input\_webserver\_config) | Webserver configuration for Airflow cluster | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |
| <a name="input_worker_config"></a> [worker\_config](#input\_worker\_config) | Worker configuration for Airflow cluster | <pre>object({<br/>    min_count          = number<br/>    max_count          = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_airflow_cluster_id"></a> [airflow\_cluster\_id](#output\_airflow\_cluster\_id) | ID созданного кластера Airflow |
| <a name="output_airflow_cluster_name"></a> [airflow\_cluster\_name](#output\_airflow\_cluster\_name) | Имя созданного кластера Airflow |
| <a name="output_airflow_cluster_status"></a> [airflow\_cluster\_status](#output\_airflow\_cluster\_status) | Статус кластера Airflow |
| <a name="output_airflow_created_at"></a> [airflow\_created\_at](#output\_airflow\_created\_at) | Время создания кластера Airflow |
| <a name="output_airflow_log_group_id"></a> [airflow\_log\_group\_id](#output\_airflow\_log\_group\_id) | ID группы логов Cloud Logging для кластера Airflow |
| <a name="output_airflow_python_version"></a> [airflow\_python\_version](#output\_airflow\_python\_version) | Версия Python, на которой работает Airflow |
| <a name="output_airflow_service_account_id"></a> [airflow\_service\_account\_id](#output\_airflow\_service\_account\_id) | ID сервисного аккаунта, используемого кластером Airflow |
| <a name="output_airflow_subnet_ids"></a> [airflow\_subnet\_ids](#output\_airflow\_subnet\_ids) | Список ID подсетей, используемых кластером Airflow |
| <a name="output_airflow_version"></a> [airflow\_version](#output\_airflow\_version) | Версия Apache Airflow в кластере |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-airflow/blob/main/LICENSE).
