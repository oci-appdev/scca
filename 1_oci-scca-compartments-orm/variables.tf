variable "tenancy_ocid" {
  type        = string
  description = "OCID of the OCI tenancy (the tenancy is also the root compartment)."

  validation {
    condition     = can(regex("^ocid1\\.tenancy\\.", trimspace(var.tenancy_ocid)))
    error_message = "tenancy_ocid must be a valid OCI tenancy OCID."
  }
}

variable "parent_compartment_ocid" {
  type        = string
  description = "Optional existing parent for the SCCA home compartment. Leave blank to create it directly under the tenancy root."
  default     = ""

  validation {
    condition = (
      trimspace(var.parent_compartment_ocid) == "" ||
      can(regex("^ocid1\\.(tenancy|compartment)\\.", trimspace(var.parent_compartment_ocid)))
    )
    error_message = "parent_compartment_ocid must be blank or a valid tenancy/compartment OCID."
  }
}

variable "region" {
  type        = string
  description = "OCI region used by Resource Manager and the OCI provider, for example us-ashburn-1. Compartments themselves are tenancy-scoped."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z0-9-]+-[0-9]+$", trimspace(var.region)))
    error_message = "region must look like a valid OCI region identifier, for example us-ashburn-1."
  }
}

variable "region_key" {
  type        = string
  description = "Short OCI region key used only in compartment names, for example IAD or PHX."
  default     = "IAD"

  validation {
    condition     = can(regex("^[A-Za-z0-9]{2,8}$", trimspace(var.region_key)))
    error_message = "region_key must contain 2-8 letters or numbers."
  }
}

variable "resource_label" {
  type        = string
  description = "Short deployment label appended to SCCA core compartment names, for example PROD, DEV, or MISSION1."
  default     = "PROD"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,20}$", trimspace(var.resource_label)))
    error_message = "resource_label must contain 1-20 letters, numbers, periods, hyphens, or underscores."
  }
}

variable "home_compartment_name" {
  type        = string
  description = "Base name of the top-level SCCA home/EBLZ parent compartment."
  default     = "OCI-SCCA-LZ-Home"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,70}$", trimspace(var.home_compartment_name)))
    error_message = "home_compartment_name must contain 1-70 supported OCI name characters."
  }
}

variable "vdms_compartment_name" {
  type        = string
  description = "Base name of the Virtual Datacenter Management Stack compartment."
  default     = "OCI-SCCA-LZ-VDMS"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,70}$", trimspace(var.vdms_compartment_name)))
    error_message = "vdms_compartment_name must contain 1-70 supported OCI name characters."
  }
}

variable "vdss_compartment_name" {
  type        = string
  description = "Base name of the Virtual Datacenter Security Stack compartment."
  default     = "OCI-SCCA-LZ-VDSS"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,70}$", trimspace(var.vdss_compartment_name)))
    error_message = "vdss_compartment_name must contain 1-70 supported OCI name characters."
  }
}

variable "enable_logging_compartment" {
  type        = bool
  description = "Create the SCCA Logging child compartment."
  default     = true
}

variable "logging_compartment_name" {
  type        = string
  description = "Base name of the optional SCCA Logging compartment."
  default     = "OCI-SCCA-LZ-Logging"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,70}$", trimspace(var.logging_compartment_name)))
    error_message = "logging_compartment_name must contain 1-70 supported OCI name characters."
  }
}

variable "enable_backup_compartment" {
  type        = bool
  description = "Create the SCCA Terraform configuration-backup child compartment. No bucket or other backup resource is created."
  default     = true
}

variable "backup_compartment_name" {
  type        = string
  description = "Base name of the optional SCCA Terraform configuration-backup compartment."
  default     = "OCI-SCCA-LZ-IAC-TF-Configbackup"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,70}$", trimspace(var.backup_compartment_name)))
    error_message = "backup_compartment_name must contain 1-70 supported OCI name characters."
  }
}

variable "workload_compartment_name_prefix" {
  type        = string
  description = "Prefix used for each SCCA workload compartment."
  default     = "OCI-SCCA-LZ-WRK"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,70}$", trimspace(var.workload_compartment_name_prefix)))
    error_message = "workload_compartment_name_prefix must contain 1-70 supported OCI name characters."
  }
}

variable "workload_postfixes" {
  type        = list(string)
  description = "One unique short identifier per workload compartment, for example [\"SWR1\", \"SWR2\"]. Use an empty list to create none."
  default     = ["SWR1"]

  validation {
    condition = alltrue([
      for postfix in var.workload_postfixes :
      can(regex("^[A-Za-z0-9._-]{1,32}$", trimspace(postfix)))
    ])
    error_message = "Each workload postfix must contain 1-32 letters, numbers, periods, hyphens, or underscores."
  }

  validation {
    condition = length(var.workload_postfixes) == length(distinct([
      for postfix in var.workload_postfixes : upper(trimspace(postfix))
    ]))
    error_message = "workload_postfixes must be unique after trimming and case normalization."
  }
}

variable "enable_compartment_delete" {
  type        = bool
  description = "DANGEROUS: allow Terraform destroy/removal to delete empty compartments. Keep false for normal use."
  default     = false
}
