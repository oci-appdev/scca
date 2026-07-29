variable "region" {
  description = "OCI region used by Resource Manager for provider operations."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "region must look like an OCI region identifier, for example us-ashburn-1."
  }
}

variable "identity_domain_url" {
  description = "Identity domain URL from Stack 02 output identity_domain_url."
  type        = string

  validation {
    condition = (
      can(regex("^https://[A-Za-z0-9.-]+(:[0-9]+)?(/.*)?$", trimspace(var.identity_domain_url))) &&
      !can(regex("[?#]", var.identity_domain_url))
    )
    error_message = "identity_domain_url must be an HTTPS identity-domain URL without a query string or fragment."
  }
}

variable "identity_domain_display_name" {
  description = "Identity domain display name from Stack 02, used in descriptions and review outputs."
  type        = string

  validation {
    condition     = length(trimspace(var.identity_domain_display_name)) >= 3 && length(var.identity_domain_display_name) <= 100
    error_message = "identity_domain_display_name must contain 3-100 characters."
  }
}

variable "group_provisioning_mode" {
  description = "Stack 02 group provisioning mode. Production federation requires AD_SYNC so AD remains authoritative."
  type        = string
  default     = "AD_SYNC"

  validation {
    condition     = upper(var.group_provisioning_mode) == "AD_SYNC"
    error_message = "Stack 04 requires group_provisioning_mode=AD_SYNC. JIT and OCI-native shadow identities are intentionally not supported."
  }
}

variable "adfs_partner_name" {
  description = "Stable name for the AD FS SAML identity provider in OCI."
  type        = string
  default     = "OCI-SCCA-ADFS"

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9 ._()-]{2,99}$", var.adfs_partner_name))
    error_message = "adfs_partner_name must contain 3-100 supported characters."
  }
}

variable "identity_provider_description" {
  description = "Description recorded on the OCI SAML identity provider."
  type        = string
  default     = "Enterprise AD FS federation for the SCCA mission-owner identity domain. Users and groups are provisioned by AD synchronization; JIT is disabled."

  validation {
    condition     = length(trimspace(var.identity_provider_description)) >= 20 && length(var.identity_provider_description) <= 400
    error_message = "identity_provider_description must contain 20-400 characters."
  }
}

variable "adfs_metadata_xml_base64" {
  description = "Base64-encoded AD FS FederationMetadata.xml. Export it from the approved AD FS farm; never place passwords, tokens, or private keys here."
  type        = string
  sensitive   = true

  validation {
    condition = (
      can(base64decode(var.adfs_metadata_xml_base64)) &&
      can(regex("(?s)<(?:[A-Za-z0-9_-]+:)?EntityDescriptor\\b", try(base64decode(var.adfs_metadata_xml_base64), ""))) &&
      can(regex("(?s)<(?:[A-Za-z0-9_-]+:)?IDPSSODescriptor\\b", try(base64decode(var.adfs_metadata_xml_base64), ""))) &&
      can(regex("(?s)<(?:[A-Za-z0-9_-]+:)?X509Certificate\\b", try(base64decode(var.adfs_metadata_xml_base64), ""))) &&
      length(try(base64decode(var.adfs_metadata_xml_base64), "")) <= 1048576
    )
    error_message = "adfs_metadata_xml_base64 must decode to AD FS SAML metadata containing EntityDescriptor, IDPSSODescriptor, and X509Certificate, and must not exceed 1 MiB."
  }
}

variable "require_encrypted_assertions" {
  description = "Require AD FS to encrypt SAML assertions for OCI. Keep true unless an approved interoperability exception exists."
  type        = bool
  default     = true
}

variable "require_force_authentication" {
  description = "Ask AD FS to reauthenticate for every OCI sign-in. Enable only if the enterprise AD FS session design requires it."
  type        = bool
  default     = false
}

variable "activate_adfs_idp" {
  description = "Activation gate. Leave false for the first apply; set true only after AD FS configuration and two local break-glass tests succeed."
  type        = bool
  default     = false
}

variable "publish_adfs_on_login_page" {
  description = "Publication gate. Leave false until hidden IdP testing and the OCI IdP-policy assignment succeed."
  type        = bool
  default     = false
}

variable "break_glass_account_count" {
  description = "Number of tested cloud-local break-glass accounts. This is an attestation only; the stack does not create or manage those accounts."
  type        = number
  default     = 0

  validation {
    condition     = var.break_glass_account_count >= 0 && var.break_glass_account_count <= 10 && floor(var.break_glass_account_count) == var.break_glass_account_count
    error_message = "break_glass_account_count must be a whole number from 0 through 10."
  }
}

variable "break_glass_last_test_date" {
  description = "UTC date (YYYY-MM-DD) when both local break-glass accounts were last tested. Do not enter user names or secrets."
  type        = string
  default     = ""

  validation {
    condition     = var.break_glass_last_test_date == "" || can(regex("^20[0-9]{2}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])$", var.break_glass_last_test_date))
    error_message = "break_glass_last_test_date must be empty or use YYYY-MM-DD."
  }
}

variable "break_glass_verification_confirmation" {
  description = "Activation acknowledgement. Enter the exact phrase documented in the runbook only after both accounts are tested."
  type        = string
  default     = ""
}

variable "activation_change_ticket" {
  description = "Approved change/control ticket authorizing IdP activation. Required when activate_adfs_idp=true."
  type        = string
  default     = ""

  validation {
    condition     = var.activation_change_ticket == "" || can(regex("^[A-Za-z0-9][A-Za-z0-9._:/-]{2,79}$", var.activation_change_ticket))
    error_message = "activation_change_ticket must contain 3-80 supported characters and no spaces."
  }
}

variable "activation_confirmation" {
  description = "Activation acknowledgement. Enter the exact phrase documented in the runbook only after federation tests are ready."
  type        = string
  default     = ""
}

variable "publication_confirmation" {
  description = "Publication acknowledgement. Enter the exact phrase only after hidden-login, IdP-policy, and break-glass tests pass."
  type        = string
  default     = ""
}
