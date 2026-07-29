# AD FS Federation Runbook

## Purpose

This runbook connects the SCCA identity domain to enterprise AD FS without allowing SAML to create shadow identities. The directory synchronization process remains authoritative for users and groups.

## Roles

| Role | Responsibility |
| --- | --- |
| OCI identity-domain administrator | Registers/tests the IdP and configures correlation |
| AD FS administrator | Creates the relying-party trust, claims, encryption, and MFA policy |
| AD/Bridge administrator | Verifies synchronized users, groups, and primary email |
| Security approver | Approves MFA, claims, test, and rollback controls |
| Break-glass custodian | Tests recovery independently of AD FS |
| Change coordinator | Controls activation, routing, publication, and evidence |

The same person should not approve the change and be the sole custodian of both break-glass credentials.

## Phase A — Pre-change validation

1. Confirm the target is the dedicated Stack 02 SCCA identity domain.
2. Confirm `group_provisioning_mode=AD_SYNC` and the last synchronization succeeded.
3. Choose two pilot users:
   - one standard administrative user;
   - one member of `AD-Admins` who possesses the approved PIV/CAC and YubiKey.
4. Compare each pilot's AD email with the OCI **Primary email address**. They must match exactly and be unique.
5. Search the identity domain for duplicate primary-email values. Resolve duplicates before federation.
6. Test both cloud-local break-glass accounts using the separate runbook.
7. Start an approved change window with an OCI-local session open.

Why: the claims contract can only correlate safely when the target identity exists, is enabled, and has a unique matching attribute.

## Phase B — Register OCI without changing sign-in

1. Export AD FS federation metadata from:

   ```text
   https://<adfs-fqdn>/FederationMetadata/2007-06/FederationMetadata.xml
   ```

2. Verify the file comes from the approved farm.
3. Record the AD FS entity ID, SSO endpoint, signing-certificate thumbprint, issuer, and expiration.
4. Base64-encode the XML and run Resource Manager pass 1 with the provider disabled and hidden.
5. Record these stack outputs:
   - `identity_provider_id`
   - `oci_service_provider_metadata_url`
   - `adfs_metadata_sha256`
6. Retrieve the OCI service-provider metadata from the output URL and validate its entity ID, assertion consumer service URL, and encryption certificate.

Why: both parties need trusted metadata to agree on issuers, endpoints, and public certificates.

## Phase C — Create the OCI relying party in AD FS

Use the enterprise AD FS change process:

1. Add a **Claims Aware** relying-party trust.
2. Import the OCI service-provider metadata URL produced by the stack.
3. Give the trust a stable name that identifies the SCCA identity domain and environment.
4. Restrict access to the approved pilot population during testing.
5. Verify the SAML response is signed.
6. With `require_encrypted_assertions=true`, verify AD FS encrypts the assertion for the OCI relying party using the certificate supplied in OCI metadata.
7. Configure SHA-256 signing.
8. Do not enable unsolicited assumptions, JIT provisioning, or broad permit-all access as a shortcut.

Why: the relying party tells AD FS which OCI endpoint may receive assertions and which certificate protects their confidentiality.

## Phase D — Configure the claims contract

Create the two claim rules documented in `adfs-claims-contract.csv`.

### Rule 1 — Send enterprise email

- Claim rule template: **Send LDAP Attributes as Claims**
- Attribute store: **Active Directory**
- LDAP attribute: **E-Mail-Addresses**
- Outgoing claim type: **E-Mail Address**

### Rule 2 — Transform email into NameID

- Claim rule template: **Transform an Incoming Claim**
- Incoming claim type: **E-Mail Address**
- Outgoing claim type: **Name ID**
- Outgoing name ID format: **Email**
- Pass through all claim values

Test that the emitted value is the approved enterprise address—not an alias, UPN, personal address, display name, or group value.

Why: OCI uses this NameID to locate the pre-synchronized user. Minimal claims reduce disclosure and avoid ambiguous identity matching.

## Phase E — Apply enterprise MFA

1. Apply the approved AD FS access-control policy to the OCI relying party.
2. Require members of `AD-Admins` to use PIV/CAC or YubiKey according to agency policy.
3. Apply the approved enterprise MFA baseline to the other federated SCCA groups.
4. Define the behavior when the required factor is absent, revoked, expired, or unavailable. The result must be deny—not bypass.
5. Verify AD FS logs record the authentication method needed for audit evidence.
6. Do not rely on an OCI-side TOTP/MFA assertion flag to claim that PIV/CAC or YubiKey was used.

Why: AD FS performs the federated authentication and therefore owns the factor decision. OCI receives the result, not possession proof for a specific physical device.

## Phase F — Configure OCI correlation

In the OCI identity-domain administrative console:

1. Open the registered AD FS identity provider.
2. Verify provider type is SAML and JIT user provisioning/updates are off.
3. Configure or verify:
   - incoming value: SAML assertion **Name ID**;
   - NameID format: **Email**;
   - target OCI attribute: **Primary email address**.
4. Do not map privileged group membership from an ungoverned SAML claim. Stack 02's synchronized groups are authoritative.
5. Save while the provider remains hidden from the login page.

Why: a deterministic correlation rule binds the AD FS assertion to the already governed identity rather than creating a second authority.

## Phase G — Activate and test while hidden

1. Complete Resource Manager pass 2 to activate the provider.
2. Use the identity-domain provider's test-login action.
3. Execute all rows in `federation-test-plan.csv`.
4. For the `AD-Admins` user, capture AD FS evidence that PIV/CAC or YubiKey satisfied the policy.
5. Confirm the OCI audit event identifies the synchronized OCI user.
6. Confirm an unmatched email does not create a user.
7. Confirm a disabled AD or OCI user cannot establish access.

Stop if any expected result fails. Do not publish and do not assign a broad IdP policy.

## Phase H — Assign the OCI IdP policy

This is a manual, witnessed change:

1. Keep a tested local break-glass session open.
2. Create or update an IdP routing rule for the synchronized enterprise population.
3. Assign AD FS to that rule.
4. Exclude the cloud-local break-glass identities. If they reside in the Default domain, verify the normal Default-domain local path remains available.
5. Do not configure unconditional automatic redirection that removes local login.
6. Test the routing rule from a new private browser.
7. Re-test both break-glass accounts from a separate new private browser.

Why: routing policy controls who is sent to AD FS. A mistake here can affect every administrator even if the SAML configuration itself is correct.

## Phase I — Publish and close

1. Complete Resource Manager pass 3 to show the provider on the login page.
2. Re-run the full test plan.
3. Export Resource Manager Plan and Apply logs.
4. Record the metadata SHA-256, AD FS configuration, claims, MFA policy, OCI correlation, IdP policy, and test evidence.
5. Enable alerts for provider/policy changes, repeated federation failures, and break-glass use.
6. Schedule quarterly break-glass testing and certificate-expiration review.

## Immediate rollback

1. Use the already-open OCI-local administrative session.
2. Disable or remove the new IdP routing rule.
3. Hide and deactivate the provider through Resource Manager.
4. Confirm both local accounts still work.
5. Preserve failure logs before changing claims or certificates.
6. Re-enter testing only through a new approved change.

Do not delete synchronized users, groups, or Stack 03 policies as a federation rollback.

## Certificate rollover

At least 60 days before AD FS signing or OCI encryption certificate expiration:

1. Export new metadata and compare issuer, endpoints, and certificates.
2. Open an approved rollover change.
3. Preserve the previous trusted certificate during the overlap period when supported.
4. Update the Resource Manager metadata input and Plan.
5. Test hidden/pilot traffic before removing the old trust.
6. Record the new metadata SHA-256 and expiration.

An emergency rollover follows the rollback path first; it must not bypass break-glass verification.
