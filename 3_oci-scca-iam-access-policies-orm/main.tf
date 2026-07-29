resource "oci_identity_policy" "tenancy" {
  for_each = var.enable_tenancy_scope_policies ? local.tenancy_policies : {}

  compartment_id = var.tenancy_ocid
  name           = each.value.name
  description    = each.value.description
  statements     = each.value.statements

  lifecycle {
    precondition {
      condition     = length(local.invalid_functional_workload_keys) == 0
      error_message = "One or more functional workload assignments do not exist in workload_compartment_ocids_json: ${join(", ", local.invalid_functional_workload_keys)}"
    }

    precondition {
      condition     = local.policy_names_are_valid && local.policy_statements_are_valid
      error_message = "Every rendered policy name and statement must satisfy OCI length and character requirements. Shorten the naming inputs."
    }

    precondition {
      condition     = local.policy_guardrails_are_satisfied
      error_message = "A generated statement violates the protected IAM guardrail list. This stack cannot grant broad or identity-administration write permissions."
    }
  }

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

resource "oci_identity_policy" "home" {
  for_each = local.fixed_home_policies

  compartment_id = var.home_compartment_ocid
  name           = each.value.name
  description    = each.value.description
  statements     = each.value.statements

  lifecycle {
    precondition {
      condition     = length(local.invalid_functional_workload_keys) == 0
      error_message = "One or more functional workload assignments do not exist in workload_compartment_ocids_json: ${join(", ", local.invalid_functional_workload_keys)}"
    }

    precondition {
      condition     = local.policy_names_are_valid && local.policy_statements_are_valid
      error_message = "Every rendered policy name and statement must satisfy OCI length and character requirements. Shorten the naming inputs."
    }

    precondition {
      condition     = local.policy_guardrails_are_satisfied && local.home_policy_scopes_are_compartment_bound
      error_message = "A home policy violates the protected IAM guardrails or is not bound to an exact compartment OCID."
    }
  }

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

resource "oci_identity_policy" "workload_admin" {
  for_each = local.workload_admin_policies

  compartment_id = var.home_compartment_ocid
  name           = each.value.name
  description    = each.value.description
  statements     = each.value.statements

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

resource "oci_identity_policy" "functional_workload" {
  for_each = local.functional_policies

  compartment_id = var.home_compartment_ocid
  name           = each.value.name
  description    = each.value.description
  statements     = each.value.statements

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}
