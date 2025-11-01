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
| [yandex_iam_service_account.for-airflow](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.airflow_bucket_access_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_resourcemanager_folder_iam_binding.editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_resourcemanager_folder_iam_binding.storage_editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_storage_bucket.airflow_dags_bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |
| [yandex_vpc_network.airflow-network](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.subnets](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airflow_admin_password"></a> [airflow\_admin\_password](#input\_airflow\_admin\_password) | Admin password for Airflow cluster | `string` | n/a | yes |
| <a name="input_airflow_cluster_name"></a> [airflow\_cluster\_name](#input\_airflow\_cluster\_name) | Name of the Airflow cluster | `string` | n/a | yes |
| <a name="input_airflow_subnets"></a> [airflow\_subnets](#input\_airflow\_subnets) | List of subnet configurations for Airflow cluster | <pre>list(object({<br/>    name           = string<br/>    zone           = string<br/>    v4_cidr_blocks = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the storage bucket for Airflow DAGs | `string` | n/a | yes |
| <a name="input_pip_packages"></a> [pip\_packages](#input\_pip\_packages) | List of pip packages to install in Airflow cluster | `list(string)` | n/a | yes |
| <a name="input_scheduler_config"></a> [scheduler\_config](#input\_scheduler\_config) | Scheduler configuration for Airflow cluster | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account for Airflow cluster | `string` | n/a | yes |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | Name of the VPC network | `string` | n/a | yes |
| <a name="input_webserver_config"></a> [webserver\_config](#input\_webserver\_config) | Webserver configuration for Airflow cluster | <pre>object({<br/>    count              = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |
| <a name="input_worker_config"></a> [worker\_config](#input\_worker\_config) | Worker configuration for Airflow cluster | <pre>object({<br/>    min_count          = number<br/>    max_count          = number<br/>    resource_preset_id = string<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/blob/main/LICENSE).
