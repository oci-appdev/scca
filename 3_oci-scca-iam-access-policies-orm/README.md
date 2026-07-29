# Stack 03 - SCCA Least-Privilege IAM Access Policies

This OCI Resource Manager stack creates the human-access policies for the
AD-synchronized groups defined in Stack 02. It consumes the compartment OCIDs
from Stack 01 and the identity-domain display name from Stack 02.

The stack creates only `oci_identity_policy` resources. It does not create or
modify users, groups, memberships, dynamic groups, identity providers, AD
Bridge, AD FS, credentials, keys, secrets, federation, or sign-on policies.

## Security position

Oracle's Mission Owner SCCA v1 reference uses `manage all-resources` for its
VDMS, VDSS, and workload administrator groups. This implementation deliberately
does not copy those broad grants.

Instead, it applies these rules:

- every write grant identifies an OCI service family;
- every compartment grant uses an exact compartment OCID;
- workload groups are isolated to their matching workload compartment;
- functional groups receive no workload access until an exact workload key is
  assigned;
- no human group can manage IAM policies, users, groups, dynamic groups, keys,
  secrets, or the tenancy;
- Resource Manager administrators can run `PLAN` and `APPLY`, but not
  `DESTROY`; and
- FinOps is read-only and cannot modify budgets, invoices, subscriptions, or
  payment information.

This stack creates allow policies only. If it does not create an allow
statement, the group has no access through this stack. OCI now also offers an
optional tenancy-wide IAM deny-policy feature, but enabling it is permanent and
requires separate architecture, lockout, and change-control review. Stack 03
does not enable or create deny policies.

## Policy placement

Most policies are stored in the SCCA home compartment. OCI policy inheritance
allows those policies to govern the VDMS, VDSS, and workload child
compartments. The statements still use exact target compartment OCIDs.

Three policies must be stored at the tenancy root because the target services
are tenancy-level:

1. `ORM-Deployment-Admins`: stack/job operations in one exact ORM compartment,
   plus read-only tenancy/compartment discovery.
2. `FinOps-Analysts`: read-only Cost Analysis and budget visibility.
3. Security roles: read-only Cloud Guard configuration discovery; operational
   permissions remain limited to the SCCA compartment tree.

Set `enable_tenancy_scope_policies = false` when root policies must be installed
through a separate agency change-control process. The stack then omits all
three root policies and reports groups that otherwise have no generated access
in `groups_without_generated_policy_json`.

## Default group access

| Group | Default access | Scope |
|---|---|---|
| `VDMS-Platform-Admins` | Manage Bastion, monitoring, notifications, events, vulnerability scanning, and logging | VDMS only |
| `VDSS-Security-Admins` | Manage Cloud Guard for the SCCA tree plus Network Firewall, WAF, inspection load balancers, logging, and alarms | SCCA home tree and VDSS |
| `Network-Admins` | Manage networking and DNS; read endpoint metadata | SCCA home tree |
| `Security-Auditors` | Read-only security telemetry and audit visibility | SCCA home tree |
| `ORM-Deployment-Admins` | Use stacks and run PLAN/APPLY jobs | Exact ORM compartment |
| `AD-Admins` | Read identity-domain metadata | VDMS only |
| `ENTOPS` | Read-only inventory and operations visibility | SCCA home tree |
| `SECOPS` | Security telemetry plus approved Cloud Guard responder execution | SCCA home tree |
| `Incident-Responders` | Investigation visibility plus approved responder execution | SCCA home tree |
| `Compliance-Auditors` | Inventory, policy, audit, tag, and logging-configuration visibility | SCCA home tree |
| `FinOps-Analysts` | Read Cost Analysis and budgets | Tenancy cost services |
| `<SWR>-Workload-Admins` | Manage common compute/storage/load-balancing services; use existing networks | Matching workload only |
| `CLOUDOPS` | Common infrastructure administration | Explicit workload assignments only |
| `APPDEV` | Use existing compute and read approved operational data | Explicit workload assignments only |
| `DEVOPS` | Manage DevOps, Functions, API Gateway, and OKE | Explicit workload assignments only |
| `Database-Admins` | Manage database-family | Explicit workload assignments only |
| `Storage-Admins` | Manage volume, file, and object storage | Explicit workload assignments only |
| `Backup-Admins` | Manage block and boot volume backups, policies, and policy assignments | Explicit workload assignments only |
| `Helpdesk-Operators` | No OCI resource policy | Identity-domain role assigned later |

The detailed statement-by-statement summary is in `policy-matrix.csv`.

## Why some groups receive no default workload access

`APPDEV`, `DEVOPS`, `CLOUDOPS`, `Database-Admins`, `Storage-Admins`, and
`Backup-Admins` are reusable functional groups. Granting any of them access to
every workload would break the SWR1/SWR2 isolation model.

Assign only approved workload keys in Resource Manager. For example:

```hcl
cloudops_workload_keys       = ["SWR1", "SWR2"]
database_admin_workload_keys = ["SWR1"]
storage_admin_workload_keys  = ["SWR2"]
```

Every selected key must exist in `workload_compartment_ocids_json`. A typo or
assignment to a nonexistent workload stops the plan.

## Workload administrator boundary

For each workload entry from Stack 01, the stack creates a matching policy for
`<WORKLOAD>-Workload-Admins`. The baseline includes:

- Compute instances;
- block volumes;
- load balancers and network load balancers;
- File Storage;
- Object Storage;
- use of existing networking;
- alarms, metrics, and notification topics.

It intentionally excludes IAM administration, network ownership, Vault keys,
secrets, database-family, OKE, Functions, API Gateway, and DevOps services.
Specialized groups receive those service families only after an explicit
workload assignment.

## Resource Manager safety

The ORM policy follows Oracle's documented pattern that prevents destroy jobs:

```text
Allow group <domain>/ORM-Deployment-Admins to use orm-stacks in compartment id <orm-compartment-ocid>
Allow group <domain>/ORM-Deployment-Admins to read orm-jobs in compartment id <orm-compartment-ocid>
Allow group <domain>/ORM-Deployment-Admins to manage orm-jobs in compartment id <orm-compartment-ocid> where any {target.job.operation = 'PLAN', target.job.operation = 'APPLY'}
```

Resource Manager uses the permissions of the person running a job. Membership
in `ORM-Deployment-Admins` alone does not authorize the downstream resources in
a Terraform configuration. The person also needs the appropriate functional
group membership for the exact target compartment.

Anyone with `read orm-jobs` can read state and Terraform configurations for the
authorized stack compartment. Keep secrets and private keys out of Terraform
variables, outputs, and state.

## AD FS, PIV/CAC, and YubiKey enforcement

This stack does not add `request.user.mfaTotpVerified` conditions. That OCI
condition represents OCI's MFA state and must not be treated as proof that AD FS
validated a PIV/CAC card or YubiKey.

The agency's hardware-authentication requirement for `AD-Admins` must be
enforced in AD FS/on-prem AD and the later identity-domain sign-on/federation
configuration. OCI IAM policies define authorization after sign-in; they do not
replace the upstream authentication control.

Keep cloud-local break-glass identities outside these synchronized groups. This
stack creates no policy for the Default-domain Administrators group and does not
change the break-glass process.

## Identity-domain administrative roles

OCI Identity Domain roles, such as Security Administrator or Help Desk
Administrator, are application-role assignments inside the identity domain.
They are not substitutes for OCI resource policies.

Therefore:

- `AD-Admins` receives only domain metadata read access here;
- `Helpdesk-Operators` receives no OCI resource permission here; and
- the precise Identity Domain administrative roles should be assigned in the
  federation/identity-administration stack after AD synchronization is verified.

## Deployment prerequisites

Before applying:

1. Stack 01 must contain the SCCA home, VDMS, VDSS, and intended workload
   compartments.
2. Stack 02 must contain the identity domain and all required groups must be
   visible after AD Bridge synchronization.
3. The deployer must be authorized to create policies in the SCCA home
   compartment.
4. When `enable_tenancy_scope_policies = true`, the deployer must also be
   authorized to create policies at the tenancy root.
5. Security and application owners must approve every nonempty functional
   workload assignment list.

Do not grant `ORM-Deployment-Admins` permission to manage IAM policies merely
so they can deploy this stack. A tenancy security administrator should perform
or approve the initial Stack 03 apply.

## Deploy in OCI Resource Manager

1. Upload `oci-scca-iam-access-policies-orm.zip` as a new Resource Manager
   stack.
2. Copy these Stack 01 outputs into the form:
   `home_compartment_ocid`, `vdms_compartment_ocid`,
   `vdss_compartment_ocid`, and `workload_compartment_ocids_json`.
3. Copy `identity_domain_display_name` from Stack 02.
4. Enter the exact compartment that contains the SCCA ORM stacks, or leave the
   field blank to use the SCCA home compartment.
5. Leave all functional workload arrays empty until their scope is approved.
6. Run **Plan** and export/review `generated_policy_statements_json`.
7. Confirm the plan contains only `oci_identity_policy` resources and contains
   no `manage all-resources` statement.
8. Confirm every group principal begins with the Stack 02 identity-domain name.
9. Confirm every functional policy targets the intended workload compartment
   OCID.
10. Run **Apply** during the approved IAM change window.

With two workload compartments and no functional assignments, the expected
plan creates 14 policies: 3 root policies, 9 fixed home policies, and 2 workload
administrator policies.

## Post-apply tests

Test with non-production synchronized accounts before production use:

- SWR1 administrators cannot list or change SWR2 resources.
- Network administrators can change VCN resources but cannot manage compute or
  IAM policies.
- ORM administrators can run PLAN and APPLY but cannot submit DESTROY.
- Security and compliance auditors cannot mutate resources.
- FinOps can open Cost Analysis and budgets but cannot edit budgets or access
  invoices/payment administration.
- Helpdesk and unassigned functional groups receive authorization failures.
- AD administrator sign-in satisfies the approved PIV/CAC/YubiKey flow in AD FS.

Save the plan, applied policy JSON output, test evidence, approver record, and AD
group membership export with the ATO evidence package.

## Destruction warning

Destroying this stack removes its IAM policies and immediately revokes the
access they grant. Run destroy only through the approved access-decommissioning
process, with a verified alternate administrative path and rollback plan.

## Recommended next step

After these policies are applied and negative-access tests pass, build the AD FS
federation and Identity Domain administrative-role stack. Then assign the
minimum Security Administrator and Help Desk Administrator roles, configure
PIV/CAC/YubiKey-aware sign-on, and test both normal and break-glass access.

## References

- [Oracle SCCA Landing Zone - Mission Owner SCCA v1](https://github.com/oci-landing-zones/oci-scca-landingzone/tree/master/Mission_Owner_SCCA_(SCCAv1))
- [OCI policy inheritance](https://docs.oracle.com/en-us/iaas/Content/Identity/policieshow/Policy_Inheritance.htm)
- [OCI policy verbs and resource types](https://docs.oracle.com/iaas/Content/Identity/policyreference/policyreference.htm)
- [IAM policy reference with identity domains](https://docs.oracle.com/iaas/Content/Identity/policyreference/iampolicyreference.htm)
- [OCI IAM deny policies](https://docs.oracle.com/en-us/iaas/Content/Identity/policysyntax/denypolicies.htm)
- [Securing Resource Manager](https://docs.oracle.com/en-us/iaas/Content/Security/Reference/resourcemanager_security.htm)
- [Network Firewall IAM policies](https://docs.oracle.com/en-us/iaas/Content/network-firewall/iam-policy-reference.htm)
- [Cloud Guard policies](https://docs.oracle.com/iaas/cloud-guard/using/policies.htm)
- [Cost Analysis IAM policy](https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/costanalysisoverview.htm)
- [Budgets IAM policy](https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/budgetsoverview.htm)
