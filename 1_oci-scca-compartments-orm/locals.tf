locals {
  effective_parent_ocid = trimspace(var.parent_compartment_ocid) != "" ? trimspace(var.parent_compartment_ocid) : trimspace(var.tenancy_ocid)
  normalized_region_key = upper(trimspace(var.region_key))
  normalized_label      = upper(trimspace(var.resource_label))

  home_compartment = {
    name        = "${trimspace(var.home_compartment_name)}-${local.normalized_region_key}-${local.normalized_label}"
    description = "SCCA landing zone home / EBLZ parent compartment"
  }

  required_core_compartments = {
    vdms = {
      name        = "${trimspace(var.vdms_compartment_name)}-${local.normalized_region_key}-${local.normalized_label}"
      description = "SCCA Virtual Datacenter Management Stack (VDMS) compartment"
    }
    vdss = {
      name        = "${trimspace(var.vdss_compartment_name)}-${local.normalized_region_key}-${local.normalized_label}"
      description = "SCCA Virtual Datacenter Security Stack (VDSS) compartment"
    }
  }

  optional_logging_compartment = var.enable_logging_compartment ? {
    logging = {
      name        = "${trimspace(var.logging_compartment_name)}-${local.normalized_region_key}-${local.normalized_label}"
      description = "SCCA centralized logging compartment"
    }
  } : {}

  # Oracle's SCCAv1 naming omits the region key from this compartment.
  optional_backup_compartment = var.enable_backup_compartment ? {
    backup = {
      name        = "${trimspace(var.backup_compartment_name)}-${local.normalized_label}"
      description = "SCCA Terraform configuration-backup compartment (compartment only)"
    }
  } : {}

  core_compartments = merge(
    local.required_core_compartments,
    local.optional_logging_compartment,
    local.optional_backup_compartment
  )

  workload_compartments = {
    for postfix in var.workload_postfixes : upper(trimspace(postfix)) => {
      name        = "${trimspace(var.workload_compartment_name_prefix)}-${local.normalized_region_key}-${upper(trimspace(postfix))}"
      description = "SCCA workload compartment ${upper(trimspace(postfix))}"
    }
  }

  child_compartment_names = concat(
    [for compartment in values(local.core_compartments) : compartment.name],
    [for compartment in values(local.workload_compartments) : compartment.name]
  )

  all_compartment_names = concat(
    [local.home_compartment.name],
    local.child_compartment_names
  )
}
