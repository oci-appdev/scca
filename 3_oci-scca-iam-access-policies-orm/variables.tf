variable "tenancy_ocid" {
  description = "Tenancy OCID. Used only to place three narrowly scoped policies for Resource Manager, FinOps, and read-only Cloud Guard configuration discovery."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.", var.tenancy_ocid))
    error_message = "tenancy_ocid must be an OCI tenancy OCID."
  }
}

variable "home_compartment_ocid" {
  description = "SCCA home compartment OCID from Stack 01. Compartment policies are stored here and inherited by its children."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.", var.home_compartment_ocid))
    error_message = "home_compartment_ocid must be an OCI compartment OCID."
  }
}

variable "vdms_compartment_ocid" {
  description = "VDMS compartment OCID from Stack 01."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.", var.vdms_compartment_ocid))
    error_message = "vdms_compartment_ocid must be an OCI compartment OCID."
  }
}

variable "vdss_compartment_ocid" {
  description = "VDSS compartment OCID from Stack 01."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.", var.vdss_compartment_ocid))
    error_message = "vdss_compartment_ocid must be an OCI compartment OCID."
  }
}

variable "orm_compartment_ocid" {
  description = "Compartment containing the SCCA Resource Manager stacks. Leave blank to use the SCCA home compartment."
  type        = string
  default     = ""

  validation {
    condition = (
      trimspace(var.orm_compartment_ocid) == "" ||
      can(regex("^ocid1\\.compartment\\.", var.orm_compartment_ocid))
    )
    error_message = "orm_compartment_ocid must be blank or an OCI compartment OCID."
  }
}

variable "workload_compartment_ocids_json" {
  description = "JSON map copied from Stack 01 workload_compartment_ocids_json, for example {\"SWR1\":\"ocid1.compartment...\"}."
  type        = string
  default     = "{}"

  validation {
    condition     = can(tomap(jsondecode(var.workload_compartment_ocids_json)))
    error_message = "workload_compartment_ocids_json must be a JSON object that maps workload keys to compartment OCIDs."
  }

  validation {
    condition = can(alltrue([
      for key, value in tomap(jsondecode(var.workload_compartment_ocids_json)) :
      can(regex("^[A-Za-z0-9._-]{1,32}$", trimspace(key))) &&
      can(regex("^ocid1\\.compartment\\.", trimspace(value)))
    ]))
    error_message = "Every workload key must use supported characters and every value must be an OCI compartment OCID."
  }

  validation {
    condition = can(
      length(keys(tomap(jsondecode(var.workload_compartment_ocids_json)))) ==
      length(toset([for key in keys(tomap(jsondecode(var.workload_compartment_ocids_json))) : upper(trimspace(key))]))
    )
    error_message = "Workload keys must be unique without regard to case."
  }
}

variable "region" {
  description = "OCI region used by the Resource Manager provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "region must look like an OCI region identifier, for example us-ashburn-1."
  }
}

variable "region_key" {
  description = "Short region key used in policy names, for example IAD or PHX."
  type        = string
  default     = "IAD"

  validation {
    condition     = can(regex("^[A-Za-z0-9]{2,8}$", var.region_key))
    error_message = "region_key must contain 2-8 alphanumeric characters."
  }
}

variable "resource_label" {
  description = "Short deployment label used in policy names, such as PROD, DEV, or MISSION1."
  type        = string
  default     = "PROD"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,20}$", var.resource_label))
    error_message = "resource_label must contain 1-20 letters, digits, dots, underscores, or hyphens."
  }
}

variable "policy_name_prefix" {
  description = "Prefix applied to every IAM policy name."
  type        = string
  default     = "OCI-SCCA-LZ-IAM"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,40}$", var.policy_name_prefix))
    error_message = "policy_name_prefix must contain 1-40 supported characters."
  }
}

variable "identity_domain_display_name" {
  description = "Identity domain display name output by Stack 02, used as the policy principal prefix."
  type        = string
  default     = "OCI-SCCA-LZ-Domain-IAD-PROD"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,100}$", var.identity_domain_display_name))
    error_message = "identity_domain_display_name must contain 1-100 supported characters and no slash."
  }
}

variable "enable_tenancy_scope_policies" {
  description = "Creates narrowly scoped root policies for ORM plan/apply, read-only FinOps, and read-only Cloud Guard configuration discovery. Disable only if those statements will be installed through a separate root-policy change process."
  type        = bool
  default     = true
}

variable "cloudops_workload_keys" {
  description = "Workload keys where CLOUDOPS receives day-to-day infrastructure administration. Empty means no workload access."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.cloudops_workload_keys) == length(toset([for value in var.cloudops_workload_keys : upper(trimspace(value))]))
    error_message = "cloudops_workload_keys must be unique without regard to case."
  }
}

variable "appdev_workload_keys" {
  description = "Workload keys where APPDEV receives use/read access. Empty means no workload access."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.appdev_workload_keys) == length(toset([for value in var.appdev_workload_keys : upper(trimspace(value))]))
    error_message = "appdev_workload_keys must be unique without regard to case."
  }
}

variable "devops_workload_keys" {
  description = "Workload keys where DEVOPS receives delivery-platform administration. Empty means no workload access."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.devops_workload_keys) == length(toset([for value in var.devops_workload_keys : upper(trimspace(value))]))
    error_message = "devops_workload_keys must be unique without regard to case."
  }
}

variable "database_admin_workload_keys" {
  description = "Workload keys where Database-Admins receives database-family administration. Empty means no workload access."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.database_admin_workload_keys) == length(toset([for value in var.database_admin_workload_keys : upper(trimspace(value))]))
    error_message = "database_admin_workload_keys must be unique without regard to case."
  }
}

variable "storage_admin_workload_keys" {
  description = "Workload keys where Storage-Admins receives volume, file, and object storage administration. Empty means no workload access."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.storage_admin_workload_keys) == length(toset([for value in var.storage_admin_workload_keys : upper(trimspace(value))]))
    error_message = "storage_admin_workload_keys must be unique without regard to case."
  }
}

variable "backup_admin_workload_keys" {
  description = "Workload keys where Backup-Admins receives block and boot volume backup and backup-policy administration. Empty means no workload access."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.backup_admin_workload_keys) == length(toset([for value in var.backup_admin_workload_keys : upper(trimspace(value))]))
    error_message = "backup_admin_workload_keys must be unique without regard to case."
  }
}
