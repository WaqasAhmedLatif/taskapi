variable "project_name" {
  description = "Short project name used in AWS resource names."
  type        = string
  default     = "taskapi"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for observability resources."
  type        = string
  default     = "us-east-1"
}

variable "aws_partition" {
  description = "AWS partition used for global AWS managed policy ARNs."
  type        = string
  default     = "aws"

  validation {
    condition     = contains(["aws", "aws-us-gov", "aws-cn"], var.aws_partition)
    error_message = "aws_partition must be aws, aws-us-gov, or aws-cn."
  }
}

variable "tags" {
  description = "Additional AWS tags."
  type        = map(string)
  default     = {}
}

variable "prometheus_log_retention_days" {
  description = "Retention for Amazon Managed Service for Prometheus query logs."
  type        = number
  default     = 30
}

variable "enable_prometheus_logging" {
  description = "Create a CloudWatch log group and enable AMP logging."
  type        = bool
  default     = true
}

variable "enable_managed_grafana" {
  description = "Create an Amazon Managed Grafana workspace. Requires account auth prerequisites such as IAM Identity Center for AWS_SSO."
  type        = bool
  default     = false
}

variable "grafana_authentication_providers" {
  description = "Authentication providers for Amazon Managed Grafana."
  type        = list(string)
  default     = ["AWS_SSO"]
}

variable "grafana_account_access_type" {
  description = "Amazon Managed Grafana account access type."
  type        = string
  default     = "CURRENT_ACCOUNT"

  validation {
    condition     = contains(["CURRENT_ACCOUNT", "ORGANIZATION"], var.grafana_account_access_type)
    error_message = "grafana_account_access_type must be CURRENT_ACCOUNT or ORGANIZATION."
  }
}

variable "grafana_data_sources" {
  description = "AWS data sources enabled for Amazon Managed Grafana."
  type        = list(string)
  default     = ["PROMETHEUS", "CLOUDWATCH"]
}

variable "grafana_notification_destinations" {
  description = "AWS notification destinations enabled for Amazon Managed Grafana."
  type        = list(string)
  default     = []
}
