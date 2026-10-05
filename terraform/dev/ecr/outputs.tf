output "repository_urls" {
  value = { for key, mod in module.ecr : key => mod.repository_url}
}