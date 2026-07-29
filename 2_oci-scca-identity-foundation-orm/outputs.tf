output "identity_domain_ocid" {
  description = "OCID of the SCCA identity domain."
  value       = oci_identity_domain.scca.id
}

output "identity_domain_url" {
  description = "Identity domain URL used by later federation, synchronization, and policy stacks."
  value       = oci_identity_domain.scca.url
}

output "identity_domain_display_name" {
  description = "Display name of the SCCA identity domain."
  value       = oci_identity_domain.scca.display_name
}

output "identity_domain_license_type" {
  description = "License type selected for the SCCA identity domain."
  value       = oci_identity_domain.scca.license_type
}

output "group_provisioning_mode" {
  description = "Whether groups are expected from AD synchronization or created as OCI-native groups."
  value       = upper(var.group_provisioning_mode)
}

output "required_human_group_names_json" {
  description = "JSON array of human group display names required by the landing zone."
  value       = jsonencode(sort(keys(local.human_groups)))
}

output "human_group_catalog_json" {
  description = "JSON catalog containing each group's responsibility, category, privilege flag, authority, and policy status."
  value       = jsonencode(local.human_group_catalog)
}

output "oci_native_group_ocids_json" {
  description = "JSON map of group names to OCIDs. Empty in the recommended AD_SYNC mode."
  value       = jsonencode({ for group_name, group in oci_identity_domains_group.human : group_name => group.id })
}

output "ad_bridge_guardrails_json" {
  description = "Recommended AD Bridge settings for the AD-authoritative integration configured after this stack."
  value = jsonencode({
    authentication_mode          = "FEDERATED"
    source_of_authority          = "ON_PREM_ACTIVE_DIRECTORY"
    activate_deactivate_users    = false
    update_user_attributes_in_ad = false
    update_groups_in_ad          = false
  })
}
