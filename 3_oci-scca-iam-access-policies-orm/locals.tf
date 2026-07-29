locals {
  normalized_region_key = upper(trimspace(var.region_key))
  normalized_label      = upper(trimspace(var.resource_label))
  effective_orm_compartment_ocid = (
    trimspace(var.orm_compartment_ocid) != "" ?
    trimspace(var.orm_compartment_ocid) :
    var.home_compartment_ocid
  )

  domain_groups = {
    vdms_platform       = "VDMS-Platform-Admins"
    vdss_security       = "VDSS-Security-Admins"
    network             = "Network-Admins"
    security_auditors   = "Security-Auditors"
    orm                 = "ORM-Deployment-Admins"
    ad_admins           = "AD-Admins"
    entops              = "ENTOPS"
    cloudops            = "CLOUDOPS"
    secops              = "SECOPS"
    appdev              = "APPDEV"
    devops              = "DEVOPS"
    database_admins     = "Database-Admins"
    storage_admins      = "Storage-Admins"
    backup_admins       = "Backup-Admins"
    helpdesk            = "Helpdesk-Operators"
    incident_responders = "Incident-Responders"
    compliance_auditors = "Compliance-Auditors"
    finops              = "FinOps-Analysts"
  }

  principals = {
    for key, group_name in local.domain_groups :
    key => "${var.identity_domain_display_name}/${group_name}"
  }

  workload_compartment_ocids = {
    for key, value in tomap(jsondecode(var.workload_compartment_ocids_json)) :
    upper(trimspace(key)) => trimspace(value)
  }

  functional_assignments = {
    cloudops        = [for key in var.cloudops_workload_keys : upper(trimspace(key))]
    appdev          = [for key in var.appdev_workload_keys : upper(trimspace(key))]
    devops          = [for key in var.devops_workload_keys : upper(trimspace(key))]
    database_admins = [for key in var.database_admin_workload_keys : upper(trimspace(key))]
    storage_admins  = [for key in var.storage_admin_workload_keys : upper(trimspace(key))]
    backup_admins   = [for key in var.backup_admin_workload_keys : upper(trimspace(key))]
  }

  assigned_functional_workload_keys = flatten(values(local.functional_assignments))
  invalid_functional_workload_keys = sort(tolist(setsubtract(
    toset(local.assigned_functional_workload_keys),
    toset(keys(local.workload_compartment_ocids))
  )))

  tenancy_policies = {
    orm_deployment = {
      name        = "${var.policy_name_prefix}-ORM-${local.normalized_region_key}-${local.normalized_label}"
      description = "SCCA Resource Manager plan/apply administration without destroy or IAM policy administration"
      statements = [
        "Allow group ${local.principals.orm} to use orm-stacks in compartment id ${local.effective_orm_compartment_ocid}",
        "Allow group ${local.principals.orm} to read orm-jobs in compartment id ${local.effective_orm_compartment_ocid}",
        "Allow group ${local.principals.orm} to manage orm-jobs in compartment id ${local.effective_orm_compartment_ocid} where any {target.job.operation = 'PLAN', target.job.operation = 'APPLY'}",
        "Allow group ${local.principals.orm} to inspect compartments in tenancy",
        "Allow group ${local.principals.orm} to inspect tenancies in tenancy"
      ]
    }
    finops_read_only = {
      name        = "${var.policy_name_prefix}-FINOPS-${local.normalized_region_key}-${local.normalized_label}"
      description = "Read-only cost analysis and budget visibility for the SCCA FinOps analysts"
      statements = [
        "Allow group ${local.principals.finops} to read usage-report in tenancy",
        "Allow group ${local.principals.finops} to read usage-budgets in tenancy",
        "Allow group ${local.principals.finops} to inspect compartments in tenancy"
      ]
    }
    security_service_discovery = {
      name        = "${var.policy_name_prefix}-SEC-DISCOVERY-${local.normalized_region_key}-${local.normalized_label}"
      description = "Read-only tenancy configuration discovery for Cloud Guard security roles"
      statements = [
        "Allow group ${local.principals.vdss_security} to read cloud-guard-config in tenancy",
        "Allow group ${local.principals.security_auditors} to read cloud-guard-config in tenancy",
        "Allow group ${local.principals.secops} to read cloud-guard-config in tenancy",
        "Allow group ${local.principals.incident_responders} to read cloud-guard-config in tenancy"
      ]
    }
  }

  fixed_home_policies = {
    vdms_platform = {
      name        = "${var.policy_name_prefix}-VDMS-${local.normalized_region_key}-${local.normalized_label}"
      description = "VDMS platform services administration without all-resources, IAM, or workload administration"
      statements = [
        "Allow group ${local.principals.vdms_platform} to manage bastion-family in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to manage alarms in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to read metrics in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to manage ons-family in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to manage cloudevents-rules in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to manage vss-family in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to manage logging-family in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to read instance-family in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to read instance-agent-plugins in compartment id ${var.vdms_compartment_ocid}",
        "Allow group ${local.principals.vdms_platform} to inspect work-requests in compartment id ${var.vdms_compartment_ocid}"
      ]
    }
    vdss_security = {
      name        = "${var.policy_name_prefix}-VDSS-${local.normalized_region_key}-${local.normalized_label}"
      description = "VDSS firewall, inspection, WAF, and security-service administration"
      statements = [
        "Allow group ${local.principals.vdss_security} to manage cloud-guard-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to manage network-firewall-family in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to manage waf-family in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to use virtual-network-family in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to manage load-balancers in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to manage network-load-balancers in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to manage logging-family in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to manage alarms in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to read metrics in compartment id ${var.vdss_compartment_ocid}",
        "Allow group ${local.principals.vdss_security} to use ons-topics in compartment id ${var.vdss_compartment_ocid}"
      ]
    }
    network_admins = {
      name        = "${var.policy_name_prefix}-NETWORK-${local.normalized_region_key}-${local.normalized_label}"
      description = "Network and DNS administration across only the SCCA home compartment tree"
      statements = [
        "Allow group ${local.principals.network} to manage virtual-network-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.network} to manage dns in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.network} to read instance-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.network} to read load-balancers in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.network} to read network-load-balancers in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.network} to inspect work-requests in compartment id ${var.home_compartment_ocid}"
      ]
    }
    security_auditors = {
      name        = "${var.policy_name_prefix}-SEC-AUDIT-${local.normalized_region_key}-${local.normalized_label}"
      description = "Read-only security evidence and security-service visibility"
      statements = [
        "Allow group ${local.principals.security_auditors} to inspect all-resources in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.security_auditors} to read cloud-guard-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.security_auditors} to read logging-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.security_auditors} to read audit-events in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.security_auditors} to read vss-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.security_auditors} to read threat-intel-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.security_auditors} to inspect policies in compartment id ${var.home_compartment_ocid}"
      ]
    }
    ad_admins = {
      name        = "${var.policy_name_prefix}-AD-FEDERATION-${local.normalized_region_key}-${local.normalized_label}"
      description = "Identity-domain visibility without OCI resource or identity-provider mutation"
      statements = [
        "Allow group ${local.principals.ad_admins} to read domains in compartment id ${var.vdms_compartment_ocid}"
      ]
    }
    entops = {
      name        = "${var.policy_name_prefix}-ENTOPS-${local.normalized_region_key}-${local.normalized_label}"
      description = "Enterprise operations visibility and monitoring without resource mutation"
      statements = [
        "Allow group ${local.principals.entops} to inspect all-resources in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.entops} to read metrics in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.entops} to read alarms in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.entops} to read ons-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.entops} to read cloudevents-rules in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.entops} to inspect work-requests in compartment id ${var.home_compartment_ocid}"
      ]
    }
    secops = {
      name        = "${var.policy_name_prefix}-SECOPS-${local.normalized_region_key}-${local.normalized_label}"
      description = "Security operations monitoring and controlled Cloud Guard response execution"
      statements = [
        "Allow group ${local.principals.secops} to read cloud-guard-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.secops} to use cloud-guard-responder-executions in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.secops} to read logging-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.secops} to read audit-events in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.secops} to read vss-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.secops} to read threat-intel-family in compartment id ${var.home_compartment_ocid}"
      ]
    }
    incident_responders = {
      name        = "${var.policy_name_prefix}-INCIDENT-${local.normalized_region_key}-${local.normalized_label}"
      description = "Incident investigation visibility and execution of approved Cloud Guard responders"
      statements = [
        "Allow group ${local.principals.incident_responders} to read cloud-guard-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.incident_responders} to use cloud-guard-responder-executions in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.incident_responders} to read logging-family in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.incident_responders} to read audit-events in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.incident_responders} to read vss-family in compartment id ${var.home_compartment_ocid}"
      ]
    }
    compliance_auditors = {
      name        = "${var.policy_name_prefix}-COMPLIANCE-${local.normalized_region_key}-${local.normalized_label}"
      description = "Read-only compliance inventory, audit events, logging configuration, policies, and tags"
      statements = [
        "Allow group ${local.principals.compliance_auditors} to inspect all-resources in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.compliance_auditors} to read audit-events in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.compliance_auditors} to inspect policies in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.compliance_auditors} to read log-groups in compartment id ${var.home_compartment_ocid}",
        "Allow group ${local.principals.compliance_auditors} to inspect tag-namespaces in compartment id ${var.home_compartment_ocid}"
      ]
    }
  }

  workload_admin_policies = {
    for workload_key, compartment_ocid in local.workload_compartment_ocids :
    workload_key => {
      name        = "${var.policy_name_prefix}-${workload_key}-ADMIN-${local.normalized_region_key}-${local.normalized_label}"
      description = "Administration of workload ${workload_key} only, without IAM, network ownership, keys, secrets, or all-resources"
      group_name  = "${workload_key}-Workload-Admins"
      statements = [
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to manage instance-family in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to manage volume-family in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to manage load-balancers in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to manage network-load-balancers in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to manage file-family in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to manage object-family in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to use virtual-network-family in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to manage alarms in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to read metrics in compartment id ${compartment_ocid}",
        "Allow group ${var.identity_domain_display_name}/${workload_key}-Workload-Admins to use ons-topics in compartment id ${compartment_ocid}"
      ]
    }
  }

  functional_profiles = {
    cloudops = {
      group_name  = local.domain_groups.cloudops
      name_token  = "CLOUDOPS"
      description = "Day-to-day infrastructure administration in one explicitly assigned workload"
      permissions = [
        { verb = "manage", resource = "instance-family" },
        { verb = "manage", resource = "volume-family" },
        { verb = "manage", resource = "load-balancers" },
        { verb = "manage", resource = "network-load-balancers" },
        { verb = "manage", resource = "file-family" },
        { verb = "manage", resource = "object-family" },
        { verb = "use", resource = "virtual-network-family" },
        { verb = "manage", resource = "alarms" },
        { verb = "read", resource = "metrics" }
      ]
    }
    appdev = {
      group_name  = local.domain_groups.appdev
      name_token  = "APPDEV"
      description = "Application runtime use and operational read access in one explicitly assigned workload"
      permissions = [
        { verb = "use", resource = "instance-family" },
        { verb = "read", resource = "object-family" },
        { verb = "read", resource = "logging-family" },
        { verb = "read", resource = "metrics" }
      ]
    }
    devops = {
      group_name  = local.domain_groups.devops
      name_token  = "DEVOPS"
      description = "Delivery platform administration in one explicitly assigned workload"
      permissions = [
        { verb = "manage", resource = "devops-family" },
        { verb = "manage", resource = "functions-family" },
        { verb = "manage", resource = "api-gateway-family" },
        { verb = "manage", resource = "cluster-family" },
        { verb = "use", resource = "virtual-network-family" },
        { verb = "read", resource = "logging-family" },
        { verb = "read", resource = "metrics" }
      ]
    }
    database_admins = {
      group_name  = local.domain_groups.database_admins
      name_token  = "DATABASE"
      description = "Database service administration in one explicitly assigned workload"
      permissions = [
        { verb = "manage", resource = "database-family" },
        { verb = "read", resource = "metrics" }
      ]
    }
    storage_admins = {
      group_name  = local.domain_groups.storage_admins
      name_token  = "STORAGE"
      description = "Block, file, and object storage administration in one explicitly assigned workload"
      permissions = [
        { verb = "manage", resource = "volume-family" },
        { verb = "manage", resource = "file-family" },
        { verb = "manage", resource = "object-family" }
      ]
    }
    backup_admins = {
      group_name  = local.domain_groups.backup_admins
      name_token  = "BACKUP"
      description = "Block and boot volume backup and backup-policy administration in one explicitly assigned workload"
      permissions = [
        { verb = "use", resource = "volumes" },
        { verb = "manage", resource = "volume-backups" },
        { verb = "manage", resource = "boot-volume-backups" },
        { verb = "manage", resource = "backup-policies" },
        { verb = "manage", resource = "backup-policy-assignments" }
      ]
    }
  }

  functional_policy_items = flatten([
    for profile_key, workload_keys in local.functional_assignments : [
      for workload_key in workload_keys : {
        key          = "${profile_key}-${workload_key}"
        profile_key  = profile_key
        workload_key = workload_key
      }
    ]
  ])

  functional_policies = {
    for item in local.functional_policy_items :
    item.key => {
      name = "${var.policy_name_prefix}-${local.functional_profiles[item.profile_key].name_token}-${item.workload_key}-${local.normalized_region_key}-${local.normalized_label}"
      description = (
        "${local.functional_profiles[item.profile_key].description}; scope ${item.workload_key}"
      )
      group_name     = local.functional_profiles[item.profile_key].group_name
      workload_key   = item.workload_key
      compartment_id = local.workload_compartment_ocids[item.workload_key]
      statements = [
        for permission in local.functional_profiles[item.profile_key].permissions :
        "Allow group ${var.identity_domain_display_name}/${local.functional_profiles[item.profile_key].group_name} to ${permission.verb} ${permission.resource} in compartment id ${local.workload_compartment_ocids[item.workload_key]}"
      ]
    }
    if contains(keys(local.workload_compartment_ocids), item.workload_key)
  }

  groups_without_generated_policy = distinct(concat(
    [local.domain_groups.helpdesk],
    var.enable_tenancy_scope_policies ? [] : [local.domain_groups.orm, local.domain_groups.finops],
    [
      for profile_key, workload_keys in local.functional_assignments :
      local.functional_profiles[profile_key].group_name
      if length(workload_keys) == 0
    ]
  ))

  all_rendered_policy_names = concat(
    [for policy in values(local.tenancy_policies) : policy.name],
    [for policy in values(local.fixed_home_policies) : policy.name],
    [for policy in values(local.workload_admin_policies) : policy.name],
    [for policy in values(local.functional_policies) : policy.name]
  )

  home_rendered_policy_statements = flatten(concat(
    [for policy in values(local.fixed_home_policies) : policy.statements],
    [for policy in values(local.workload_admin_policies) : policy.statements],
    [for policy in values(local.functional_policies) : policy.statements]
  ))

  all_rendered_policy_statements = concat(
    flatten([for policy in values(local.tenancy_policies) : policy.statements]),
    local.home_rendered_policy_statements
  )

  forbidden_write_tokens = [
    " to manage all-resources ",
    " to manage policies ",
    " to manage users ",
    " to manage groups ",
    " to manage dynamic-groups ",
    " to manage tenancies ",
    " to manage keys ",
    " to manage secrets ",
    " to manage domains ",
    " to manage authentication-policies "
  ]

  policy_names_are_valid = alltrue([
    for name in local.all_rendered_policy_names :
    length(name) <= 100 && can(regex("^[A-Za-z0-9._-]+$", name))
  ])

  policy_statements_are_valid = alltrue([
    for statement in local.all_rendered_policy_statements :
    length(statement) > 0 && length(statement) <= 500 && startswith(statement, "Allow group ")
  ])

  policy_guardrails_are_satisfied = alltrue([
    for statement in local.all_rendered_policy_statements :
    alltrue([
      for token in local.forbidden_write_tokens :
      !strcontains(lower(statement), token)
    ])
  ])

  home_policy_scopes_are_compartment_bound = alltrue([
    for statement in local.home_rendered_policy_statements :
    strcontains(lower(statement), " in compartment id ")
  ])
}
