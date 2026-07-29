output "policy_count" {
  description = "Total number of OCI IAM policy resources created by this stack."
  value = tostring(
    length(oci_identity_policy.tenancy) +
    length(oci_identity_policy.home) +
    length(oci_identity_policy.workload_admin) +
    length(oci_identity_policy.functional_workload)
  )
}

output "policy_ocids_json" {
  description = "JSON map of logical policy keys to policy OCIDs."
  value = jsonencode(merge(
    { for key, policy in oci_identity_policy.tenancy : "tenancy/${key}" => policy.id },
    { for key, policy in oci_identity_policy.home : "home/${key}" => policy.id },
    { for key, policy in oci_identity_policy.workload_admin : "workload-admin/${key}" => policy.id },
    { for key, policy in oci_identity_policy.functional_workload : "functional/${key}" => policy.id }
  ))
}

output "generated_policy_statements_json" {
  description = "Complete JSON policy statement inventory for security review and ATO evidence."
  value = jsonencode({
    tenancy = var.enable_tenancy_scope_policies ? {
      for key, policy in local.tenancy_policies : key => policy.statements
    } : {}
    home = {
      for key, policy in local.fixed_home_policies : key => policy.statements
    }
    workload_admin = {
      for key, policy in local.workload_admin_policies : key => policy.statements
    }
    functional_workload = {
      for key, policy in local.functional_policies : key => policy.statements
    }
  })
}

output "workload_admin_scope_json" {
  description = "JSON map showing the exact workload compartment assigned to each workload-admin group."
  value = jsonencode({
    for workload_key, compartment_ocid in local.workload_compartment_ocids :
    "${workload_key}-Workload-Admins" => compartment_ocid
  })
}

output "functional_workload_assignments_json" {
  description = "JSON map of functional group profiles to their explicitly assigned workload keys."
  value       = jsonencode(local.functional_assignments)
}

output "groups_without_generated_policy_json" {
  description = "Groups intentionally receiving no OCI policy from this run. Absence of an allow policy is the least-privilege default."
  value       = jsonencode(sort(local.groups_without_generated_policy))
}

output "tenancy_scope_policies_enabled" {
  description = "Whether the narrowly scoped Resource Manager, FinOps, and Cloud Guard discovery root policies were created."
  value       = tostring(var.enable_tenancy_scope_policies)
}

output "orm_compartment_ocid" {
  description = "Exact compartment where ORM-Deployment-Admins can operate stacks and PLAN/APPLY jobs."
  value       = local.effective_orm_compartment_ocid
}
