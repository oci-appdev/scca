# MFA and Break-Glass Runbook

## Why two authentication paths are required

Federated administration and emergency administration solve different risks:

| Path | Normal purpose | Authentication authority | Required resilience |
| --- | --- | --- | --- |
| Federated | Daily human administration | Enterprise AD FS | Enterprise MFA, centralized lifecycle, auditable claims |
| Break-glass | Recover from IdP, network, certificate, DNS, or routing-policy failure | OCI-local identity | No dependency on AD FS or AD synchronization |

Break-glass is not a convenient alternative login. Any use is an incident or approved exercise.

## Federated MFA standard

1. AD FS must enforce MFA for the OCI relying party.
2. `AD-Admins` must satisfy the agency policy using PIV/CAC or YubiKey.
3. Other federated groups must satisfy the approved enterprise baseline.
4. Device enrollment, revocation, replacement, and authentication-method logs remain governed by the enterprise identity program.
5. The AD FS rule must deny access if the required privileged factor is not satisfied.
6. OCI sign-on rules may add approved controls, but must not be cited as proof that AD FS used PIV/CAC or YubiKey.

Why: the factor is presented to AD FS. OCI only receives a SAML result and cannot independently attest which physical credential was used unless the enterprise sends and governs an approved assurance claim.

## Break-glass account standard

Maintain at least two named institutional emergency accounts. Prefer the tenancy's OCI-local Default-domain path so they remain independent of the SCCA AD FS provider and AD synchronization.

Each account must:

- be cloud-local and excluded from federation/redirection rules;
- have the minimum tenancy-level capability required to repair identity federation and policies;
- have no routine human use;
- have no API signing key, auth token, customer secret key, SMTP credential, OAuth client secret, or long-lived automation credential;
- have an independently controlled high-entropy password;
- have approved OCI-native MFA, preferably two separately stored FIDO2 security keys where policy permits;
- use separate recovery and custody paths from the other account;
- generate high-priority alerts on successful or failed use;
- be tested at least quarterly and after identity-policy, domain, factor, or federation changes.

PIV/CAC presented to AD FS is not a break-glass factor because break-glass must work when AD FS is down. If a hardware key is used for OCI-native FIDO, enroll it directly with the local OCI account and retain an independently stored spare.

## Credentials and custody

Terraform must never receive the user name, password, recovery code, MFA seed, private key, or password-vault export.

Use the approved enterprise vault (for example, Keeper) with:

- separate records for each emergency account;
- access limited to designated custodians;
- dual-control approval or split knowledge where available;
- access logging and alerts;
- sealed recovery instructions;
- no account password copied into tickets, chat, email, Terraform variables, or the register template.

The register records governance metadata only. It must not contain secrets.

## Initial verification procedure

Test accounts one at a time. Never rotate or alter both in the same change.

1. Confirm the test is approved and monitoring personnel are aware.
2. Keep a known-good administrative session open.
3. Start a clean private browser that has no AD FS session.
4. Select the local/Default-domain sign-in path explicitly.
5. Retrieve the first account credential through its approved custody workflow.
6. Complete OCI-native MFA without using AD FS.
7. Perform a harmless read-only check, such as viewing the tenancy or identity-domain configuration.
8. Sign out and close the browser.
9. Confirm the expected audit event and security alert were generated.
10. Record pass/fail, timestamp, custodian, witness, ticket, and evidence reference in `break-glass-register-template.csv`.
11. Repeat using a new private browser, the second account, its separate credential, and its separate MFA custody path.
12. If either account fails, keep AD FS inactive/unpublished and repair only that account under change control.

Why separate sessions: cached federation and existing browser tokens can create a false positive that does not prove the local recovery path.

## Activation attestation

Only after both tests pass, supply these Resource Manager inputs:

```text
break_glass_account_count = 2
break_glass_last_test_date = YYYY-MM-DD
break_glass_verification_confirmation =
  I_HAVE_TESTED_TWO_LOCAL_BREAK_GLASS_ACCOUNTS
```

These values are an auditable change-record attestation, not an automated proof. Retain the underlying audit events and test record.

## Handling the existing personally named superuser

Do not treat an original personally named tenancy superuser as the long-term institutional break-glass design.

1. Inventory its privileges, credentials, active sessions, and historical use.
2. Create and fully test two institutional emergency accounts first.
3. Preserve one working recovery path throughout the transition.
4. Remove routine use and all automation credentials from the personal account.
5. Reduce or retire it only through an approved, reversible change after the institutional accounts and alerting are proven.
6. Preserve audit history and document the disposition.

Why: emergency access must survive personnel changes and have explicit custody, accountability, and recovery procedures.

## Quarterly drill

For each account:

1. Validate custodian access and approvals.
2. Test local sign-in from a clean browser.
3. Test the primary and spare OCI-native factor according to policy.
4. Perform a harmless read-only action.
5. Confirm audit ingestion and the alert path.
6. Review privilege scope and credential inventory.
7. Confirm no API or automation credentials were added.
8. Review recovery instructions and escalation contacts.
9. Record evidence and the next due date.

Do not test both accounts by changing credentials simultaneously.

## Emergency-use procedure

1. Declare an identity-access incident and open the emergency change record.
2. Obtain custody approval under the emergency procedure.
3. Sign in through the local path from an approved administrative workstation.
4. Make the smallest change needed to restore federation or routing.
5. Avoid unrelated administration.
6. Preserve OCI audit, AD FS, Resource Manager, and vault-access evidence.
7. Sign out and close all sessions.
8. Rotate the used password and re-establish independently controlled MFA/recovery material according to policy.
9. Re-test that account; do not modify the second account unless necessary.
10. Complete incident review and privilege validation.

## Monitoring requirements

Generate actionable alerts for:

- any successful or failed sign-in by a break-glass account;
- changes to the AD FS identity provider;
- changes to sign-on or IdP routing policies;
- changes to break-glass group membership or administrator grants;
- creation of API/auth/SMTP/customer-secret credentials on a break-glass account;
- MFA factor enrollment, deletion, or reset;
- repeated SAML validation or correlation failures;
- signing/encryption certificate expiration.

Route relevant OCI audit and AD FS events to the approved security monitoring platform.
