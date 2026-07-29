# Third-Party Reference Notice

This package is an original, narrowly scoped Terraform implementation informed
by Oracle's public OCI SCCA Landing Zone and OCI IAM documentation. It does not
copy or bundle Oracle's complete landing-zone implementation.

Reference project:

- `oci-landing-zones/oci-scca-landingzone`
- Mission Owner SCCA v1 `iam.tf` and the policy module
- <https://github.com/oci-landing-zones/oci-scca-landingzone/tree/master/Mission_Owner_SCCA_(SCCAv1)>

The Oracle reference was used to understand the SCCA group responsibilities and
policy locations. Its broad `manage all-resources` administrator grants were
not carried into this package.

Primary Oracle documentation:

- <https://docs.oracle.com/en-us/iaas/Content/Identity/policieshow/Policy_Inheritance.htm>
- <https://docs.oracle.com/iaas/Content/Identity/policyreference/iampolicyreference.htm>
- <https://docs.oracle.com/en-us/iaas/Content/Security/Reference/resourcemanager_security.htm>
- <https://docs.oracle.com/en-us/iaas/tools/terraform-provider-oci/latest/docs/r/identity_policy.html>
