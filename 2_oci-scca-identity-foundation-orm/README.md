# Stack 02 - SCCA Identity Foundation

This OCI Resource Manager Terraform stack creates only the identity foundation:

- one OCI identity domain in the existing VDMS compartment;
- a defined human-group catalog for later least-privilege IAM policies; and
- optional OCI-native groups for isolated labs.

The production default is `AD_SYNC`. In that mode Terraform creates the domain
but deliberately does **not** create human groups in OCI. The matching groups
must be created in on-premises Active Directory and synchronized into the
domain with the Microsoft Active Directory Bridge. This prevents Terraform and
AD from competing to own groups with the same names.

## What this stack does not create

This stack creates no IAM policies, users, group memberships, dynamic groups,
API keys, auth tokens, customer secrets, AD Bridge agents, AD FS federation,
identity-provider configuration, sign-on policies, or MFA rules. Those belong
in later controlled deployment steps.

## Authentication and synchronization model

AD FS and AD Bridge perform different jobs:

- **AD FS** authenticates the human and carries the federated sign-in to OCI.
- **AD Bridge** synchronizes approved users and groups from on-prem AD into the
  OCI identity domain.

For this environment, on-prem AD remains authoritative. After deploying this
stack, configure the bridge for inbound synchronization and leave these
"Supported Operations" disabled:

- Activate or deactivate users in AD;
- Update user attributes in AD; and
- Update groups in AD.

Enable federated authentication for synchronized users. Configure AD FS as the
identity provider in the later federation stack/change window.

The stated YubiKey and PIV/CAC requirement for AD administrators must be
enforced by the AD FS/on-prem authentication policy and, where approved, the
later OCI identity-provider and sign-on policy configuration. It is not a
Terraform group attribute and is intentionally outside this stack.

Keep the two cloud-local break-glass accounts in the OCI **Default** identity
domain, outside AD synchronization. This stack does not create or modify them.

## Default human group catalog

| Group | Intended responsibility |
|---|---|
| `VDMS-Platform-Admins` | Management services and landing-zone operations |
| `VDSS-Security-Admins` | Security stack, firewall, and inspection services |
| `Network-Admins` | Network-specific administration |
| `Security-Auditors` | Read-only security and compliance visibility |
| `ORM-Deployment-Admins` | Resource Manager stack administration |
| `AD-Admins` | On-prem AD, AD FS, and federation administration |
| `SWR1-Workload-Admins` | Administration of workload SWR1 only |
| `SWR2-Workload-Admins` | Administration of workload SWR2 only |
| `ENTOPS` | Enterprise operations and shared-service coordination |
| `CLOUDOPS` | Day-to-day OCI cloud operations |
| `SECOPS` | Security monitoring, triage, and response operations |
| `APPDEV` | Application development activities |
| `DEVOPS` | CI/CD, automation, and deployment engineering |
| `Database-Admins` | Database platform administration |
| `Storage-Admins` | Storage administration |
| `Backup-Admins` | Backup and recovery operations |
| `Helpdesk-Operators` | Approved tier-one support workflows |
| `Incident-Responders` | Cybersecurity incident investigation and response |
| `Compliance-Auditors` | Read-only control assessment and evidence review |
| `FinOps-Analysts` | Cloud cost reporting and optimization analysis |

`ad-group-manifest.csv` is the handoff to the AD team. `workload_identifiers`
generates additional `<WORKLOAD>-Workload-Admins` entries in Terraform; keep the
AD provisioning manifest/process aligned when changing that list. Groups do not
receive permissions until a later policy stack maps each group to an approved,
least-privilege policy set.

## License choice

The default identity-domain license is `free`. It supports the stated use case:
OCI control-plane access, external identity providers, PIV/CAC, and inbound AD
synchronization within Oracle's Free-domain limits. `premium` is available as an
explicit selection but is metered; use it only when approved capacity or hybrid
identity features require it.

## Deploy in OCI Resource Manager

1. Confirm Stack 01 completed successfully and copy its
   `vdms_compartment_ocid` output.
2. Upload `oci-scca-identity-foundation-orm.zip` as a new Resource Manager stack.
3. Select the Terraform configuration source from the uploaded ZIP.
4. Enter the VDMS compartment OCID and approved identity-domain home region.
5. Keep `group_provisioning_mode = AD_SYNC` for the production AD-integrated
   environment.
6. Keep `identity_domain_license_type = free` unless Premium has been approved.
7. Run **Plan**, review that it creates exactly one `oci_identity_domain`, then
   run **Apply**.
8. Give `ad-group-manifest.csv` to the AD administrators. Create the groups in
   the approved OU, populate membership through AD governance, and configure AD
   Bridge inbound synchronization.
9. Verify all expected group names appear in the new domain before deploying
   policy or federation stacks.

In `AD_SYNC` mode a plan showing `oci_identity_domains_group` resources is a
configuration error. In `OCI_NATIVE` mode those resources are expected, but do
not later synchronize identically named AD groups into the same domain.

## Expected plan

With defaults (`AD_SYNC`):

- `1 to add`: one `oci_identity_domain.scca`;
- `0 to change`; and
- `0 to destroy`.

With `OCI_NATIVE`, the plan also creates one
`oci_identity_domains_group.human` instance for each catalog entry.

## Destruction warning

Deleting the Resource Manager stack or running Terraform destroy can attempt to
delete the identity domain and OCI-native groups. Do not destroy a domain after
federation, synchronized users, applications, or policies depend on it. Follow
the approved identity decommissioning procedure instead.

## Recommended next stack

After the domain exists and AD group synchronization is verified, the next
implementation should configure AD FS federation and the PIV/CAC/YubiKey-aware
authentication controls. Least-privilege OCI IAM policy mappings should follow
only after group ownership and federation behavior are validated.

## References

- [Oracle SCCA Landing Zone - Mission Owner SCCA v1](https://github.com/oci-landing-zones/oci-scca-landingzone/tree/master/Mission_Owner_SCCA_(SCCAv1))
- [OCI Terraform identity domain resource](https://docs.oracle.com/en-us/iaas/tools/terraform-provider-oci/latest/docs/r/identity_domain.html)
- [OCI Terraform identity-domain group resource](https://docs.oracle.com/en-us/iaas/tools/terraform-provider-oci/latest/docs/r/identity_domains_group.html)
- [Microsoft Active Directory Bridge](https://docs.oracle.com/en-us/iaas/Content/Identity/msadbridge/microsoft-active-directory-ad-bridge1.htm)
- [Configure Microsoft Active Directory Bridge](https://docs.oracle.com/en-us/iaas/Content/Identity/msadbridge/configure-microsoft-active-directory-ad-bridge.htm)
- [Manage identity providers](https://docs.oracle.com/en-us/iaas/Content/Identity/identityproviders/manage-identity-providers.htm)
- [Add an X.509 identity provider for PIV/CAC](https://docs.oracle.com/en-us/iaas/Content/Identity/identityproviders/add-x509-identity-provider.htm)
