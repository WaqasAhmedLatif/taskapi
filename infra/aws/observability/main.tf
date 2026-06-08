locals {
  name = "${var.project_name}-${var.environment}"

  tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "observability"
    },
    var.tags
  )
}

resource "aws_cloudwatch_log_group" "prometheus" {
  count = var.enable_prometheus_logging ? 1 : 0

  name              = "/aws/aps/workspaces/${local.name}"
  retention_in_days = var.prometheus_log_retention_days
}

resource "aws_prometheus_workspace" "this" {
  alias = local.name

  dynamic "logging_configuration" {
    for_each = var.enable_prometheus_logging ? [1] : []

    content {
      log_group_arn = "${aws_cloudwatch_log_group.prometheus[0].arn}:*"
    }
  }
}

data "aws_iam_policy_document" "grafana_assume_role" {
  count = var.enable_managed_grafana ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["grafana.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "grafana" {
  count = var.enable_managed_grafana ? 1 : 0

  name               = "${local.name}-grafana-workspace"
  assume_role_policy = data.aws_iam_policy_document.grafana_assume_role[0].json
}

data "aws_iam_policy_document" "grafana_prometheus" {
  count = var.enable_managed_grafana ? 1 : 0

  statement {
    sid = "DiscoverAndQueryPrometheus"

    actions = [
      "aps:DescribeWorkspace",
      "aps:GetLabels",
      "aps:GetMetricMetadata",
      "aps:GetSeries",
      "aps:ListWorkspaces",
      "aps:QueryMetrics",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "grafana_prometheus" {
  count = var.enable_managed_grafana ? 1 : 0

  name   = "${local.name}-grafana-prometheus"
  role   = aws_iam_role.grafana[0].id
  policy = data.aws_iam_policy_document.grafana_prometheus[0].json
}

resource "aws_iam_role_policy_attachment" "grafana_cloudwatch" {
  count = var.enable_managed_grafana && contains(var.grafana_data_sources, "CLOUDWATCH") ? 1 : 0

  role       = aws_iam_role.grafana[0].name
  policy_arn = "arn:${var.aws_partition}:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
}

resource "aws_grafana_workspace" "this" {
  count = var.enable_managed_grafana ? 1 : 0

  name                      = local.name
  description               = "TaskAPI ${var.environment} observability workspace"
  account_access_type       = var.grafana_account_access_type
  authentication_providers  = var.grafana_authentication_providers
  permission_type           = "CUSTOMER_MANAGED"
  role_arn                  = aws_iam_role.grafana[0].arn
  data_sources              = var.grafana_data_sources
  notification_destinations = var.grafana_notification_destinations
}
