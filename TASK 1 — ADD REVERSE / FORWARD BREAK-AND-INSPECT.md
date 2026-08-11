TASK 1 — ADD REVERSE / FORWARD BREAK-AND-INSPECT PROXY TIER IN THE OCI HUB VIA NETWORK FIREWALL POLICY

OBJECTIVE

Configure the OCI Hub Network Firewall to perform TLS break-and-inspect for:

1. Forward proxy traffic:
   OCI workloads/users → Internet

2. Reverse/inbound inspection traffic:
   Internet or on-premises → OCI applications

The firewall decrypts TLS traffic, inspects it using the firewall security policy, and then forwards/re-encrypts the traffic.

IMPORTANT

Before enabling TLS inspection, first make sure traffic already routes successfully through the OCI Network Firewall in both directions.

The firewall path must be symmetric.

FORWARD FLOW

Spoke Workload
↓
DRG
↓
Hub VCN
↓
OCI Network Firewall
↓
TLS Decryption / Inspection
↓
NAT Gateway or Internet Gateway
↓
Internet


INBOUND / REVERSE FLOW

Internet or On-Premises
↓
IGW / DRG
↓
Hub VCN
↓
OCI Network Firewall
↓
TLS Decryption / Inspection
↓
Load Balancer / Application
↓
Workload Spoke


==================================================
PART A — MANUAL CONFIGURATION
==================================================

STEP 1 — VERIFY THE OCI NETWORK FIREWALL

In the OCI Console go to:

Identity & Security
→ Network Firewall
→ Firewalls

Confirm that the following already exist:

• Hub VCN
• Dedicated firewall subnet
• OCI Network Firewall
• Network Firewall Policy
• Firewall private IP address

Record:

Firewall Name:
____________________________

Firewall OCID:
____________________________

Firewall Policy Name:
____________________________

Firewall Policy OCID:
____________________________

Firewall Private IP:
____________________________


STEP 2 — VERIFY ROUTING THROUGH THE FIREWALL

Before configuring TLS inspection, verify normal traffic traverses the firewall.

FORWARD ROUTING

Spoke
→ DRG
→ Hub VCN
→ Network Firewall
→ NAT Gateway
→ Internet

RETURN ROUTING

Internet
→ NAT Gateway
→ Network Firewall
→ DRG
→ Spoke

INBOUND ROUTING

Internet / On-Prem
→ IGW / DRG
→ Network Firewall
→ Application

RETURN

Application
→ Network Firewall
→ DRG / IGW
→ Client

Check:

• Spoke subnet route tables
• DRG route tables
• Hub route tables
• Firewall subnet route tables
• NAT Gateway routing
• Internet Gateway routing

Do not enable TLS decryption until basic routing through the firewall works.


STEP 3 — CREATE OR IDENTIFY OCI VAULT

Recommended location:

EBLZ
└── VDSS
    └── Security

Go to:

Identity & Security
→ Key Management & Secret Management
→ Vault

Create or use an existing security Vault.

Recommended Vault name:

SCCA-Network-Security-Vault


STEP 4 — CREATE A SYMMETRIC VAULT KEY

Inside the Vault create:

SCCA-NFW-Secret-Key

Key type:

Symmetric

Do not use an asymmetric key for the Network Firewall TLS certificate secrets.


STEP 5 — CREATE FORWARD PROXY CERTIFICATE

This certificate is used for traffic going:

OCI Workload
→ Firewall
→ Internet

Recommended certificate name:

SCCA-NFW-Forward-CA

This should preferably be issued through the organization's enterprise PKI.

The certificate must be trusted by internal systems that will use forward TLS inspection.

Linux and Windows endpoints must trust this CA or they will receive certificate errors.


STEP 6 — CREATE INBOUND INSPECTION CERTIFICATE

Create or import the certificate/private key associated with the protected application.

Example:

application.example.mil

This certificate is used when the firewall decrypts inbound TLS connections to the application.


STEP 7 — STORE THE CERTIFICATES IN OCI VAULT SECRETS

Create two Vault secrets:

SCCA-NFW-Forward-Proxy-Cert

SCCA-NFW-Inbound-Inspection-Cert

Use Plain-Text secret format.

The certificate secret should contain the certificate chain and private key.

Example structure:

{
  "caCertOrderedList": [
    "-----BEGIN CERTIFICATE-----\nROOT_CA\n-----END CERTIFICATE-----",
    "-----BEGIN CERTIFICATE-----\nINTERMEDIATE_CA\n-----END CERTIFICATE-----"
  ],
  "certKeyPair": {
    "cert": "-----BEGIN CERTIFICATE-----\nCERTIFICATE\n-----END CERTIFICATE-----",
    "key": "-----BEGIN PRIVATE KEY-----\nPRIVATE_KEY\n-----END PRIVATE KEY-----"
  }
}


STEP 8 — ALLOW THE FIREWALL POLICY TO READ THE VAULT SECRET

Create an IAM policy.

Example:

Allow any-user to read secret-family in compartment EBLZ:VDSS:Security
where ALL {
request.principal.type='networkfirewallpolicy',
request.principal.id='<NETWORK_FIREWALL_POLICY_OCID>'
}

Replace:

<NETWORK_FIREWALL_POLICY_OCID>

with the real firewall policy OCID.


STEP 9 — CREATE FORWARD PROXY MAPPED SECRET

Go to:

Network Firewall Policy
→ TLS Decryption
→ Mapped Secrets
→ Create Mapped Secret

Configure:

Name:
SCCA-Forward-Proxy-Secret

Type:
SSL_FORWARD_PROXY

Source:
OCI Vault

Vault:
SCCA-Network-Security-Vault

Secret:
SCCA-NFW-Forward-Proxy-Cert

Select the active secret version.


STEP 10 — CREATE INBOUND INSPECTION MAPPED SECRET

Go to:

Network Firewall Policy
→ TLS Decryption
→ Mapped Secrets
→ Create Mapped Secret

Configure:

Name:
SCCA-Inbound-Inspection-Secret

Type:
SSL_INBOUND_INSPECTION

Vault:
SCCA-Network-Security-Vault

Secret:
SCCA-NFW-Inbound-Inspection-Cert


STEP 11 — CREATE FORWARD TLS DECRYPTION PROFILE

Go to:

Network Firewall Policy
→ TLS Decryption
→ Decryption Profiles
→ Create

Name:

SCCA-Forward-Decrypt-Profile

Type:

SSL_FORWARD_PROXY

Recommended security options:

Block expired certificate:
ON

Block untrusted issuer:
ON

Block unsupported cipher:
ON

Block unsupported TLS version:
ON

Block traffic if firewall does not have decryption capacity:
ON

The last option is important for fail-closed operation.


STEP 12 — CREATE INBOUND TLS DECRYPTION PROFILE

Create:

SCCA-Inbound-Decrypt-Profile

Type:

SSL_INBOUND_INSPECTION

Recommended:

Block unsupported cipher:
ON

Block unsupported TLS version:
ON

Block traffic if firewall has insufficient decryption resources:
ON


STEP 13 — CREATE ADDRESS LIST FOR INTERNAL SPOKES

Go to:

Network Firewall Policy
→ Address Lists
→ Create Address List

Name:

SCCA-Spoke-Networks

Type:

IP

Add the actual OCI workload CIDRs.

Example only:

10.10.0.0/16
10.20.0.0/16
10.30.0.0/16

Use your real network CIDRs.


STEP 14 — CREATE ADDRESS LIST FOR PROTECTED APPLICATIONS

Create another address list.

Name:

SCCA-Protected-Inbound-Apps

Type:

IP

Add:

• Load Balancer private IPs
• Application VIPs
• Protected application CIDRs

Example:

10.100.10.20/32


STEP 15 — CREATE FORWARD BREAK-AND-INSPECT RULE

Go to:

Network Firewall Policy
→ TLS Decryption
→ Decryption Rules
→ Create

Configure:

Name:
SCCA-Forward-TLS-Inspect

Source:
SCCA-Spoke-Networks

Destination:
Any or approved Internet destinations

Action:
DECRYPT

Decryption Profile:
SCCA-Forward-Decrypt-Profile

Mapped Secret:
SCCA-Forward-Proxy-Secret


Traffic flow becomes:

Internal workload
↓
Firewall
↓
TLS decrypted
↓
Security inspection
↓
TLS re-encrypted
↓
Internet


STEP 16 — CREATE INBOUND / REVERSE INSPECTION RULE

Create:

Name:
SCCA-Inbound-TLS-Inspect

Source:
Approved external/on-prem networks or Any if appropriate

Destination:
SCCA-Protected-Inbound-Apps

Action:
DECRYPT

Decryption Profile:
SCCA-Inbound-Decrypt-Profile

Mapped Secret:
SCCA-Inbound-Inspection-Secret


Traffic flow:

External client
↓
Firewall
↓
TLS decrypted
↓
Threat/security inspection
↓
Protected application


STEP 17 — CREATE NO-DECRYPT EXCEPTIONS

Some applications may fail when TLS interception is enabled.

Create an exception rule above the general decrypt rules.

Example:

Name:
SCCA-NoDecrypt-Exceptions

Action:
NO_DECRYPT

Use this only for approved destinations such as:

• Certificate-pinned applications
• Approved government services
• Applications that technically cannot support interception

Recommended decryption rule order:

1. NO_DECRYPT approved exceptions
2. Inbound TLS inspection
3. Forward TLS proxy inspection

Do not begin by decrypting all traffic in production.


STEP 18 — VERIFY SECURITY RULES

After decryption, normal firewall security rules must inspect and allow/drop the traffic.

Review:

Network Firewall Policy
→ Security Rules

Confirm rules exist for:

• Allowed outbound HTTPS
• Allowed inbound HTTPS
• Threat inspection
• Intrusion detection/prevention
• URL filtering if used
• Application controls
• Logging

Make sure there is not an accidental broad Allow All rule bypassing your security controls.


==================================================
PART B — TERRAFORM / SCRIPT AUTOMATION
==================================================

After manually validating the design in Dev/Test, automate it using Terraform.

Example structure:


VARIABLES

variable "firewall_policy_ocid" {}

variable "forward_secret_ocid" {}

variable "inbound_secret_ocid" {}


FORWARD PROXY MAPPED SECRET

resource "oci_network_firewall_network_firewall_policy_mapped_secret" "forward" {

  name = "SCCA-Forward-Proxy-Secret"

  network_firewall_policy_id = var.firewall_policy_ocid

  source = "OCI_VAULT"

  type = "SSL_FORWARD_PROXY"

  vault_secret_id = var.forward_secret_ocid

  version_number = 1
}


INBOUND INSPECTION MAPPED SECRET

resource "oci_network_firewall_network_firewall_policy_mapped_secret" "inbound" {

  name = "SCCA-Inbound-Inspection-Secret"

  network_firewall_policy_id = var.firewall_policy_ocid

  source = "OCI_VAULT"

  type = "SSL_INBOUND_INSPECTION"

  vault_secret_id = var.inbound_secret_ocid

  version_number = 1
}


FORWARD DECRYPTION PROFILE

resource "oci_network_firewall_network_firewall_policy_decryption_profile" "forward" {

  name = "SCCA-Forward-Decrypt-Profile"

  network_firewall_policy_id = var.firewall_policy_ocid

  type = "SSL_FORWARD_PROXY"

  is_expired_certificate_blocked = true

  is_untrusted_issuer_blocked = true

  is_unsupported_cipher_blocked = true

  is_unsupported_version_blocked = true

  is_out_of_capacity_blocked = true
}


INBOUND DECRYPTION PROFILE

resource "oci_network_firewall_network_firewall_policy_decryption_profile" "inbound" {

  name = "SCCA-Inbound-Decrypt-Profile"

  network_firewall_policy_id = var.firewall_policy_ocid

  type = "SSL_INBOUND_INSPECTION"

  is_unsupported_cipher_blocked = true

  is_unsupported_version_blocked = true

  is_out_of_capacity_blocked = true
}


SPOKE ADDRESS LIST

resource "oci_network_firewall_network_firewall_policy_address_list" "spokes" {

  name = "SCCA-Spoke-Networks"

  network_firewall_policy_id = var.firewall_policy_ocid

  type = "IP"

  addresses = [
    "10.10.0.0/16",
    "10.20.0.0/16",
    "10.30.0.0/16"
  ]
}


PROTECTED APPLICATION ADDRESS LIST

resource "oci_network_firewall_network_firewall_policy_address_list" "protected_apps" {

  name = "SCCA-Protected-Inbound-Apps"

  network_firewall_policy_id = var.firewall_policy_ocid

  type = "IP"

  addresses = [
    "10.100.10.20/32"
  ]
}


FORWARD TLS INSPECTION RULE

resource "oci_network_firewall_network_firewall_policy_decryption_rule" "forward" {

  name = "SCCA-Forward-TLS-Inspect"

  network_firewall_policy_id = var.firewall_policy_ocid

  action = "DECRYPT"

  condition {

    source_address = [
      oci_network_firewall_network_firewall_policy_address_list.spokes.name
    ]
  }

  decryption_profile =
  oci_network_firewall_network_firewall_policy_decryption_profile.forward.name

  secret =
  oci_network_firewall_network_firewall_policy_mapped_secret.forward.name
}


INBOUND TLS INSPECTION RULE

resource "oci_network_firewall_network_firewall_policy_decryption_rule" "inbound" {

  name = "SCCA-Inbound-TLS-Inspect"

  network_firewall_policy_id = var.firewall_policy_ocid

  action = "DECRYPT"

  condition {

    destination_address = [
      oci_network_firewall_network_firewall_policy_address_list.protected_apps.name
    ]
  }

  decryption_profile =
  oci_network_firewall_network_firewall_policy_decryption_profile.inbound.name

  secret =
  oci_network_firewall_network_firewall_policy_mapped_secret.inbound.name
}


==================================================
PART C — TERRAFORM VALIDATION
==================================================

Run:

terraform fmt

terraform validate

terraform plan


Review the plan carefully.

Make sure Terraform is NOT:

• Replacing the production firewall unexpectedly
• Deleting existing security rules
• Replacing route tables
• Deleting existing address lists
• Removing existing firewall policies

Only after plan approval run:

terraform apply


==================================================
PART D — TEST FORWARD BREAK-AND-INSPECT
==================================================

From an approved OCI workload run:

curl -Iv https://www.oracle.com

Expected:

• HTTPS connection succeeds
• Traffic passes through the Network Firewall
• Firewall performs TLS inspection
• Client trusts the enterprise/firewall certificate chain

If the client receives:

certificate verify failed

then the forward-proxy CA likely has not been installed into the client's trusted CA store.


==================================================
PART E — TEST INBOUND / REVERSE INSPECTION
==================================================

From an approved external or on-premises test host run:

curl -Iv https://<PROTECTED_APPLICATION_FQDN>

Expected:

• Connection succeeds
• Traffic passes through the Hub firewall
• TLS inspection rule is hit
• Application remains reachable


==================================================
PART F — VERIFY OCI NETWORK FIREWALL METRICS
==================================================

Go to:

OCI Console
→ Network Firewall
→ Firewall
→ Metrics

Verify:

• Decryption Rule Hit Count increases
• Forward rule receives hits
• Inbound inspection rule receives hits
• No unexpected TLS/decryption failures
• No firewall capacity errors


==================================================
PART G — ENABLE LOGGING
==================================================

Enable Network Firewall logs.

Capture at least:

• Traffic logs
• Threat logs
• Decryption-related events
• Rule hits
• Denied traffic

Forward these logs to the centralized logging architecture:

Network Firewall
↓
OCI Logging
↓
Connector Hub
↓
EBLZ::Logging
↓
SCCA-Log-Evidence
↓
Locked Object Storage Retention


==================================================
PART H — REQUIRED EVIDENCE FOR TASK COMPLETION
==================================================

Capture screenshots or exports showing:

1. Hub Network Firewall exists.

2. Firewall Policy attached to the firewall.

3. Forward Proxy mapped secret.

4. Inbound Inspection mapped secret.

5. Forward Proxy decryption profile.

6. Inbound Inspection decryption profile.

7. SCCA-Spoke-Networks address list.

8. SCCA-Protected-Inbound-Apps address list.

9. Forward TLS inspection rule.

10. Inbound TLS inspection rule.

11. NO_DECRYPT exception rules if used.

12. Hub/spoke route tables proving symmetric routing.

13. NAT/IGW routing.

14. Successful outbound curl test.

15. Successful inbound curl test.

16. Decryption Rule Hit Count.

17. Network Firewall traffic/threat logs.

18. Terraform plan if deployment was automated.

19. Change/CRQ approval for production implementation.


==================================================
TASK COMPLETION CRITERIA
==================================================

Task 1 is COMPLETE only when:

[ ] Forward proxy TLS inspection is configured.

[ ] Inbound/reverse TLS inspection is configured.

[ ] Vault certificates and secrets are configured.

[ ] Firewall Policy can access the required Vault secrets.

[ ] Traffic follows the Hub Network Firewall.

[ ] Routing is symmetric.

[ ] Approved NO_DECRYPT exceptions are configured.

[ ] Security inspection occurs after TLS decryption.

[ ] Forward test succeeds.

[ ] Inbound test succeeds.

[ ] Decryption rule hits are visible.

[ ] Network Firewall logging is enabled.

[ ] Evidence screenshots have been captured.

[ ] Terraform plan has been reviewed if automation is used.

[ ] Production change/CRQ approval is documented.


FINAL RESULT

OCI Hub now provides centralized forward and inbound/reverse TLS break-and-inspect capability.

Forward:

OCI Workloads
→ Hub Firewall
→ TLS Break/Inspect
→ Internet

Inbound:

Internet / On-Prem
→ Hub Firewall
→ TLS Break/Inspect
→ OCI Applications

This provides centralized encrypted-traffic inspection while keeping firewall administration, certificates, routing, security policy, and evidence under the SCCA security architecture.