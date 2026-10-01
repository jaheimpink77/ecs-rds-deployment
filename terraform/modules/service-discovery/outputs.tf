output "namespace_arn" {
  value = aws_service_discovery_http_namespace.this.arn
}

output "namespace_name" {
  value = aws_service_discovery_http_namespace.this.name
}