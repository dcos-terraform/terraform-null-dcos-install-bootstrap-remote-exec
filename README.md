DC/OS bootstrap remote exec install
============
This module creates the DC/OS installation and configuration on a bootstrap node.

EXAMPLE
-------

```hcl
module "dcos-bootstrap-install" {
  source = "dcos-terraform/dcos-install-bootstrap-remote-exec/null"

  # version = "~> 0.1.0"

  bootstrap_ip         = "${module.dcos-infrastructure.bootstrap.public_ip}"
  bootstrap_private_ip = "${module.dcos-infrastructure.bootstrap.private_ip}"
  os_user              = "${module.dcos-infrastructure.bootstrap.os_user}"
  # Only allow upgrade and install as installation mode
  dcos_install_mode   = "install"
  dcos_bootstrap_port = "80"
  dcos_cluster_name   = "${var.cluster_name}"
  dcos_version        = "${var.dcos_version}"
  dcos_ip_detect_public_contents = <<EOF
#!/bin/sh
set -o nounset -o errexit

curl -fsSL http://whatismyip.akamai.com/
EOF
  dcos_ip_detect_contents = <<EOF
#!/bin/sh
# Example ip-detect script using an external authority
# Uses the AWS Metadata Service to get the node's internal
# ipv4 address
curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
EOF
  dcos_fault_domain_detect_contents = <<EOF
#!/bin/sh
set -o nounset -o errexit

METADATA="$(curl http://169.254.169.254/latest/dynamic/instance-identity/document 2>/dev/null)"
REGION=$(echo $METADATA | grep -Po "\"region\"\s+:\s+\"(.*?)\"" | cut -f2 -d:)
ZONE=$(echo $METADATA | grep -Po "\"availabilityZone\"\s+:\s+\"(.*?)\"" | cut -f2 -d:)

echo "{\"fault_domain\":{\"region\":{\"name\": $REGION},\"zone\":{\"name\": $ZONE}}}"
EOF
  dcos_variant                      = "ee"
   dcos_license_key_contents      = ""
  dcos_master_discovery          = "static"
  dcos_exhibitor_storage_backend = "static"
  master_ips                     = ["${module.dcos-infrastructure.masters.private_ips}"]
  dcos_num_masters               = "${length(module.dcos-infrastructure.masters.instances)}"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bootstrap_ip | The bootstrap IP to SSH to | string | - | yes |
| bootstrap_private_ip | used for the private ip for the bootstrap url | string | `` | no |
| custom_dcos_download_path | insert location of dcos installer script (optional) | string | `` | no |
| dcos_adminrouter_tls_1_0_enabled | Indicates whether to enable TLSv1 support in Admin Router. (optional) | string | `` | no |
| dcos_adminrouter_tls_1_1_enabled | Indicates whether to enable TLSv1.1 support in Admin Router. (optional) | string | `` | no |
| dcos_adminrouter_tls_1_2_enabled | Indicates whether to enable TLSv1.2 support in Admin Router. (optional) | string | `` | no |
| dcos_adminrouter_tls_cipher_suite | [Enterprise DC/OS] Indicates whether to allow web browsers to send the DC/OS authentication cookie through a non-HTTPS connection. (optional) | string | `` | no |
| dcos_agent_list | used to list the agents in the config.yaml (optional) | string | `` | no |
| dcos_audit_logging | [Enterprise DC/OS] enable security decisions are logged for Mesos, Marathon, and Jobs. (optional) | string | `` | no |
| dcos_auth_cookie_secure_flag | [Enterprise DC/OS] allow web browsers to send the DC/OS authentication cookie through a non-HTTPS connection. (optional) | string | `` | no |
| dcos_aws_access_key_id | the aws key ID for exhibitor storage  (optional but required with dcos_exhibitor_address) | string | `` | no |
| dcos_aws_region | the aws region for exhibitor storage (optional but required with dcos_exhibitor_address) | string | `` | no |
| dcos_aws_secret_access_key | the aws secret key for exhibitor storage (optional but required with dcos_exhibitor_address) | string | `` | no |
| dcos_aws_template_storage_access_key_id | the aws key ID for CloudFormation template storage (optional) | string | `` | no |
| dcos_aws_template_storage_bucket | the aws CloudFormation bucket name (optional) | string | `` | no |
| dcos_aws_template_storage_bucket_path | the aws CloudFormation bucket path (optional) | string | `` | no |
| dcos_aws_template_storage_region_name | the aws CloudFormation region name (optional) | string | `` | no |
| dcos_aws_template_storage_secret_access_key | the aws secret key for the CloudFormation template (optional) | string | `` | no |
| dcos_aws_template_upload | to automatically upload the customized advanced templates to your S3 bucket. (optional) | string | `` | no |
| dcos_bootstrap_port | used to specify the port of the bootstrap url | string | `80` | no |
| dcos_bouncer_expiration_auth_token_days | [Enterprise DC/OS] Sets the auth token time-to-live (TTL) for Identity and Access Management. (optional) | string | `` | no |
| dcos_ca_certificate_chain_path | [Enterprise DC/OS] Path (relative to the $DCOS_INSTALL_DIR) to a file containing the complete CA certification chain required for end-entity certificate verification, in the OpenSSL PEM format. (optional) | string | `` | no |
| dcos_ca_certificate_key_path |  | string | `` | no |
| dcos_ca_certificate_path | [Enterprise DC/OS] Path (relative to the $DCOS_INSTALL_DIR) to a file containing a single X.509 CA certificate in the OpenSSL PEM format. (optional) | string | `` | no |
| dcos_check_time | check if Network Time Protocol (NTP) is enabled during DC/OS startup. (optional) | string | `` | no |
| dcos_cluster_docker_credentials | The dictionary of Docker credentials to pass. (optional) | string | `` | no |
| dcos_cluster_docker_credentials_dcos_owned | Indicates whether to store the credentials file in /opt/mesosphere or /etc/mesosphere/docker_credentials. A sysadmin cannot edit /opt/mesosphere directly (optional) | string | `` | no |
| dcos_cluster_docker_credentials_enabled | Indicates whether to pass the Mesos --docker_config option to Mesos. (optional) | string | `` | no |
| dcos_cluster_docker_credentials_write_to_etc | Indicates whether to write a cluster credentials file. (optional) | string | `` | no |
| dcos_cluster_docker_registry_enabled |  | string | `` | no |
| dcos_cluster_docker_registry_url | The custom URL that Mesos uses to pull Docker images from. If set, it will configure the Mesos’ --docker_registry flag to the specified URL. (optional) | string | `` | no |
| dcos_cluster_name | sets the DC/OS cluster name | string | `` | no |
| dcos_config | used to add any extra arguments in the config.yaml that are not specified here. (optional) | string | `` | no |
| dcos_custom_checks | Custom installation checks that are added to the default check configuration process. (optional) | string | `` | no |
| dcos_customer_key | [Enterprise DC/OS] sets the customer key (optional) | string | `` | no |
| dcos_dns_bind_ip_blacklist | A list of IP addresses that DC/OS DNS resolvers cannot bind to. (optional) | string | `` | no |
| dcos_dns_forward_zones | Allow to forward DNS to certain domain requests to specific server. The [following syntax](https://github.com/dcos/dcos-docs/blob/master/1.10/installing/custom/configuration/configuration-parameters.md#dns_forward_zones) must be used in combination with [Terraform string heredoc](https://www.terraform.io/docs/configuration/variables.html#strings). (optional) (:warning: DC/OS 1.10+) | string | `` | no |
| dcos_dns_search | A space-separated list of domains that are tried when an unqualified domain is entered. (optional) | string | `` | no |
| dcos_docker_remove_delay | The amount of time to wait before removing stale Docker images stored on the agent nodes and the Docker image generated by the installer. (optional) | string | `` | no |
| dcos_enable_docker_gc | Indicates whether to run the docker-gc script, a simple Docker container and image garbage collection script, once every hour to clean up stray Docker containers. (optional) | string | `` | no |
| dcos_enable_gpu_isolation | Indicates whether to enable GPU support in DC/OS. (optional) | string | `` | no |
| dcos_exhibitor_address | The address of the load balancer in front of the masters (recommended) | string | `` | no |
| dcos_exhibitor_azure_account_key | the azure account key for exhibitor storage (optional but required with dcos_exhibitor_address) | string | `` | no |
| dcos_exhibitor_azure_account_name | the azure account name for exhibitor storage (optional but required with dcos_exhibitor_address) | string | `` | no |
| dcos_exhibitor_azure_prefix | the azure account name for exhibitor storage (optional but required with dcos_exhibitor_address) | string | `` | no |
| dcos_exhibitor_explicit_keys | set whether you are using AWS API keys to grant Exhibitor access to S3. (optional) | string | `` | no |
| dcos_exhibitor_storage_backend | options are aws_s3, azure, or zookeeper (recommended) | string | `` | no |
| dcos_exhibitor_zk_hosts | a comma-separated list of one or more ZooKeeper node IP and port addresses to use for configuring the internal Exhibitor instances. (not recommended but required with exhibitor_storage_backend set to ZooKeeper. Use aws_s3 or azure instead. Assumes external ZooKeeper is already online.) | string | `` | no |
| dcos_exhibitor_zk_path | the filepath that Exhibitor uses to store data (not recommended but required with exhibitor_storage_backend set to `zookeeper`. Use `aws_s3` or `azure` instead. Assumes external ZooKeeper is already online.) | string | `` | no |
| dcos_fault_domain_detect_contents | [Enterprise DC/OS] fault domain script contents. Optional but required if no fault-domain-detect script present. | string | `` | no |
| dcos_fault_domain_enabled | [Enterprise DC/OS] used to control if fault domain is enabled | string | `` | no |
| dcos_gc_delay | The maximum amount of time to wait before cleaning up the executor directories (optional) | string | `` | no |
| dcos_gpus_are_scarce | Indicates whether to treat GPUs as a scarce resource in the cluster. (optional) | string | `` | no |
| dcos_http_proxy | the http proxy (optional) | string | `` | no |
| dcos_https_proxy | the https proxy (optional) | string | `` | no |
| dcos_install_mode | specifies which type of command to execute. Options: `install` or `upgrade` | string | `install` | no |
| dcos_ip_detect_contents | Allows DC/OS to detect your private address. Use this to pass this as an input to the module rather than a file in side your bootstrap node. (recommended) | string | `` | no |
| dcos_ip_detect_public_contents | Allows DC/OS to be aware of your publicly routeable address for ease of use (recommended) | string | `` | no |
| dcos_ip_detect_public_filename | statically set your detect-ip-public path | string | `` | no |
| dcos_l4lb_enable_ipv6 | A boolean that indicates if layer 4 load balancing is available for IPv6 networks. (optional) | string | `` | no |
| dcos_license_key_contents | [Enterprise DC/OS] used to privide the license key of DC/OS for Enterprise Edition. Optional if license.txt is present on bootstrap node. | string | `` | no |
| dcos_log_directory | The path to the installer host logs from the SSH processes. (optional) | string | `` | no |
| dcos_master_discovery | The Mesos master discovery method. The available options are static or master_http_loadbalancer. (recommend the use of master_http_loadbalancer) | string | `` | no |
| dcos_master_dns_bindall | Indicates whether the master DNS port is open. (optional) | string | `` | no |
| dcos_master_external_loadbalancer | Allows DC/OS to configure certs around the External Load Balancer name. If not used SSL verfication issues will arrise. EE only. (recommended) | string | `` | no |
| dcos_master_list | statically set your master nodes (not recommended but required with exhibitor_storage_backend set to static. Use aws_s3 or azure instead, that way you can replace masters in the cloud.) | string | `` | no |
| dcos_mesos_container_log_sink | The log manager for containers (tasks). The options are to send logs to: 'journald', 'logrotate', 'journald+logrotate'. (optional) | string | `` | no |
| dcos_mesos_dns_set_truncate_bit | Indicates whether to set the truncate bit if the response is too large to fit in a single packet. (optional) | string | `` | no |
| dcos_mesos_max_completed_tasks_per_framework | The number of completed tasks for each framework that the Mesos master will retain in memory. (optional) | string | `` | no |
| dcos_no_proxy | A YAML nested list (-) of addresses to exclude from the proxy. (optional) | string | `` | no |
| dcos_num_masters | set the num of master nodes (required with exhibitor_storage_backend set to aws_s3, azure, ZooKeeper) | string | `` | no |
| dcos_oauth_enabled | [Open DC/OS Only] Indicates whether to enable authentication for your cluster. (optional) | string | `` | no |
| dcos_overlay_config_attempts | Specifies how many failed configuration attempts are allowed before the overlay configuration modules stop trying to configure an virtual network. (optional) | string | `` | no |
| dcos_overlay_enable | Enable to disable overlay (optional) | string | `` | no |
| dcos_overlay_mtu | The maximum transmission unit (MTU) of the Virtual Ethernet (vEth) on the containers that are launched on the overlay. (optional) | string | `` | no |
| dcos_overlay_network | This group of parameters define an virtual network for DC/OS. (optional) | string | `` | no |
| dcos_package_storage_uri | Where to permanently store DC/OS packages. The value must be a file URL. (optional) | string | `` | no |
| dcos_previous_version | DC/OS 1.9+ requires users to set this value to ensure users know the version. Terraform helps populate this value, but users can override it here. (recommended) | string | `` | no |
| dcos_previous_version_master_index | Used to track the index of master for quering the previous DC/OS version during upgrading. (optional) applicable: 1.9+ | string | `0` | no |
| dcos_process_timeout | The allowable amount of time, in seconds, for an action to begin after the process forks. (optional) | string | `` | no |
| dcos_public_agent_list | statically set your public agents (not recommended) | string | `` | no |
| dcos_resolvers | A YAML nested list (-) of DNS resolvers for your DC/OS cluster nodes. (recommended) | string | `` | no |
| dcos_rexray_config | The REX-Ray configuration method for enabling external persistent volumes in Marathon. (optional) | string | `` | no |
| dcos_rexray_config_filename | The REX-Ray configuration filename for enabling external persistent volumes in Marathon. (optional) | string | `` | no |
| dcos_rexray_config_method | The REX-Ray configuration method for enabling external persistent volumes in Marathon.  (optional) | string | `` | no |
| dcos_s3_bucket | name of the s3 bucket for the exhibitor backend (recommended but required with dcos_exhibitor_address) | string | `` | no |
| dcos_s3_prefix | name of the s3 prefix for the exhibitor backend (recommended but required with dcos_exhibitor_address) | string | `` | no |
| dcos_security | [Enterprise DC/OS] set the security level of DC/OS. Default is permissive. (recommended) | string | `` | no |
| dcos_skip_checks | Upgrade option: Used to skip all dcos checks that may block an upgrade if any DC/OS component is unhealthly. (optional) applicable: 1.10+ | string | `false` | no |
| dcos_staged_package_storage_uri | Where to temporarily store DC/OS packages while they are being added. (optional) | string | `` | no |
| dcos_superuser_password_hash | [Enterprise DC/OS] set the superuser password hash (recommended) | string | `` | no |
| dcos_superuser_username | [Enterprise DC/OS] set the superuser username (recommended) | string | `` | no |
| dcos_telemetry_enabled | change the telemetry option (optional) | string | `` | no |
| dcos_ucr_default_bridge_subnet | IPv4 subnet allocated to the mesos-bridge CNI network for UCR bridge-mode networking. (optional) | string | `` | no |
| dcos_use_proxy | to enable use of proxy for internal routing (optional) | string | `` | no |
| dcos_variant | Main Variables | string | `open` | no |
| dcos_version | specifies which dcos version instruction to use. Options: `1.9.0`, `1.8.8`, etc. _See [dcos_download_path](https://github.com/dcos/tf_dcos_core/blob/master/download-variables.tf) or [dcos_version](https://github.com/dcos/tf_dcos_core/tree/master/dcos-versions) tree for a full list._ | string | `1.9.0` | no |
| dcos_zk_agent_credentials | [Enterprise DC/OS] set the ZooKeeper agent credentials (recommended) | string | `` | no |
| dcos_zk_master_credentials | [Enterprise DC/OS] set the ZooKeeper master credentials (recommended) | string | `` | no |
| dcos_zk_super_credentials | [Enterprise DC/OS] set the zk super credentials (recommended) | string | `` | no |
| depends_on | Modules are missing the depends_on feature. Faking this feature with input and output variables | string | `<list>` | no |
| master_ips | List of masterips to SSH to | list | - | yes |
| num_of_private_agents |  | string | `` | no |
| num_of_public_agents |  | string | `` | no |
| os_user | The OS user to be used | string | `centos` | no |
| trigger | Triggers for null resource | string | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| depends | Modules are missing the depends_on feature. Faking this feature with input and output variables |

