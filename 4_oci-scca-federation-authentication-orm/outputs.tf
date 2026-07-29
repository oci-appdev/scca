output "identity_provider_id" {
  description = "SCIM identifier of the AD FS SAML identity provider."
  value       = oci_identity_domains_identity_provider.adfs.id
}

output "identity_provider_name" {
  description = "AD FS identity-provider partner name."
  value       = oci_identity_domains_identity_provider.adfs.partner_name
}

output "identity_provider_enabled" {
  description = "Whether OCI has activated the AD FS identity provider."
  value       = oci_identity_domains_identity_provider.adfs.enabled
}

output "identity_provider_published" {
  description = "Whether the AD FS option is shown on the OCI identity-domain login page."
  value       = oci_identity_domains_identity_provider.adfs.shown_on_login_page
}

output "oci_service_provider_metadata_url" {
  description = "Import this OCI SAML service-provider metadata URL into AD FS as the relying party."
  value       = local.service_provider_metadata_url
}

output "oci_my_profile_url" {
  description = "OCI identity-domain My Profile URL used for local factor enrollment and review."
  value       = local.my_profile_url
}

output "adfs_metadata_sha256" {
  description = "SHA-256 fingerprint of the supplied public AD FS metadata for change evidence."
  value       = sha256(local.adfs_metadata_xml)
}

output "activation_readiness_json" {
  description = "Non-secret machine-readable status for the activation and publication gates."
  value = jsonencode({
    identity_domain          = var.identity_domain_display_name
    provisioning_mode       = upper(var.group_provisioning_mode)
    break_glass_ready        = local.break_glass_ready
    activation_ready         = local.activation_ready
    identity_provider_active = var.activate_adfs_idp
    publication_ready        = local.publication_ready
    login_option_published   = var.publish_adfs_on_login_page
    change_ticket_recorded   = length(trimspace(var.activation_change_ticket)) >= 3
  })
}

output "manual_steps_remaining_json" {
  description = "Manual controls that Terraform intentionally does not perform."
  value = jsonencode([
    "Configure the OCI relying party and approved MFA access-control policy in AD FS.",
    "Map the SAML NameID email value to the OCI user's Primary email address.",
    "Test two OCI-local break-glass accounts and their OCI-native phishing-resistant factors.",
    "Assign the AD FS provider to an OCI IdP policy rule that excludes break-glass accounts.",
    "Test normal, privileged, disabled, unmatched, and failure-path sign-ins.",
    "Collect audit evidence and configure alerting for break-glass use and federation changes."
  ])
}

output "break_glass_control_attestation_json" {
  description = "Non-secret break-glass test attestation recorded with the Resource Manager job."
  value = jsonencode({
    tested_account_count = var.break_glass_account_count
    last_test_date_utc   = var.break_glass_last_test_date
    ready                = local.break_glass_ready
  })
}
