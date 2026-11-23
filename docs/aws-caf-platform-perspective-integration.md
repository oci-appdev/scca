# AWS CAF Platform Perspective — Integration with Government Cloud Discovery

> **Document version:** 1.0 · **Date:** 2026-11-23  
> **Status:** Methodology and question mappings prepared; application-team evidence and authorization remain unverified.  
> **Companion documents:** [Microsoft CAF 136-question mapping](cloud-adoption-framework-government-cloud-discovery-mapping.md) · [Discovery questionnaire](cloud-migration-application-discovery-questionnaire.md) · [Answer guide](government-cloud-migration-discovery-answer-guide-and-comparison.md).  
> **Official primary source:** [AWS CAF Platform perspective (PDF)](https://docs.aws.amazon.com/pdfs/prescriptive-guidance/latest/aws-caf-platform-perspective/aws-caf-platform-perspective.pdf)

## Purpose and guardrails

This is a **multi-framework, cloud-vendor-neutral assessment**. It complements Microsoft CAF's seven phases (**Strategy, Plan, Ready, Adopt, Govern, Secure, Manage**) with AWS CAF's six perspectives (**Business, People, Governance, Platform, Security, Operations**), and adds detailed capability maturity checks from the AWS **Platform** perspective.

The AWS Platform document covers only **one of AWS CAF's six perspectives**; it must not be described as full coverage of Business, People, Governance, Security or Operations. The original AWS guidance provides **Start → Advance → Excel** maturity patterns. Our evidence checklist is an adaptation of those patterns for government workload assessment, **not an official AWS certification or approved security-control baseline**.

No cloud vendor, service, impact-level environment, application ATO, or migration disposition has been approved. All application-specific requirements and government-region service eligibility require source evidence and responsible-owner approval.

## AWS Platform — 7 capabilities and maturity evidence

| AWS Platform capability | Start evidence focus | Advance evidence focus | Excel evidence focus | Microsoft CAF related phases | Official reference |
|---|---|---|---|---|---|
| **Platform Architecture** | Accounts/projects/compartments; preventive controls; network connectivity, IPAM, DNS and observability. | Detective guardrails; service onboarding; standardized reference patterns. | Automated remediation, policy feedback and financial accountability. | Ready, Govern, Secure | [AWS guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/platform-arch.html) |
| **Platform Engineering** | Hardened landing zone, federation, centralized logging and network, baseline policies. | IaC, approved images, credentials, endpoint security and shared observability. | Automated identities, threat analysis, effective permission review and platform KPIs. | Ready, Secure, Manage | [AWS guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/platform-eng.html) |
| **Data Architecture** | Data domains and zones; data classification, access, retention and recovery. | Data contracts, metadata/lineage, portable analytics and compatibility. | Reusable data patterns, consolidated analytics when justified, DataOps governance. | Plan, Ready, Secure | [AWS guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/data-arch.html) |
| **Data Engineering** | Inventory ingestion patterns, sources, transformations and data availability. | Near-real-time processing where needed, reconciliation, validation and governed catalog access. | Governed reusable pipelines, DataOps and data-product quality/reliability metrics. | Plan, Adopt, Manage | [AWS guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/data-eng.html) |
| **Provisioning and Orchestration** | Curated catalog, approved templates/defaults and provisioning approval. | Self-service with security entitlements, quota and cost controls. | ITSM/procurement integration, catalog versioning and lifecycle/drift controls. | Ready, Govern, Adopt | [AWS guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/provisioning.html) |
| **Modern Application Development** | Document workload disposition, state/dependencies, supported compute and database patterns. | Improve API modularity, fault tolerance, testability and observability when justified. | Continuously optimize services and resilience and evaluate AI only where authorized. | Plan, Adopt, Manage | [AWS guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/modern-apps.html) |
| **Continuous Integration and Delivery** | Version control, build/test/deploy workflow, change approvals, rollback. | Pipeline security/SBOM and provenance checks, quality gates and safer releases. | Telemetry-driven recovery, supply-chain assurance, advanced release practices. | Adopt, Secure, Manage | [AWS guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/ci-cd.html) |

### Workbook implementation and verification

The improved Excel workbook `Government_Cloud_Migration_Dual_CAF_Aligned_Assessment.xlsx` contains **15 worksheets** (10 original plus five added). The original 136 answers and government-cloud pros/cons are preserved.

| Added worksheet | Purpose | Scope / initial state |
|---|---|---|
| **AWS CAF Dashboard** | Formula-derived capability evidence and AWS perspective coverage | 136 questions mapped; 63 maturity checks; 0 approved |
| **AWS Platform Capabilities** | Seven capability definitions, accountable groups and security concerns | 7 capabilities; no maturity awarded |
| **AWS Maturity Tracker** | Evidence owner, status, priority, target date, approval link and gap per control | **63 checks**: 7 capabilities × 3 maturity levels × 3 sample controls |
| **AWS Question Crosswalk** | Each question's Microsoft CAF phase, AWS primary perspective and associated Platform capability; live links back to application-team answers/status | **136 questions** mapped to one of six perspectives; **131** also tied to a Platform capability; remaining **5** handled by other perspectives |
| **CAF Framework Integration** | Seven Microsoft phases vs relevant AWS perspectives/Platform capabilities, decision gates, security lens | 7 Microsoft phases + 6 AWS perspectives |

**Evidence-count interpretation:** "Mapped" means classification complete, **not validated**. Only an approved maturity check counts as approved. Start, Advance and Excel are progressively advanced practices; achieving Excel is **not a universal prerequisite for migration**.

### Crosswalk rules

1. **Microsoft CAF primary phase** indicates when the information is used for cloud adoption governance, readiness, migration, and ongoing operation.
2. **AWS CAF primary perspective** indicates the accountable organizational domain: Business, People, Governance, Platform, Security or Operations.
3. **AWS Platform capability association** is the most relevant of seven technical topics, if applicable. Non-Platform perspectives can still have a supporting platform technical dependency, but not all Business and People items should be forced into Platform.
4. **Government review** is separate from technical maturity: exact FedRAMP/DoD scope, agency authorization, data classification, export control, approved service/region, ATO boundary and audit evidence must be verified.
5. All application-team source answers remain authoritative in **Discovery & Answers**; the new crosswalk references the existing response, evidence, status and owner fields rather than creating independent second responses.

## Government cloud readiness / hard gates

| Gate | Minimum evidence | Why it must not be confused with maturity |
|---|---|---|
| Cloud authorization and data classification | Workload classification, required impact level, approved service/feature/region, agency ISSO/AO and authorization strategy | A mature cloud platform does not issue a workload ATO |
| Platform segmentation and identity | Approved resource hierarchy, network/DNS/firewall flow, workforce identity and service IAM policies | Provider-specific endpoints and tenancy may differ |
| Database and application compatibility | Version/feature matrix, license and vendor support confirmation, load/recovery tests | A cloud-native pattern may not support a COTS/Oracle/SQL Server workload unchanged |
| Compute and GPU | Exact GPU/VRAM/driver, source data location, quotas and regional authorization | Commercial GPU catalogs are not evidence of GovCloud availability |
| Data and DR | Backups, retention, integrity, RTO/RPO and restoration tests | Government cross-region movement can be restricted |
| DevSecOps and operations | Trusted artifact/pipeline, EDR, SIEM, vulnerability scanning, incident and maintenance responsibilities | Government approvals and restricted CI/CD endpoints may apply |
| Financial and provider decision | 3–5 year TCO including licenses, network, egress, security, support and DR | Selecting a provider based on generic service pricing is insufficient |

## Immediate action register

| Priority | Activity | Owner | Status |
|---|---|---|---|
| P0 | Send 136-question survey and collect source evidence | Application owners | Awaiting input |
| P0 | Record agency data classification and ATO/impact-level requirements | ISSO / AO | Awaiting input |
| P0 | Determine current-state dependency, network, application and DB compatibility | Enterprise architecture / DBA | Awaiting input |
| P0 | Define Start-level platform baseline with owners and acceptance criteria | Platform / Security | Not assessed |
| P1 | Validate GovCloud service offerings and GPU regions/quota for **each** provider | Cloud architects / vendor teams | Not assessed |
| P1 | Compare cloud cost and migration waves including on-prem retain/replacement options | FinOps / PMO | Not assessed |
| P2 | Assess Advance/Excel maturity and operational improvement roadmap | Platform governance board | Not assessed |

## Official references

- [AWS CAF Platform Perspective — user-provided PDF](https://docs.aws.amazon.com/pdfs/prescriptive-guidance/latest/aws-caf-platform-perspective/aws-caf-platform-perspective.pdf)
- [AWS CAF organizational perspectives](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/overview.html)
- [Microsoft CAF overview — seven adoption phases](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview)

**Document owner:** Cloud adoption / enterprise architecture PMO · **Working status:** Vendor-neutral assessment, not cloud-provider selection or ATO approval.
