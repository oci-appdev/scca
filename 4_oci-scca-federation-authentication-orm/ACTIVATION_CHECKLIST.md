# Federation Activation Checklist

Use this checklist as the change record. Enter evidence references, not passwords, recovery codes, tokens, private keys, or MFA seeds.

## Change identification

| Field | Value |
| --- | --- |
| Environment | |
| Stack 02 identity domain | |
| AD FS farm/entity ID | |
| Change ticket | |
| Change coordinator | |
| OCI administrator | |
| AD FS administrator | |
| Security approver | |
| Rollback owner | |
| Scheduled window (UTC) | |

## Gate 0 — Prerequisites

- [ ] Target is the approved SCCA identity domain.
- [ ] Stack 02 reports `group_provisioning_mode=AD_SYNC`.
- [ ] AD Bridge/directory synchronization is healthy.
- [ ] Pilot users exist, are enabled, and have unique matching AD/OCI primary email values.
- [ ] Stack 03 IAM policies are already reviewed and are not being changed in this work.
- [ ] Two institutional OCI-local break-glass accounts exist.
- [ ] Both local accounts work without AD FS from clean private-browser sessions.
- [ ] Each local account uses its own credential and independently controlled OCI-native MFA.
- [ ] Break-glass login and factor events reach monitoring.
- [ ] Rollback session and personnel are ready.

Evidence:

```text

```

## Gate 1 — Register disabled and hidden

- [ ] Approved AD FS metadata was retrieved from the trusted endpoint.
- [ ] Issuer, SSO endpoint, signing certificate, and expiration were reviewed.
- [ ] Base64 input contains public metadata only.
- [ ] Resource Manager Plan creates only the intended identity provider.
- [ ] `activate_adfs_idp=false`.
- [ ] `publish_adfs_on_login_page=false`.
- [ ] Apply succeeded.
- [ ] OCI provider is disabled and hidden.
- [ ] OCI service-provider metadata URL was recorded.
- [ ] AD FS metadata SHA-256 was recorded.

Evidence:

```text

```

## Gate 2 — AD FS and correlation

- [ ] OCI relying-party metadata was imported into AD FS.
- [ ] Assertion consumer service and entity ID match approved OCI metadata.
- [ ] SAML response signing uses SHA-256.
- [ ] Assertion encryption is configured when required by the stack.
- [ ] AD `E-Mail-Addresses` is issued as `E-Mail Address`.
- [ ] `E-Mail Address` is transformed to NameID format Email.
- [ ] OCI maps NameID to Primary email address.
- [ ] JIT creation and JIT attribute updates are disabled.
- [ ] AD FS access is initially limited to the pilot population.
- [ ] `AD-Admins` require PIV/CAC or YubiKey in AD FS.
- [ ] Other users receive the approved enterprise MFA baseline.
- [ ] AD FS denies access when the required factor is not satisfied.

Evidence:

```text

```

## Gate 3 — Activate but keep hidden

- [ ] `break_glass_account_count` is at least 2.
- [ ] `break_glass_last_test_date` records the successful UTC test date.
- [ ] Break-glass exact confirmation was entered.
- [ ] Activation change ticket was entered.
- [ ] Activation exact confirmation was entered.
- [ ] `activate_adfs_idp=true`.
- [ ] `publish_adfs_on_login_page=false`.
- [ ] Resource Manager Plan changes only the intended provider.
- [ ] Apply succeeded.
- [ ] Standard pilot succeeds.
- [ ] `AD-Admins` pilot succeeds with PIV/CAC or YubiKey evidence.
- [ ] Missing required privileged MFA is denied.
- [ ] Disabled user is denied.
- [ ] Unmatched email is denied and no JIT user is created.
- [ ] Invalid/altered SAML response is denied.

Evidence:

```text

```

## Gate 4 — IdP policy assignment

- [ ] A tested local administrative session remains open.
- [ ] IdP rule applies only to the approved synchronized enterprise population.
- [ ] Local break-glass identities are excluded.
- [ ] No unconditional automatic redirection removes the local login path.
- [ ] New private-browser federated login follows the intended route.
- [ ] Both local break-glass accounts still work from separate clean browsers.
- [ ] Failure-path and audit evidence meet expectations.

Evidence:

```text

```

## Gate 5 — Publish

- [ ] All rows in `federation-test-plan.csv` pass.
- [ ] Security approver authorizes publication.
- [ ] Publication exact confirmation was entered.
- [ ] `publish_adfs_on_login_page=true`.
- [ ] Resource Manager Plan changes only login-page visibility.
- [ ] Apply succeeded.
- [ ] Full test plan passes again from clean sessions.
- [ ] Resource Manager, OCI audit, AD FS, and monitoring evidence is retained.
- [ ] Quarterly break-glass drill and certificate review are scheduled.

Evidence:

```text

```

## Rollback decision

Rollback immediately if:

- a break-glass account fails;
- privileged MFA can be bypassed;
- correlation reaches the wrong identity;
- an unmatched assertion creates a user;
- local login becomes unavailable;
- the routing rule affects an unintended population; or
- required audit evidence is missing.

Rollback completion:

- [ ] IdP routing rule disabled or removed.
- [ ] Provider hidden.
- [ ] Provider deactivated.
- [ ] Both local accounts verified.
- [ ] Failure evidence preserved.
- [ ] Incident/problem record opened.

## Approval

| Decision | Name/role | UTC timestamp | Evidence/reference |
| --- | --- | --- | --- |
| Activate | | | |
| Assign IdP rule | | | |
| Publish | | | |
| Close or roll back | | | |
