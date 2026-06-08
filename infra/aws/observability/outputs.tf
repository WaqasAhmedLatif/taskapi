output "prometheus_workspace_id" {
  description = "Amazon Managed Service for Prometheus workspace ID."
  value       = aws_prometheus_workspace.this.id
}

output "prometheus_workspace_arn" {
  description = "Amazon Managed Service for Prometheus workspace ARN."
  value       = aws_prometheus_workspace.this.arn
}

output "prometheus_endpoint" {
  description = "Amazon Managed Service for Prometheus remote write/query endpoint base URL."
  value       = aws_prometheus_workspace.this.prometheus_endpoint
}

output "prometheus_log_group_name" {
  description = "CloudWatch log group for AMP logs, when enabled."
  value       = var.enable_prometheus_logging ? aws_cloudwatch_log_group.prometheus[0].name : null
}

output "grafana_workspace_id" {
  description = "Amazon Managed Grafana workspace ID, when enabled."
  value       = var.enable_managed_grafana ? aws_grafana_workspace.this[0].id : null
}

output "grafana_workspace_endpoint" {
  description = "Amazon Managed Grafana workspace endpoint, when enabled."
  value       = var.enable_managed_grafana ? aws_grafana_workspace.this[0].endpoint : null
}

output "grafana_workspace_role_arn" {
  description = "IAM role used by Amazon Managed Grafana, when enabled."
  value       = var.enable_managed_grafana ? aws_iam_role.grafana[0].arn : null
}
