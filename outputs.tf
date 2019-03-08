output "depends" {
  description = "Modules are missing the depends_on feature. Faking this feature with input and output variables"
  value       = "${coalesce(null_resource.bootstrap.0.id, "")}"

  # TODO(mbernadin): remove coalesce when nil on destroy is fixed: https://github.com/hashicorp/terraform/issues/17862
}
