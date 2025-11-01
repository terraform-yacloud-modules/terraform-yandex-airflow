# Yandex Cloud <RESOURCE> Terraform module

Terraform module which creates Yandex Cloud <RESOURCE> resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_airflow_cluster.my_airflow_cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/airflow_cluster) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | n/a | `string` | n/a | yes |
| <a name="input_airflow_admin_password"></a> [airflow\_admin\_password](#input\_airflow\_admin\_password) | Admin password for Airflow cluster | `string` | n/a | yes |
| <a name="input_airflow_cluster_name"></a> [airflow\_cluster\_name](#input\_airflow\_cluster\_name) | Name of the Airflow cluster | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the storage bucket for Airflow DAGs | `string` | n/a | yes |
| <a name="input_pip_packages"></a> [pip\_packages](#input\_pip\_packages) | List of pip packages to install in Airflow cluster | `list(string)` | n/a | yes |
| <a name="input_scheduler_config"></a> [scheduler\_config](#input\_scheduler\_config) | Scheduler configuration for Airflow cluster | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | n/a | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | ID of the IAM service account that is used by the trail | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_webserver_config"></a> [webserver\_config](#input\_webserver\_config) | Webserver configuration for Airflow cluster | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |
| <a name="input_worker_config"></a> [worker\_config](#input\_worker\_config) | Worker configuration for Airflow cluster | <pre>object({<br/>    min_count          = number<br/>    max_count          = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_airflow_cluster_id"></a> [airflow\_cluster\_id](#output\_airflow\_cluster\_id) | ID созданного кластера Airflow |
| <a name="output_airflow_cluster_name"></a> [airflow\_cluster\_name](#output\_airflow\_cluster\_name) | Имя созданного кластера Airflow |
| <a name="output_airflow_cluster_status"></a> [airflow\_cluster\_status](#output\_airflow\_cluster\_status) | Статус кластера Airflow |
| <a name="output_airflow_created_at"></a> [airflow\_created\_at](#output\_airflow\_created\_at) | Время создания кластера Airflow |
| <a name="output_airflow_health"></a> [airflow\_health](#output\_airflow\_health) | Состояние здоровья кластера Airflow |
| <a name="output_airflow_log_group_id"></a> [airflow\_log\_group\_id](#output\_airflow\_log\_group\_id) | ID группы логов Cloud Logging для кластера Airflow |
| <a name="output_airflow_service_account_id"></a> [airflow\_service\_account\_id](#output\_airflow\_service\_account\_id) | ID сервисного аккаунта, используемого кластером Airflow |
| <a name="output_airflow_subnet_ids"></a> [airflow\_subnet\_ids](#output\_airflow\_subnet\_ids) | Список ID подсетей, используемых кластером Airflow |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/blob/main/LICENSE).
