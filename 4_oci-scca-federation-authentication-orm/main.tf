resource "oci_identity_domains_identity_provider" "adfs" {
  idcs_endpoint = local.identity_domain_endpoint
  schemas       = ["urn:ietf:params:scim:schemas:oracle:idcs:IdentityProvider"]

  partner_name = var.adfs_partner_name
  description  = var.identity_provider_description
  type         = "SAML"
  metadata     = local.adfs_metadata_xml

  enabled                      = var.activate_adfs_idp
  shown_on_login_page          = var.publish_adfs_on_login_page
  requires_encrypted_assertion = var.require_encrypted_assertions
  require_force_authn          = var.require_force_authentication
  signature_hash_algorithm     = "SHA-256"

  # AD Bridge/directory synchronization is authoritative. SAML must authenticate
  # pre-provisioned users, not create or mutate cloud identities.
  jit_user_prov_enabled                           = false
  jit_user_prov_create_user_enabled               = false
  jit_user_prov_attribute_update_enabled          = false
  jit_user_prov_group_assertion_attribute_enabled = false
  jit_user_prov_group_static_list_enabled         = false

  lifecycle {
    prevent_destroy = true

    # Oracle's generated provider example ignores this server-normalized list.
    # All behavior-changing fields remain managed and reviewable.
    ignore_changes = [schemas]

    precondition {
      condition     = upper(var.group_provisioning_mode) == "AD_SYNC"
      error_message = "Federation activation requires AD_SYNC. Do not enable SAML JIT or create shadow OCI users."
    }

    precondition {
      condition     = !var.activate_adfs_idp || local.activation_ready
      error_message = "Activation blocked: test at least two local break-glass accounts, record the test date and change ticket, and enter both exact activation confirmations."
    }

    precondition {
      condition     = !var.publish_adfs_on_login_page || local.publication_ready
      error_message = "Publication blocked: activate and test the hidden IdP, assign the approved IdP policy while excluding break-glass accounts, then enter the exact publication confirmation."
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
