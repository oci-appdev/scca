locals {
  identity_domain_display_name = join("-", [
    var.identity_domain_name_prefix,
    upper(var.region_key),
    upper(var.resource_label)
  ])

  core_human_groups = {
    "VDMS-Platform-Admins" = {
      category       = "management"
      privileged     = true
      responsibility = "Management services and landing-zone operations"
    }
    "VDSS-Security-Admins" = {
      category       = "security"
      privileged     = true
      responsibility = "Security stack, firewall, and inspection services"
    }
    "Network-Admins" = {
      category       = "network"
      privileged     = true
      responsibility = "Network-specific administration"
    }
    "Security-Auditors" = {
      category       = "audit"
      privileged     = false
      responsibility = "Read-only security and compliance visibility"
    }
    "ORM-Deployment-Admins" = {
      category       = "deployment"
      privileged     = true
      responsibility = "Resource Manager stack administration"
    }
    "AD-Admins" = {
      category       = "identity"
      privileged     = true
      responsibility = "On-premises Active Directory, AD FS, and federation administration"
    }
    "ENTOPS" = {
      category       = "operations"
      privileged     = true
      responsibility = "Enterprise operations and shared-service coordination"
    }
    "CLOUDOPS" = {
      category       = "operations"
      privileged     = true
      responsibility = "Day-to-day OCI cloud operations"
    }
    "SECOPS" = {
      category       = "security"
      privileged     = true
      responsibility = "Security monitoring, triage, and response operations"
    }
    "APPDEV" = {
      category       = "development"
      privileged     = false
      responsibility = "Application development activities"
    }
    "DEVOPS" = {
      category       = "development"
      privileged     = true
      responsibility = "CI/CD, automation, and deployment engineering"
    }
    "Database-Admins" = {
      category       = "database"
      privileged     = true
      responsibility = "Database platform administration"
    }
    "Storage-Admins" = {
      category       = "storage"
      privileged     = true
      responsibility = "Block, file, and object storage administration"
    }
    "Backup-Admins" = {
      category       = "continuity"
      privileged     = true
      responsibility = "Backup configuration and recovery operations"
    }
    "Helpdesk-Operators" = {
      category       = "support"
      privileged     = false
      responsibility = "Tier-one user support and approved support workflows"
    }
    "Incident-Responders" = {
      category       = "security"
      privileged     = true
      responsibility = "Cybersecurity incident investigation and response"
    }
    "Compliance-Auditors" = {
      category       = "audit"
      privileged     = false
      responsibility = "Read-only compliance evidence and control assessment"
    }
    "FinOps-Analysts" = {
      category       = "financial"
      privileged     = false
      responsibility = "Cloud cost reporting, forecasting, and optimization analysis"
    }
  }

  workload_human_groups = {
    for workload in var.workload_identifiers :
    "${upper(workload)}-Workload-Admins" => {
      category       = "workload"
      privileged     = true
      responsibility = "Administration of workload ${upper(workload)} only"
    }
  }

  additional_human_groups = {
    for group_name in var.additional_group_names :
    group_name => {
      category       = "custom"
      privileged     = false
      responsibility = "Custom human group; define least-privilege access in a later policy stack"
    }
  }

  group_name_candidates            = concat(keys(local.core_human_groups), keys(local.workload_human_groups), var.additional_group_names)
  normalized_group_name_candidates = [for group_name in local.group_name_candidates : lower(group_name)]
  group_names_are_unique            = length(local.normalized_group_name_candidates) == length(toset(local.normalized_group_name_candidates))

  human_groups = merge(
    local.core_human_groups,
    local.workload_human_groups,
    local.additional_human_groups
  )

  human_group_catalog = {
    for group_name, group in local.human_groups :
    group_name => merge(group, {
      display_name        = group_name
      source_of_authority = upper(var.group_provisioning_mode) == "AD_SYNC" ? "ON_PREM_ACTIVE_DIRECTORY" : "OCI_IDENTITY_DOMAIN"
      policy_status       = "NOT_CREATED_BY_THIS_STACK"
    })
  }
}
