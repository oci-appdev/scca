output "home_compartment_ocid" {
  description = "OCID of the SCCA home / EBLZ parent compartment."
  value       = oci_identity_compartment.home.id
}

output "home_compartment_name" {
  description = "Rendered name of the SCCA home / EBLZ parent compartment."
  value       = oci_identity_compartment.home.name
}

output "vdms_compartment_ocid" {
  description = "OCID of the SCCA VDMS compartment."
  value       = oci_identity_compartment.core["vdms"].id
}

output "vdss_compartment_ocid" {
  description = "OCID of the SCCA VDSS compartment."
  value       = oci_identity_compartment.core["vdss"].id
}

output "logging_compartment_ocid" {
  description = "OCID of the optional SCCA Logging compartment, or null when disabled."
  value       = try(oci_identity_compartment.core["logging"].id, null)
}

output "backup_compartment_ocid" {
  description = "OCID of the optional SCCA Terraform configuration-backup compartment, or null when disabled."
  value       = try(oci_identity_compartment.core["backup"].id, null)
}

output "workload_compartment_ocids" {
  description = "Map of normalized workload postfixes to compartment OCIDs."
  value = {
    for key, compartment in oci_identity_compartment.workload :
    key => compartment.id
  }
}

output "workload_compartment_ocids_json" {
  description = "Copyable JSON map of normalized workload postfixes to compartment OCIDs."
  value = jsonencode({
    for key, compartment in oci_identity_compartment.workload :
    key => compartment.id
  })
}

output "compartment_hierarchy" {
  description = "Rendered compartment-only hierarchy created by this stack."
  value = {
    parent_ocid = local.effective_parent_ocid
    home = {
      name = oci_identity_compartment.home.name
      ocid = oci_identity_compartment.home.id
    }
    core = {
      for key, compartment in oci_identity_compartment.core : key => {
        name = compartment.name
        ocid = compartment.id
      }
    }
    workloads = {
      for key, compartment in oci_identity_compartment.workload : key => {
        name = compartment.name
        ocid = compartment.id
      }
    }
  }
}
