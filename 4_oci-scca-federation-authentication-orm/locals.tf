locals {
  identity_domain_endpoint = trimsuffix(trimspace(var.identity_domain_url), "/")
  adfs_metadata_xml        = base64decode(var.adfs_metadata_xml_base64)

  break_glass_ready = (
    var.break_glass_account_count >= 2 &&
    can(regex("^20[0-9]{2}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])$", var.break_glass_last_test_date)) &&
    var.break_glass_verification_confirmation == "I_HAVE_TESTED_TWO_LOCAL_BREAK_GLASS_ACCOUNTS"
  )

  activation_ready = (
    local.break_glass_ready &&
    length(trimspace(var.activation_change_ticket)) >= 3 &&
    var.activation_confirmation == "ACTIVATE_ADFS_IDP_AFTER_SUCCESSFUL_TEST"
  )

  publication_ready = (
    var.activate_adfs_idp &&
    local.activation_ready &&
    var.publication_confirmation == "PUBLISH_ADFS_AFTER_FEDERATION_AND_BREAK_GLASS_TESTS"
  )

  service_provider_metadata_url = "${local.identity_domain_endpoint}/fed/v1/metadata"
  my_profile_url                = "${local.identity_domain_endpoint}/ui/v1/myconsole"
}
