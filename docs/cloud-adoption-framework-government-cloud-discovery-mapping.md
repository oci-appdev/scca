# Cloud Adoption Framework (CAF) Mapping — Government Cloud Discovery

> **Version:** 1.0 · **Date:** 2026-11-20  
> **Status:** Framework mapping completed; workload data and approvals pending.  
> **Source of methodology:** [Microsoft Cloud Adoption Framework overview](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview).  
> **Existing artifacts:** [136-question questionnaire](cloud-migration-application-discovery-questionnaire.md) · [reference answer guide](government-cloud-migration-discovery-answer-guide-and-comparison.md).

## Scope and decision principles

Microsoft CAF defines seven adoption phases: **Strategy → Plan → Ready → Adopt**, with **Govern, Secure and Manage** treated as continuous operating disciplines throughout, not postponed to after cutover. Microsoft originally authors CAF for Azure; this project adapts its **decision structure** to compare **AWS GovCloud, Azure Government, eligible Google Cloud government services/Assured Workloads, OCI Government/Defense, and retain/retire/replace alternatives**. This mapping conveys **no cloud provider preference or authorization**.

**Do not treat this assessment as completed system discovery.** Real application-team answers, measurements, licenses, impact-level eligibility, security authority, RTO/RPO and TCO are still pending validation. A mapped question is not a completed or approved question.

## Phase definitions and deliverables

| Phase | Decision / key deliverable | Accountable functions | Official guide |
|---|---|---|---|
| **Strategy** | Why cloud / what outcomes justify investment? Approved mission objectives, decision rights, value baseline, capital/operating affordability. | Business sponsor, CIO, Finance | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/strategy/) |
| **Plan** | What people, portfolio and dependencies must be planned? Verified app/DB inventory, cross-app dependencies, RACI, license support and migration backlog. | PMO, app teams, DBA, EA | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/prepare-organization-for-cloud) |
| **Ready** | Can the cloud landing zone safely host the apps? Approved connectivity, DNS, IAM, logging, service quota, region and network foundations. | Platform, Network, IAM, Cloud architecture | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) |
| **Adopt** | How can workloads move or modernize? Chosen dispositions, migration waves, tests, cutover and rollback acceptance. | Migration team, app owner, change board | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/plan-migration) |
| **Govern** | How are use, budgets, risk and policy controlled? Resource/identity governance, tagging, quotas, FinOps and exceptions. | Governance board, FinOps, GRC | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/build-cloud-governance-team) |
| **Secure** | What can legally and securely run? Impact level/authorization boundary, SSP/ATO roadmap, encryption, EDR, logging and cross-boundary security. | ISSO/AO, Security/SOC | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/secure/overview) |
| **Manage** | How are operational goals maintained? Operations RACI, incident response, patching, DR restore proof and ongoing capacity/reliability reviews. | SRE, Operations, BC/DR | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/manage/ready-cloud-operations) |

## Workstream stage gates (33)

All gates start **Not assessed**. The accountable signatory must provide evidence before changing a gate to Approved; blocked gates prevent ready/go-live claims. Gates cover program-level decisions not adequately captured by an application-owner questionnaire.

| CAF phase | Gate ID | Evidence-based approval required |
|---|---|---|
| Strategy | STR-01 | Define documented cloud motivation versus retain/replace/retire |
| Strategy | STR-02 | Approve measurable business outcomes |
| Strategy | STR-03 | Name executive sponsor and decision authority |
| Strategy | STR-04 | Approve program funding and acceptable risk |
| Plan | PLN-01 | Validate application/server/DB inventory and owners |
| Plan | PLN-02 | Validate upstream/downstream dependency map |
| Plan | PLN-03 | Approve shared/cloud operating model and RACI |
| Plan | PLN-04 | Confirm training, vendor certification and license viability |
| Plan | PLN-05 | Approve prioritized workload backlog and TCO assumptions |
| Ready | RDY-01 | Approve provider-agnostic landing zone controls |
| Ready | RDY-02 | Test identity/federation, MFA and break-glass access |
| Ready | RDY-03 | Approve network, routing, DNS, private connectivity and TLS |
| Ready | RDY-04 | Demonstrate logging, EDR, SIEM, scanning and enforcement |
| Ready | RDY-05 | Confirm service-specific region, compliance, GPU and quota availability |
| Adopt | ADP-01 | Sign off on workload disposition |
| Adopt | ADP-02 | Complete representative migration/modernization pilot |
| Adopt | ADP-03 | Complete functional, data integrity, security and performance tests |
| Adopt | ADP-04 | Rehearse cutover, rollback and DNS changes |
| Adopt | ADP-05 | Obtain production go/no-go approvals |
| Govern | GOV-01 | Establish accountable cloud governance function |
| Govern | GOV-02 | Approve accounts, projects, naming, tags and resource standards |
| Govern | GOV-03 | Apply budgets, cost visibility, quota and spend controls |
| Govern | GOV-04 | Document exception process, risk register and compliance reporting |
| Secure | SEC-01 | Approve information classification, residency and personnel access |
| Secure | SEC-02 | Approve ATO/SSP boundary and authorization strategy |
| Secure | SEC-03 | Validate encryption, secrets and keys according to requirements |
| Secure | SEC-04 | Demonstrate response, scanning, monitoring and incident readiness |
| Secure | SEC-05 | Approve cross-boundary partner connectivity and security agreements |
| Manage | MGT-01 | Approve service/operations responsibilities and on-call SLAs |
| Manage | MGT-02 | Test alerting-to-incident and patch/change workflows |
| Manage | MGT-03 | Prove backups, restoration and RTO/RPO/DR testing |
| Manage | MGT-04 | Define performance/capacity/reliability continuous reviews |
| Manage | MGT-05 | Define recurring FinOps, compliance and risk reviews |

## Mapping of all 136 discovery questions to CAF

The **primary phase** indicates where evidence is initially collected; questions can support multiple phases. In the Excel workbook, the master tracker contains the approved actual answer, owner, evidence, priority and validation status, with a live CAF crosswalk to prevent contradictory copies.

| ID | CAF primary | Supporting phases | Discovery question |
|---|---|---|---|
| APP-01 | Plan | Strategy; Adopt | What is the application name, version, and primary business function? |
| APP-02 | Strategy | Adopt | Who are the business owner, technical owner, and application support team? |
| APP-03 | Plan | Strategy; Adopt | Is the application commercial off-the-shelf (COTS), custom-developed, open-source, or SaaS? |
| APP-04 | Plan | Strategy; Adopt | What environments exist (Development, Test, UAT, Staging, Production, DR)? |
| APP-05 | Plan | Strategy; Adopt | How many internal and external users access the application? |
| APP-06 | Strategy | Adopt | What is the business criticality of the application? |
| APP-07 | Strategy | Adopt | What are the required operating hours and availability SLA? |
| APP-08 | Strategy | Adopt | Is the application scheduled for retirement, replacement, modernization, or upgrade? |
| TECH-01 | Plan | Adopt; Ready | What is the current application architecture (monolithic, multi-tier, microservices, distributed)? |
| TECH-02 | Plan | Adopt; Ready | What programming languages, frameworks, and runtime versions are used? |
| TECH-03 | Plan | Adopt; Ready | What operating systems and versions are required? |
| TECH-04 | Plan | Adopt; Ready | What web servers, application servers, and middleware are used? |
| TECH-05 | Adopt | Ready | Does the application require physical servers, virtual machines, containers, or Kubernetes? |
| TECH-06 | Adopt | Ready | Does the application support horizontal and vertical scaling? |
| TECH-07 | Adopt | Ready | Are there hardcoded IP addresses, hostnames, file paths, or environment-specific configurations? |
| TECH-08 | Plan | Adopt; Ready | Are any components approaching end-of-life or end-of-support? |
| TECH-09 | Ready | Adopt | Are there technical restrictions preventing the application from operating in a cloud environment? |
| TECH-10 | Plan | Adopt; Ready | Does the software vendor certify or support cloud deployments? |
| DB-01 | Plan | Ready; Adopt; Manage | What database technologies, editions, and versions are used (Oracle, SQL Server, PostgreSQL, MySQL, MongoDB, etc.)? |
| DB-02 | Plan | Ready; Adopt; Manage | How many database instances exist across all environments? |
| DB-03 | Plan | Ready; Adopt; Manage | What is the current database size and anticipated annual growth? |
| DB-04 | Plan | Ready; Adopt; Manage | What are the current database CPU, memory, IOPS, throughput, and latency requirements? |
| DB-05 | Plan | Ready; Adopt; Manage | Is the database deployed as a standalone instance, cluster, or replicated environment? |
| DB-06 | Plan | Ready; Adopt; Manage | Does the application require database-specific features, extensions, stored procedures, or proprietary functionality? |
| DB-07 | Plan | Ready; Adopt; Manage | Are there database links or dependencies on external databases? |
| DB-08 | Manage | Ready; Adopt | What are the database backup, retention, replication, and recovery requirements? |
| DB-09 | Adopt | Ready; Manage | Can the application use a managed database service, or must the database remain self-managed? |
| DB-10 | Adopt | Ready; Manage | Are database engine changes or version upgrades supported? |
| DB-11 | Govern | Ready; Adopt; Manage | What database licensing and support agreements are currently in place? |
| DB-12 | Adopt | Ready; Manage | What is the maximum acceptable downtime and data loss during database migration? |
| INF-01 | Plan | Ready; Govern | How many physical servers and virtual machines support the application? |
| INF-02 | Plan | Ready; Govern | What are the current CPU, memory, operating system, and storage specifications for each server? |
| INF-03 | Plan | Ready; Govern | What are the average and peak CPU and memory utilization levels? |
| INF-04 | Ready | Govern | Are GPUs, specialized processors, or hardware accelerators required? |
| INF-05 | Plan | Ready; Govern | Are there hardware-specific dependencies or licensing restrictions? |
| INF-06 | Adopt | Ready; Govern | What hypervisor or virtualization platform is currently used? |
| INF-07 | Ready | Govern | Are dedicated hosts, bare-metal servers, or shared compute resources required? |
| INF-08 | Ready | Govern | What infrastructure capacity growth is anticipated over the next three to five years? |
| DATA-01 | Plan | Secure; Ready | What storage types are currently used (block, file, object, SAN, NAS)? |
| DATA-02 | Plan | Secure; Ready | What are the total storage capacity, current utilization, and annual growth rate? |
| DATA-03 | Plan | Secure; Ready | What are the required storage IOPS, throughput, and latency? |
| DATA-04 | Plan | Secure; Ready | Does the application require shared file systems, NFS, SMB, or persistent volumes? |
| DATA-05 | Govern | Secure; Ready | What are the data retention, archival, and deletion requirements? |
| DATA-06 | Secure | Ready | What data classification levels apply to the application? |
| DATA-07 | Secure | Ready | Are there data residency, geographic, or sovereignty restrictions? |
| DATA-08 | Plan | Secure; Ready | What data must remain on-premises, if any, and why? |
| NET-01 | Ready | Secure; Adopt | What network segments, subnets, IP ranges, and VLANs are currently used? |
| NET-02 | Ready | Secure; Adopt | What inbound and outbound ports and protocols are required? |
| NET-03 | Ready | Secure; Adopt | What are the required network bandwidth and latency thresholds? |
| NET-04 | Secure | Adopt | Does the application require internet access or private connectivity only? |
| NET-05 | Ready | Secure; Adopt | What DNS, load balancer, proxy, and firewall dependencies exist? |
| NET-06 | Ready | Secure; Adopt | Does the application require connectivity to on-premises systems after migration? |
| NET-07 | Ready | Secure; Adopt | Are there third-party or external network connections? |
| NET-08 | Ready | Secure; Adopt | Are static IP addresses, IP allowlists, or specific network configurations required? |
| NET-09 | Govern | Secure; Adopt | What are the estimated daily and monthly inbound and outbound data transfer volumes? |
| DEP-01 | Plan | Adopt; Ready | What upstream and downstream applications depend on this application? |
| DEP-02 | Plan | Adopt; Ready | What internal and external APIs are utilized? |
| DEP-03 | Plan | Adopt; Ready | Does the application integrate with messaging systems, queues, or event-streaming platforms? |
| DEP-04 | Plan | Adopt; Ready | Are there dependencies on shared databases, file servers, or enterprise services? |
| DEP-05 | Plan | Adopt; Ready | What scheduled jobs, batch processes, and data pipelines exist? |
| DEP-06 | Plan | Adopt; Ready | Does the application integrate with external vendors or government systems? |
| DEP-07 | Adopt | Ready | Which dependent applications must migrate together? |
| DEP-08 | Manage | Adopt; Ready | What happens if a dependent application becomes unavailable or experiences increased latency? |
| IAM-01 | Ready | Secure; Govern | What authentication and authorization mechanisms are currently used? |
| IAM-02 | Ready | Secure; Govern | Does the application integrate with Active Directory, LDAP, SAML, OIDC, or other identity providers? |
| IAM-03 | Secure | Govern | Are single sign-on and multifactor authentication required? |
| IAM-04 | Secure | Govern | What application roles, permissions, and privileged accounts exist? |
| IAM-05 | Secure | Govern | Does the application use service accounts, API keys, certificates, or machine identities? |
| IAM-06 | Secure | Govern | How are credentials, secrets, and certificates stored and rotated? |
| IAM-07 | Ready | Secure; Govern | Are there restrictions on changing the existing identity provider? |
| SEC-01 | Secure | Govern; Ready | What security and regulatory frameworks apply to the application? |
| SEC-02 | Secure | Govern; Ready | Does the application process PII, CUI, classified, financial, or other sensitive information? |
| SEC-03 | Secure | Govern; Ready | What encryption requirements exist for data at rest and in transit? |
| SEC-04 | Secure | Govern; Ready | Are customer-managed encryption keys or hardware security modules required? |
| SEC-05 | Secure | Govern; Ready | What endpoint protection, vulnerability scanning, and security monitoring tools are required? |
| SEC-06 | Secure | Govern; Ready | What logging, auditing, and security event retention requirements exist? |
| SEC-07 | Secure | Govern; Ready | Does the application currently have an Authorization to Operate (ATO), if applicable? |
| SEC-08 | Secure | Govern; Ready | Would cloud migration require a new ATO, authorization update, or security assessment? |
| SEC-09 | Secure | Govern; Ready | Are there applicable FedRAMP, FISMA, NIST, agency-specific, or other compliance requirements? |
| SEC-10 | Secure | Govern; Ready | Are public cloud services restricted by policy, contract, or data classification? |
| DR-01 | Manage | Ready; Secure | What is the required application availability percentage? |
| DR-02 | Strategy | Ready; Secure | What is the required Recovery Time Objective (RTO)? |
| DR-03 | Strategy | Ready; Secure | What is the required Recovery Point Objective (RPO)? |
| DR-04 | Manage | Ready; Secure | What high-availability architecture currently exists? |
| DR-05 | Ready | Secure | Is geographic redundancy or multi-region disaster recovery required? |
| DR-06 | Manage | Ready; Secure | What is the current backup frequency and retention period? |
| DR-07 | Manage | Ready; Secure | When was the last successful disaster recovery and backup restoration test? |
| DR-08 | Ready | Secure | Is active-active, active-passive, warm standby, or backup-and-restore recovery required? |
| DR-09 | Manage | Ready; Secure | What are the application failover and failback procedures? |
| PERF-01 | Plan | Adopt; Manage | What are the current average and peak transaction volumes? |
| PERF-02 | Strategy | Adopt; Manage | What are the required application response times? |
| PERF-03 | Plan | Adopt; Manage | Are there seasonal or unpredictable workload spikes? |
| PERF-04 | Plan | Adopt; Manage | What are the maximum concurrent user and connection requirements? |
| PERF-05 | Ready | Adopt; Manage | Are automated scaling capabilities supported or required? |
| PERF-06 | Adopt | Manage | What existing performance benchmarks and load-testing results are available? |
| DEV-01 | Govern | Secure | Where is the application source code maintained? |
| DEV-02 | Ready | Secure; Govern | What CI/CD tools and deployment pipelines are currently used? |
| DEV-03 | Ready | Secure; Govern | Is infrastructure provisioned manually or through Infrastructure as Code? |
| DEV-04 | Adopt | Secure; Govern | Does the application support automated deployment and rollback? |
| DEV-05 | Adopt | Secure; Govern | Are container images and software artifacts maintained in centralized repositories? |
| DEV-06 | Adopt | Secure; Govern | What automated testing capabilities exist? |
| DEV-07 | Govern | Secure | What deployment approvals and change management processes are required? |
| DEV-08 | Secure | Govern | Are application configuration and secrets separated from source code? |
| OPS-01 | Manage | Secure; Govern | What application and infrastructure monitoring tools are currently used? |
| OPS-02 | Manage | Secure; Govern | What centralized logging and alerting platforms are required? |
| OPS-03 | Manage | Secure; Govern | Who is responsible for application, operating system, database, and infrastructure support? |
| OPS-04 | Manage | Secure; Govern | Is 24/7 operational support required? |
| OPS-05 | Manage | Secure; Govern | What patching and maintenance schedules exist? |
| OPS-06 | Manage | Secure; Govern | What incident management and service management tools are used? |
| OPS-07 | Manage | Secure; Govern | Are there documented operational runbooks and troubleshooting procedures? |
| COST-01 | Strategy | Govern; Plan | What are the current annual infrastructure and application operating costs? |
| COST-02 | Plan | Govern | What software, database, and operating system licenses are required? |
| COST-03 | Govern | Plan | Are existing licenses eligible for cloud deployment or Bring Your Own License (BYOL)? |
| COST-04 | Govern | Plan | Are licenses based on users, processors, cores, servers, or consumption? |
| COST-05 | Govern | Plan | Would migration require new licenses or vendor support agreements? |
| COST-06 | Govern | Plan | Are there existing contractual commitments, renewal dates, or termination penalties? |
| COST-07 | Strategy | Govern; Plan | What budget constraints or financial requirements apply to the migration? |
| MIG-01 | Plan | Secure | Has the application previously been evaluated or tested in a cloud environment? |
| MIG-02 | Adopt | Plan; Secure | Can the application migrate without significant code or architecture changes? |
| MIG-03 | Plan | Secure | Can individual application components migrate independently? |
| MIG-04 | Plan | Secure | Are managed cloud services technically and contractually acceptable? |
| MIG-05 | Plan | Secure | What application changes would be required before migration? |
| MIG-06 | Adopt | Plan; Secure | What is the maximum acceptable migration downtime? |
| MIG-07 | Adopt | Plan; Secure | Are there maintenance windows or migration blackout periods? |
| MIG-08 | Govern | Plan; Secure | What are the major technical, operational, contractual, and security risks? |
| MIG-09 | Plan | Secure | What resources and personnel are available to support migration? |
| MIG-10 | Plan | Secure | What is the target migration timeline? |
| MIG-11 | Adopt | Plan; Secure | What testing, validation, and acceptance criteria must be satisfied before production cutover? |
| MIG-12 | Adopt | Plan; Secure | What rollback capabilities are required if migration is unsuccessful? |
| FUT-01 | Strategy | Plan; Govern | What current application or infrastructure challenges should cloud migration resolve? |
| FUT-02 | Strategy | Plan; Govern | What new capabilities or functionality are anticipated? |
| FUT-03 | Strategy | Plan; Govern | Are application modernization or containerization planned? |
| FUT-04 | Govern | Plan | Is cloud portability or avoidance of proprietary cloud services a requirement? |
| FUT-05 | Plan | Govern | Are hybrid-cloud or multi-cloud architectures required, optional, or restricted? |
| FUT-06 | Plan | Govern | Are there requirements for AI, machine learning, GPU computing, or advanced analytics? |
| FUT-07 | Strategy | Plan; Govern | What are the measurable business and technical success criteria for cloud migration? |

## Evidence-driven readiness and migration decision flow

1. **Strategy gate:** mission outcomes, measurable success and sponsorship are approved.
2. **Plan gate:** application/DB/VM inventory, dependencies, skills, licensing, risk and total cost assumptions are validated.
3. **Ready gate:** candidate landing zone can satisfy required government service scope, identity, DNS, private circuits, approved logging and capacity.
4. **Adopt gate:** each workload has a justified disposition (retain/rehost/replatform/refactor/replace/retire), tested performance, migration wave, cutoff criteria, fallback and business approval.
5. **Govern + Secure + Manage:** apply continuously before and after onboarding, including agency ATO approvals as applicable, risk exemptions, budget protection, backup tests and operations ownership.

**Status:** 136 questions mapped; no app responses validated; 0 of 33 stage gates approved. Any request for provider selection must be a distinct decision supported by application evidence, mandatory eligibility gates, pricing and agency security approval.

## Source

- [Microsoft CAF overview — seven phases](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/overview)
- [Microsoft CAF Plan — operating models, migration assessment and responsibilities](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/prepare-organization-for-cloud)
- [Microsoft CAF Secure — security spans all phases](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/secure/overview)
