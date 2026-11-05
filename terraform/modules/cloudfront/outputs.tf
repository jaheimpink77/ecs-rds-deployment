output "domain_name" {
  description = "The *.cloudfront.net name that serves the app over HTTPS"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "distribution_id" {
  description = "Distribution ID, useful for cache invalidations"
  value       = aws_cloudfront_distribution.this.id
}