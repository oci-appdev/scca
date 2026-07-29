resource "oci_identity_domain" "scca" {
  compartment_id            = var.vdms_compartment_ocid
  description               = var.identity_domain_description
  display_name              = local.identity_domain_display_name
  home_region               = var.region
  license_type              = lower(var.identity_domain_license_type)
  is_hidden_on_login        = false
  is_primary_email_required = true

  lifecycle {
    precondition {
      condition     = local.group_names_are_unique
      error_message = "Human group names must be unique without regard to case. Remove duplicates across the core, workload, and additional group catalogs."
    }
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

resource "oci_identity_domains_group" "human" {
  for_each = upper(var.group_provisioning_mode) == "OCI_NATIVE" ? local.human_groups : {}

  display_name  = each.key
  idcs_endpoint = oci_identity_domain.scca.url
  schemas       = ["urn:ietf:params:scim:schemas:core:2.0:Group"]

  # Do not recursively delete members or related objects during stack destroy.
  force_delete = false

  lifecycle {
    # The provider may normalize the endpoint after the domain becomes ACTIVE.
    ignore_changes = [idcs_endpoint]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
