# OCI SCCA-Like Compartment-Only Resource Manager Stack

This stack creates **only OCI compartments**. It follows the compartment structure in Oracle's Mission Owner SCCA v1 landing zone while intentionally excluding every other landing-zone component.

## Created hierarchy

With the default names and `IAD` / `PROD` labels, the stack renders:

```text
Tenancy root or an existing parent compartment
└── OCI-SCCA-LZ-Home-IAD-PROD
    ├── OCI-SCCA-LZ-VDMS-IAD-PROD
    ├── OCI-SCCA-LZ-VDSS-IAD-PROD
    ├── OCI-SCCA-LZ-Logging-IAD-PROD          (optional)
    ├── OCI-SCCA-LZ-IAC-TF-Configbackup-PROD (optional)
    ├── OCI-SCCA-LZ-WRK-IAD-SWR1
    └── OCI-SCCA-LZ-WRK-IAD-SWR2             (when requested)
```

The SCCA home compartment is the level-1 EBLZ parent. VDMS, VDSS, Logging, Backup, and all workload compartments are direct level-2 children, matching the Oracle SCCAv1 Terraform structure.

## Explicitly out of scope

The configuration contains no IAM policies, groups, dynamic groups, identity domains, tag namespaces/defaults, quotas, security zones, VCNs, subnets, gateways, DRGs, firewalls, bastions, vaults, keys, buckets, logging services, Cloud Guard targets, Vulnerability Scanning targets, alarms, events, service connectors, compute, databases, or other OCI resources.

The only Terraform resource type used is `oci_identity_compartment`.

## Files

| File | Purpose |
| --- | --- |
| `main.tf` | Creates the home, SCCA core, and workload compartments. |
| `variables.tf` | Declares and validates all placement, naming, and safety inputs. |
| `locals.tf` | Renders the Oracle SCCA-style names and hierarchy. |
| `outputs.tf` | Returns all created compartment OCIDs. |
| `schema.yaml` | Builds the OCI Resource Manager variable form. |
| `terraform.tfvars.example` | Example for local Terraform validation or testing. |
| `variables.json.example` | Example value map for OCI CLI stack creation. |

## Prerequisites

1. The Resource Manager job must already be authorized to manage compartments in the selected parent scope. This stack deliberately creates no IAM policy.
2. Know the tenancy OCID, Resource Manager region, and short region key used in the names.
3. Confirm that the rendered compartment names do not collide with compartments managed by another Terraform state.
4. Use Terraform `1.5.x` in Resource Manager.

## Deploy through the OCI Console

1. Open **Developer Services → Resource Manager → Stacks**.
2. Select **Create stack**.
3. Choose **My configuration**, then upload `oci-scca-compartments-orm.zip`.
4. Select the compartment that will store the Resource Manager stack. This does not have to be the parent of the new SCCA tree.
5. Select Terraform version **1.5.x**.
6. Review the form populated by `schema.yaml`.
7. Enter `tenancy_ocid`, `region`, naming inputs, and workload identifiers.
8. Leave `parent_compartment_ocid` blank to create the home compartment directly under the tenancy root, or enter an existing compartment OCID.
9. Keep `enable_compartment_delete` set to `false`.
10. Create the stack **without Run apply**, run **Plan**, and verify that every planned resource is an `oci_identity_compartment`.
11. Run **Apply** only after the hierarchy and names are correct.

## Deploy the stack object with OCI CLI

Copy `variables.json.example` to `variables.json`, replace the placeholders, and run:

```bash
oci resource-manager stack create \
  --compartment-id "<OCID_OF_COMPARTMENT_THAT_STORES_THE_STACK>" \
  --config-source oci-scca-compartments-orm.zip \
  --variables file://variables.json \
  --display-name "scca-compartments-only" \
  --description "SCCA-like OCI compartment hierarchy only" \
  --terraform-version "1.5.x" \
  --working-directory ""
```

After the stack is active, run a Resource Manager **Plan** and review it before Apply.

## Deletion and name-collision safety

`enable_compartment_delete` defaults to `false`. With this OCI provider setting, Terraform does not delete compartments during destroy/removal. The provider can also adopt an existing same-named compartment into state and update its managed properties, so name collisions must be reviewed carefully before Apply.

When deletion is enabled, OCI can delete a compartment only after it is empty. Deleted compartments are renamed by OCI and remain visible in deleted state for a retention period. Do not enable deletion as a routine setting.

## Relationship to Oracle's SCCA repository

This is a compartment-only adaptation of these Oracle-maintained source files:

- [Mission Owner SCCA v1 root](https://github.com/oci-landing-zones/oci-scca-landingzone/tree/master/Mission_Owner_SCCA_(SCCAv1))
- [Oracle SCCAv1 compartments.tf](https://github.com/oci-landing-zones/oci-scca-landingzone/blob/master/Mission_Owner_SCCA_(SCCAv1)/compartments.tf)
- [Oracle SCCAv1 workload.tf](https://github.com/oci-landing-zones/oci-scca-landingzone/blob/master/Mission_Owner_SCCA_(SCCAv1)/workload.tf)
- [Oracle SCCAv1 compartment variables](https://github.com/oci-landing-zones/oci-scca-landingzone/blob/master/Mission_Owner_SCCA_(SCCAv1)/compartment-variables.tf)

Differences are deliberate: provider credentials are removed for Resource Manager, deletion is disabled by default, multiple workload compartments are supported, and every non-compartment resource has been removed.
