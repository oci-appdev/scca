# Stack 04 — SCCA Federation and Authentication

This OCI Resource Manager stack registers enterprise AD FS as a SAML identity provider for the identity domain created by Stack 02. It covers only federation and authentication controls:

- AD FS SAML identity-provider registration
- staged activation and login-page publication
- AD-authoritative identity guardrails
- MFA responsibility and test procedures
- cloud-local break-glass readiness gates

It does **not** create compartments, identity domains, users, groups, memberships, IAM access policies, passwords, MFA factors, AD FS relying parties, or OCI sign-on/IdP policy rules.

## Why this stack is needed

### 1. Enterprise federation provides one authoritative identity

Without federation, administrators can accumulate separate OCI passwords that do not automatically follow the enterprise joiner/mover/leaver process. AD FS authenticates the person against on-premises AD, while AD Bridge/directory synchronization pre-provisions the matching OCI user and groups.

Authentication and provisioning remain separate:

- **AD Bridge/synchronization:** creates, updates, disables, and groups the OCI identity.
- **AD FS SAML:** proves that the person signing in is the corresponding enterprise identity.
- **OCI IAM policies from Stack 03:** decide what the synchronized groups may do.

SAML just-in-time provisioning is disabled. Allowing both AD synchronization and SAML JIT to create identities can produce duplicate or shadow accounts and weaken offboarding.

### 2. Correct claims prevent account misassociation

OCI must correlate the SAML assertion to the already synchronized OCI user. This design uses the user's enterprise email as the SAML NameID and maps it to the OCI **Primary email address**. If the values are missing, stale, or duplicated, federation can fail or identify the wrong account.

### 3. MFA protects privileged sessions

AD FS is the authentication authority for federated users, so it must enforce the approved enterprise MFA:

- Members of `AD-Admins` must use the agency-approved PIV/CAC or YubiKey method at AD FS.
- Other federated groups use the enterprise MFA baseline approved for their assurance level.
- OCI-local break-glass accounts use OCI-native MFA because AD FS may be unavailable during an emergency.

An OCI SAML session does not, by itself, prove that a particular hardware factor was used. The AD FS access-control policy and its authentication logs are the authoritative evidence for PIV/CAC or YubiKey use.

### 4. Break-glass access removes a circular dependency

Federation depends on AD FS, AD, DNS, certificates, routing, and the OCI IdP policy. A failure or bad policy change can block every federated administrator. At least two cloud-local accounts provide independent recovery access.

Their credentials are deliberately excluded from Terraform and state. Terraform cannot safely create the physical MFA enrollment, verify custody, or prove that a human can complete an emergency login.

### 5. Staged activation prevents a tenancy lockout

The stack uses three controlled passes:

1. **Register:** create the provider disabled and hidden.
2. **Activate:** enable it only after AD FS and both break-glass accounts are tested.
3. **Publish:** show it on the login page only after hidden-provider and IdP-policy tests pass.

The stack does not enable automatic redirection to AD FS. A local login route must remain available for break-glass recovery.

## Architecture boundary

| Component | System of record | This stack |
| --- | --- | --- |
| Human users and groups | On-premises AD through synchronization | Validates `AD_SYNC`; creates none |
| Authentication | Enterprise AD FS | Registers its SAML metadata |
| Privileged federated MFA | AD FS access-control policy | Documents and tests PIV/CAC or YubiKey |
| Break-glass authentication | OCI-local identity, preferably in the Default domain | Attests readiness; creates no credentials |
| Authorization | OCI IAM policies from Stack 03 | Unchanged |
| IdP routing policy | OCI identity-domain console | Manual, witnessed cutover |

## Files

| File | Purpose |
| --- | --- |
| `versions.tf` | Pins supported Terraform and OCI provider versions |
| `provider.tf` | Configures the OCI provider for Resource Manager |
| `variables.tf` | Inputs, validation, and gated confirmation phrases |
| `locals.tf` | Normalized URLs and readiness conditions |
| `main.tf` | AD FS SAML identity-provider resource and safety preconditions |
| `outputs.tf` | Metadata URL, provider status, and non-secret control evidence |
| `schema.yaml` | OCI Resource Manager variable form |
| `ADFS_FEDERATION_RUNBOOK.md` | AD FS relying-party, claims, cutover, and rollback procedure |
| `MFA_AND_BREAK_GLASS_RUNBOOK.md` | MFA boundary, account hardening, custody, testing, and monitoring |
| `ACTIVATION_CHECKLIST.md` | Three-pass change checklist and evidence record |
| `adfs-claims-contract.csv` | Exact SAML claims contract |
| `federation-test-plan.csv` | Positive and negative test cases |
| `break-glass-register-template.csv` | Non-secret custody and quarterly-test register |

## Prerequisites

- Stack 02 has produced `identity_domain_url`, `identity_domain_display_name`, and `group_provisioning_mode=AD_SYNC`.
- AD Bridge/directory synchronization is healthy for the required enterprise users and groups.
- The same unique primary email exists in AD and OCI for each test user.
- Two OCI-local break-glass accounts exist outside the AD FS dependency and can reach tenancy-level recovery administration.
- Each break-glass account has approved OCI-native MFA and its own independently controlled credential.
- AD FS administrators can create a relying-party trust, issue claims, apply MFA access control, and export federation metadata.
- The change, test, rollback, and monitoring owners are identified.

## Step-by-step deployment

### Step 1 — Verify break-glass before touching federation

Follow `MFA_AND_BREAK_GLASS_RUNBOOK.md`. In separate private-browser sessions, test both local accounts from the same administrative path that will be available during an outage. Verify that each can sign in without AD FS and can perform a harmless read-only tenancy administration check.

Why first: recovery access must be proven before introducing a control that could block normal administrators.

### Step 2 — Export and encode AD FS metadata

Download the approved farm metadata:

```text
https://<adfs-fqdn>/FederationMetadata/2007-06/FederationMetadata.xml
```

Inspect the entity ID, SSO endpoints, signing certificate, issuer, and certificate expiration. Base64-encode the XML for the Resource Manager variable:

```powershell
[Convert]::ToBase64String(
  [IO.File]::ReadAllBytes("FederationMetadata.xml")
) | Set-Clipboard
```

Why base64: Resource Manager accepts a single-line value without changing XML whitespace or quoting. SAML metadata contains public certificates only; never supply a private key, token, or password.

### Step 3 — Resource Manager pass 1: register disabled and hidden

Create a Resource Manager stack from this ZIP and enter:

- Stack 02 identity-domain outputs
- `group_provisioning_mode = AD_SYNC`
- the base64 AD FS metadata
- `activate_adfs_idp = false`
- `publish_adfs_on_login_page = false`

Run Plan, review that exactly one `oci_identity_domains_identity_provider` will be created, and Apply. Record the `oci_service_provider_metadata_url` and `adfs_metadata_sha256` outputs.

Why disabled and hidden: this creates a reviewable OCI configuration without changing any user's sign-in path.

### Step 4 — Configure AD FS

Use `ADFS_FEDERATION_RUNBOOK.md` to import the OCI service-provider metadata, configure the claims contract, configure assertion encryption, and enforce the approved AD FS MFA policy. Keep access scoped to the approved pilot group until testing is complete.

Why manual: the AD FS farm is outside OCI and its access-control policy must be reviewed by the enterprise identity team.

### Step 5 — Configure OCI correlation

In the identity-domain console, verify the provider maps:

- SAML assertion **Name ID**
- NameID format **Email**
- OCI user attribute **Primary email address**

Do not enable JIT user creation or attribute updates.

Why: AD synchronization creates the account; federation must only locate and authenticate it.

### Step 6 — Resource Manager pass 2: activate but keep hidden

After the two local accounts and the AD FS configuration are ready:

- set `break_glass_account_count` to at least `2`
- enter the UTC `break_glass_last_test_date`
- enter `I_HAVE_TESTED_TWO_LOCAL_BREAK_GLASS_ACCOUNTS`
- enter the approved `activation_change_ticket`
- enter `ACTIVATE_ADFS_IDP_AFTER_SUCCESSFUL_TEST`
- set `activate_adfs_idp = true`
- keep `publish_adfs_on_login_page = false`

Plan and Apply. Use the identity-domain test action to perform the test cases in `federation-test-plan.csv`.

Why hidden: activation is required for end-to-end testing, but publication should not expose an unproven option to all users.

### Step 7 — Assign the OCI IdP policy rule

During the approved change window, manually assign AD FS to an OCI IdP policy rule scoped to the synchronized enterprise population. Do not include the cloud-local break-glass accounts. Do not configure global automatic redirection.

Test the rule with a standard administrator, an `AD-Admins` member, a disabled AD account, an unmatched account, and both break-glass accounts.

Why manual: a sign-on routing error can lock out all users. The cutover needs a witnessed change, live session, and immediate rollback capability.

### Step 8 — Resource Manager pass 3: publish

When all checklist entries pass:

- set `publish_adfs_on_login_page = true`
- enter `PUBLISH_ADFS_AFTER_FEDERATION_AND_BREAK_GLASS_TESTS`

Plan and Apply. Re-run the full test plan from a clean browser.

Why last: publication makes the enterprise option discoverable; it is not a substitute for successful routing and recovery tests.

### Step 9 — Collect evidence and operate the control

Retain the approved change, plans/applies, metadata hash, claim screenshots, IdP-policy configuration, AD FS MFA evidence, test results, and break-glass test record. Alert on break-glass sign-in and federation-policy changes. Re-test at least quarterly and after relevant changes.

## Rollback

If federated testing fails:

1. Keep an already authenticated local break-glass session open.
2. Remove or disable the new OCI IdP-policy rule.
3. Set `publish_adfs_on_login_page=false`.
4. Set `activate_adfs_idp=false`.
5. Plan and Apply.
6. Correct AD FS metadata, claims, certificates, MFA rules, or user correlation before retrying.

Do not destroy the provider during an incident. `prevent_destroy=true` intentionally blocks accidental removal. A permanent deletion requires a separately reviewed source change after the provider is disabled, hidden, unassigned, and its evidence is retained.

## Security decisions

- No password, recovery code, private key, session token, or MFA seed is an input or output.
- SAML JIT provisioning and attribute updates are forced off.
- Assertion encryption defaults on.
- Activation and publication default off.
- At least two tested break-glass accounts are required before activation.
- The stack does not prove MFA method from an OCI-side SAML flag; AD FS policy/logs provide that evidence.
- No automatic IdP redirect is configured.
- Provider destruction is blocked.

## Authoritative references

- [Oracle — Configure SSO between AD FS and an OCI identity domain](https://docs.oracle.com/en-us/iaas/Content/Identity/tutorials/adfs/sso_adfs/adfs_sso.htm)
- [Oracle — Identity-domain sign-on policies](https://docs.oracle.com/en-us/iaas/Content/Identity/signonpolicies/managingsignonpolicies.htm)
- [Oracle — Configure FIDO security keys](https://docs.oracle.com/en-us/iaas/Content/Identity/mfa/configure-fido-security.htm)
- [Oracle Terraform provider — identity provider resource](https://docs.oracle.com/en-us/iaas/tools/terraform-provider-oci/latest/docs/r/identity_domains_identity_provider.html)
- [OCI SCCA Landing Zone](https://github.com/oci-landing-zones/oci-scca-landingzone/tree/master/Mission_Owner_SCCA_(SCCAv1))
