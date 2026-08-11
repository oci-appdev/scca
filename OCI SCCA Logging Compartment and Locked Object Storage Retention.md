OCI SCCA LOGGING COMPARTMENT AND LOCKED OBJECT STORAGE RETENTION

PURPOSE

Use EBLZ::Logging as the centralized immutable logging and evidence archive compartment for the OCI SCCA landing zone.

The design should:

• Centralize OCI logs and security evidence.
• Archive logs into private OCI Object Storage buckets.
• Apply time-bound retention policies.
• Permanently lock retention after a validation period.
• Separate logging administration from retention custody.
• Support audit, CSSP, incident response, compliance, and evidence preservation.

1. TARGET ARCHITECTURE

OCI Logging
↓
OCI Connector Hub
↓
OCI Object Storage
↓
EBLZ::Logging
↓
SCCA-Log-Evidence
↓
365-Day Locked Retention

Additional evidence bucket:

EBLZ::Logging
↓
SCCA-CSSP-Evidence
↓
365-Day Locked Retention

2. LOGGING COMPARTMENT

Recommended compartment:

EBLZ::Logging

This compartment should contain the centralized logging and evidence resources, including:

• Log evidence buckets
• CSSP evidence buckets
• Connector Hub resources
• Security evidence exports
• Long-term audit evidence
• Retention policies

3. CD3 BUCKET CONFIGURATION

SCCA Log Evidence Bucket

Compartment Name:
EBLZ::Logging

Bucket Name:
SCCA-Log-Evidence

Storage Tier:
Standard

Auto Tiering:
Disabled

Object Versioning:
Enable if required by the security design

Emit Object Events:
Enabled

Visibility:
Private

Retention Rules:

SCCA-Log-Retention::365::DAYS::<LOCK_DATE>

CSSP Evidence Bucket

Compartment Name:
EBLZ::Logging

Bucket Name:
SCCA-CSSP-Evidence

Storage Tier:
Standard

Auto Tiering:
Disabled

Object Versioning:
Enable if required

Emit Object Events:
Enabled

Visibility:
Private

Retention Rules:

SCCA-CSSP-Retention::365::DAYS::<LOCK_DATE>

4. CD3 RETENTION RULE FORMAT

CD3 supports the following format:

RuleName::TimeAmount::TimeUnit::TimeRuleLocked

Example:

SCCA-Log-Retention::365::DAYS::2026-08-27T00:00:00Z

Another accepted date format is:

SCCA-Log-Retention::365::DAYS::27-08-2026

The UTC timestamp format is preferred.

Valid time units include:

DAYS
YEARS

Example indefinite retention rule:

SCCA-Log-Retention::indefinite

5. RETENTION LOCK TIMING

Do not permanently lock the retention rule immediately.

Recommended process:

1. Create the Object Storage bucket.
2. Create the retention rule.
3. Set the future lock date.
4. Allow at least the OCI-required waiting period before the lock becomes permanent.
5. Test the entire logging and evidence workflow.
6. Allow the retention rule to permanently lock only after validation succeeds.

Recommended operational buffer:

15 days or more.

6. WHAT LOCKED RETENTION MEANS

Before the retention rule becomes permanently locked:

• The retention rule protects objects.
• Authorized administrators can still modify or cancel the retention configuration during the allowed pre-lock period.

After permanent locking:

• The retention rule cannot be deleted.
• The retention duration cannot be shortened.
• The retention duration can only be increased where OCI permits it.
• Normal administrators cannot bypass the retention rule.
• The storage should be treated as immutable evidence storage.

Because permanent locking is effectively irreversible, complete testing before the lock date.

7. SEND OCI LOGGING TO OBJECT STORAGE

Recommended architecture:

OCI Logging
↓
Connector Hub
↓
SCCA-Log-Evidence Object Storage Bucket

OCI CONSOLE STEPS

1. Open OCI Console.
2. Go to Analytics & AI.
3. Open Connector Hub.
4. Select Create Connector.
5. Configure Source as:

Logging

6. Select the required:

• Compartments
• Log Groups
• Individual logs

7. Configure Target as:

Object Storage

8. Select:

Compartment:
EBLZ::Logging

Bucket:
SCCA-Log-Evidence

9. Enable Connector Hub service logging.
10. Create the connector.
11. Verify that logs successfully arrive in Object Storage.
12. CONNECTOR HUB IAM POLICY

Connector Hub requires permission to write objects into the evidence bucket.

Example:

Allow any-user to manage objects in compartment EBLZ:Logging
where all {
request.principal.type=‘serviceconnector’,
target.bucket.name=‘SCCA-Log-Evidence’,
request.principal.compartment.id=’<SERVICE_CONNECTOR_COMPARTMENT_OCID>’
}

Replace:

<SERVICE_CONNECTOR_COMPARTMENT_OCID>

with the actual compartment OCID containing the Service Connector.

Additional policies may be required so the Connector Hub service principal can read the source logs.

9. SEPARATION OF DUTIES

Do not allow the same administrator group to control everything.

Separate:

• Logging administration
• Connector Hub administration
• Evidence ingestion
• Object Storage administration
• Retention-rule administration
• Permanent retention locking

Recommended groups:

Log-Evidence-Admins

Responsibilities:

• Manage logging pipelines.
• Manage Connector Hub.
• Monitor evidence delivery.
• Manage approved Object Storage operational functions.

Retention-Custodians

Responsibilities:

• Create retention rules.
• Approve retention periods.
• Modify retention rules before locking.
• Permanently lock retention rules.
• Perform retention-specific custody operations.

Security-Auditors

Responsibilities:

• Read security logs.
• Review evidence.
• Review retention configuration.
• Verify compliance.
• No deletion or retention-rule administration.

Auditor-Exchange-Admins

Responsibilities:

• Manage approved evidence exchange with the separate Auditor tenancy.
• No unrestricted control of retention locking.

10. RETENTION CUSTODIAN IAM

Example restricted policy:

Allow group Retention-Custodians to manage buckets
in compartment EBLZ:Logging
where any {
request.permission=‘BUCKET_UPDATE’,
request.permission=‘RETENTION_RULE_MANAGE’,
request.permission=‘RETENTION_RULE_LOCK’
}

Do not give general application administrators retention-lock permissions.

11. AVOID BROAD OBJECT STORAGE ADMINISTRATION

Avoid giving Log-Evidence-Admins unrestricted:

manage object-family

unless there is a specific approved requirement.

Instead separate permissions for:

• Evidence ingestion
• Bucket administration
• Object read access
• Object write access
• Retention-rule management
• Retention-rule locking
• Evidence auditing

12. VALIDATION BEFORE PERMANENT LOCK

Before the lock becomes permanent, verify:

• OCI logs successfully reach Object Storage.
• Connector Hub is healthy.
• Connector Hub service logging works.
• Audit logs are captured.
• Object events are generated.
• Evidence objects can be retrieved.
• Objects protected by retention cannot be deleted.
• KMS encryption works if customer-managed keys are used.
• CSSP evidence collection works.
• Security Auditors can read required evidence.
• Cross-tenancy Auditor workflows work.
• SIEM integration works.
• Lifecycle policies do not conflict with retention.
• Terraform plan contains no unexpected deletion or replacement.
• Backup and evidence recovery procedures are documented.
• IAM separation of duties has been tested.

Only after these checks pass should the retention lock become permanent.

13. LIFECYCLE POLICY WARNING

Do not configure an Object Storage lifecycle deletion policy that attempts to delete evidence before the retention period expires.

Example to avoid:

Retention:
365 days

Lifecycle Delete:
90 days

This creates conflicting behavior.

Recommended configuration:

Retention:
365 days

Lifecycle Delete:
365 days or greater, if automatic deletion is actually required.

For long-term evidence, lifecycle deletion may be disabled entirely depending on compliance requirements.

14. RECOMMENDED FINAL SCCA CONFIGURATION

COMPARTMENT

EBLZ::Logging

BUCKET 1

Name:
SCCA-Log-Evidence

Visibility:
Private

Emit Object Events:
Enabled

Retention:

SCCA-Log-Retention::365::DAYS::<LOCK_DATE>

BUCKET 2

Name:
SCCA-CSSP-Evidence

Visibility:
Private

Emit Object Events:
Enabled

Retention:

SCCA-CSSP-Retention::365::DAYS::<LOCK_DATE>

RECOMMENDED GROUPS

Log-Evidence-Admins

Retention-Custodians

Security-Auditors

Auditor-Exchange-Admins

15. RECOMMENDED DEPLOYMENT ORDER

Step 1:
Create EBLZ::Logging compartment.

Step 2:
Create IAM groups.

Step 3:
Create IAM policies.

Step 4:
Create SCCA-Log-Evidence bucket.

Step 5:
Create SCCA-CSSP-Evidence bucket.

Step 6:
Apply retention rules without allowing the permanent lock to become effective immediately.

Step 7:
Configure Connector Hub.

Step 8:
Configure service-principal IAM policies.

Step 9:
Enable logging and object events.

Step 10:
Validate log delivery.

Step 11:
Validate evidence retrieval.

Step 12:
Validate KMS access.

Step 13:
Test object deletion protection.

Step 14:
Validate CSSP workflow.

Step 15:
Validate Security Auditor access.

Step 16:
Validate cross-tenancy Auditor workflow.

Step 17:
Run Terraform plan.

Step 18:
Perform security/change-control approval.

Step 19:
Allow the scheduled retention lock date to take effect.

16. RETENTION LOCK CHANGE CONTROL

Permanent retention locking should be treated as a controlled security operation.

Before locking, require:

• Change-management approval
• Security approval
• Retention Custodian approval
• Compliance approval where required
• Confirmed retention period
• Successful evidence-ingestion testing
• Successful evidence-retrieval testing
• Confirmed KMS functionality
• Confirmed Auditor access
• Recorded lock date
• Documented testing results
• Documented rollback window before permanent lock

17. SCCA DESIGN PRINCIPLE

The final architecture should follow:

LOG PRODUCERS
↓
OCI LOGGING
↓
CONNECTOR HUB
↓
PRIVATE OBJECT STORAGE
↓
TIME-BOUND RETENTION
↓
PERMANENT RETENTION LOCK
↓
SECURITY AUDIT / CSSP / AUDITOR EVIDENCE

18. FINAL OBJECTIVE

The EBLZ::Logging environment becomes the centralized SCCA evidence archive.

Applications and administrators can generate logs, but they should not have the ability to destroy security evidence.

Logging administrators manage the logging pipeline.

Retention Custodians control evidence retention.

Security Auditors review evidence without modifying it.

Connector Hub automatically transfers logs into protected Object Storage.

Locked Object Storage retention provides the immutable evidence layer required for the security and compliance architecture.