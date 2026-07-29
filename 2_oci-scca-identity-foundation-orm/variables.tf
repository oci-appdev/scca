variable "vdms_compartment_ocid" {
  description = "OCID of the VDMS compartment created by Stack 01. The identity domain is placed here."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.", var.vdms_compartment_ocid))
    error_message = "vdms_compartment_ocid must be an OCI compartment OCID."
  }
}

variable "region" {
  description = "OCI home region for the identity domain, for example us-ashburn-1."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "region must look like an OCI region identifier, for example us-ashburn-1."
  }
}

variable "region_key" {
  description = "Short region key used in the domain display name, for example IAD or PHX."
  type        = string
  default     = "IAD"

  validation {
    condition     = can(regex("^[A-Za-z0-9]{2,8}$", var.region_key))
    error_message = "region_key must contain 2-8 alphanumeric characters."
  }
}

variable "resource_label" {
  description = "Short deployment label used in the domain display name, such as PROD, DEV, or MISSION1."
  type        = string
  default     = "PROD"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,20}$", var.resource_label))
    error_message = "resource_label must contain 1-20 letters, digits, dots, underscores, or hyphens."
  }
}

variable "identity_domain_name_prefix" {
  description = "Base name used to construct the identity domain display name."
  type        = string
  default     = "OCI-SCCA-LZ-Domain"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,60}$", var.identity_domain_name_prefix))
    error_message = "identity_domain_name_prefix must contain 1-60 letters, digits, dots, underscores, or hyphens."
  }
}

variable "identity_domain_description" {
  description = "Description assigned to the SCCA identity domain."
  type        = string
  default     = "SCCA mission-owner identity domain for federated human access through on-premises AD and AD FS."

  validation {
    condition     = length(trimspace(var.identity_domain_description)) >= 10 && length(var.identity_domain_description) <= 400
    error_message = "identity_domain_description must contain 10-400 characters."
  }
}

variable "identity_domain_license_type" {
  description = "Identity domain license. Free is the recommended default for inbound AD synchronization and federated OCI control-plane access; Premium is metered."
  type        = string
  default     = "free"

  validation {
    condition     = contains(["free", "premium"], lower(var.identity_domain_license_type))
    error_message = "identity_domain_license_type must be free or premium."
  }
}

variable "group_provisioning_mode" {
  description = "AD_SYNC preserves on-prem AD as the authority and creates no OCI-native groups. OCI_NATIVE creates the catalog as cloud-owned groups for isolated labs only."
  type        = string
  default     = "AD_SYNC"

  validation {
    condition     = contains(["AD_SYNC", "OCI_NATIVE"], upper(var.group_provisioning_mode))
    error_message = "group_provisioning_mode must be AD_SYNC or OCI_NATIVE."
  }
}

variable "workload_identifiers" {
  description = "Workload identifiers used to generate <identifier>-Workload-Admins groups."
  type        = list(string)
  default     = ["SWR1", "SWR2"]

  validation {
    condition = (
      length(var.workload_identifiers) == length(toset([for value in var.workload_identifiers : lower(value)])) &&
      alltrue([for value in var.workload_identifiers : can(regex("^[A-Za-z0-9._-]{1,32}$", value))])
    )
    error_message = "workload_identifiers must be case-insensitively unique and contain only letters, digits, dots, underscores, or hyphens."
  }
}

variable "additional_group_names" {
  description = "Optional extra human group names. In AD_SYNC mode, add matching groups to the AD manifest/process before synchronization."
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.additional_group_names) == length(toset([for value in var.additional_group_names : lower(value)])) &&
      alltrue([for value in var.additional_group_names : can(regex("^[A-Za-z0-9][A-Za-z0-9 ._()-]{0,99}$", value))])
    )
    error_message = "additional_group_names must be case-insensitively unique, 1-100 characters, and use supported display-name characters."
  }
}
