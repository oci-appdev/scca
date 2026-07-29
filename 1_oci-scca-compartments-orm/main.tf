resource "oci_identity_compartment" "home" {
  compartment_id = local.effective_parent_ocid
  name           = local.home_compartment.name
  description    = local.home_compartment.description
  enable_delete  = var.enable_compartment_delete

  lifecycle {
    precondition {
      condition = alltrue([
        for name in local.all_compartment_names :
        length(name) <= 100 && can(regex("^[A-Za-z0-9._-]+$", name))
      ])
      error_message = "Every rendered compartment name must be at most 100 characters and use only letters, numbers, periods, hyphens, or underscores."
    }

    precondition {
      condition     = length(local.child_compartment_names) == length(distinct(local.child_compartment_names))
      error_message = "Rendered child compartment names must be unique beneath the SCCA home compartment."
    }
  }

  timeouts {
    create = "20m"
    update = "20m"
    delete = "90m"
  }
}

resource "oci_identity_compartment" "core" {
  for_each = local.core_compartments

  compartment_id = oci_identity_compartment.home.id
  name           = each.value.name
  description    = each.value.description
  enable_delete  = var.enable_compartment_delete

  timeouts {
    create = "20m"
    update = "20m"
    delete = "90m"
  }
}

resource "oci_identity_compartment" "workload" {
  for_each = local.workload_compartments

  compartment_id = oci_identity_compartment.home.id
  name           = each.value.name
  description    = each.value.description
  enable_delete  = var.enable_compartment_delete

  timeouts {
    create = "20m"
    update = "20m"
    delete = "90m"
  }
}
