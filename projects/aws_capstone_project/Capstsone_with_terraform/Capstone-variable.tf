variable "vpc_cidr_block" {}
variable "Public1a" {}
variable "Public1b" {}
variable "Private1a" {}
variable "Private1b" {}
variable "env_prefix" {}
variable "AZ_1A" {}
variable "AZ_1B" {}

variable "instance_type" {}

variable "key_name" {}

variable "image_id" {}
variable "LT_resource_type" {}

variable "nat_ami" {}
variable "lb_target_type" {}
variable "load_balancer_type" {}

variable "listener_http_type" {}
variable "listener_https_type" {}
variable "ASG_health_check_type" {}
variable "db_subnet" {}
variable "db_instance_identifier" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_backup_window" {}
variable "db_maintenance_window" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_parameter_group_name" {}
variable "db_port" {}
variable "db_allocated_storage" {}
variable "db_max_allocated_storage" {}
variable "db_backup_retention_period" {}

variable "failover_bucket" {}
variable "failover_acl" {}
variable "s3_object_key" {}
variable "s3_object_key2" {}
variable "blog_acl" {}
variable "blog_bucket" {}
variable "blog_index_document" {}

variable "acm_domain" {}
variable "acm_types" {}

variable "domain_name" {}

variable "lambda_policy_arn" {
  type = list(string)
}

#variable "zone_id" {}
variable "cf_origin_protocol_policy" {}
variable "cf_origin_ssl_protocols" {}

variable "cf_aliases" {}
variable "cf_allowed_methods" {}

variable "cf_cached_methods" {}

variable "cf_viewer_protocol_policy" {}

variable "cf_path_pattern" {}
variable "cf_forward" {}

variable "cf_price_class" {}

variable "cf_restriction_type" {}

variable "cf_ssl_support_method" {}

variable "cf_minimum_protocol_version" {}

variable "rt53_type" {}              
variable "rt53_resource_path" {}
variable "rt53_failure_threshold"{}
variable "rt53_request_interval"  {}
variable "rt53_set_identifier" {}
variable "rt53_failover_type" {}
variable "rt53_record_type" {}
variable "rt53_failover_secondary_type" {}
variable "dy_billing_mode" {}

variable "dy_hash_key" {}

variable "dy_type" {}

variable "archive_type" {}

variable "lambda_source_file" {}

variable "lambda_filename" {}
variable "lambda_function_name" {}
variable "handler" {}
variable "runtime" {}

variable "s3_trigger_events" {}

variable "s3_trigger_filter_prefix" {}
variable "lambda_trigger_statement_id" {}
variable "lambda_trigger_action" {}
variable "lambda_trigger_principal" {}
/*variable "target_dns_name" {
  type = string
  description = "domain"
}*/
#variable "rt53_secondary_bucket_name " {}