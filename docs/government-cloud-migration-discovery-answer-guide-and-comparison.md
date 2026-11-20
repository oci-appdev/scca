# Government Cloud Migration — Discovery Answer Guide and Provider Comparison

**Date:** November 20, 2026  
**Status:** Reference answer guide; no application-specific current state verified  
**Companion:** [136-question cloud migration questionnaire](cloud-migration-application-discovery-questionnaire.md)

## Instructions and limitations

These are reference answers and the specific information needed to validate each response, **not factual answers describing the SCCA applications**. All application facts, RTO/RPO, certifications, costs, performance metrics, system boundaries and migration decisions remain **Unknown/Pending Application Team Validation** until documented evidence is provided. Do not cite this answer guide as evidence that a particular system is approved for any cloud.

Question statuses: **Unknown** (not provided), **Required** (must be decided/verified), **Recommended** (proposed approach, not policy), **Decision pending** (evaluate after discovery). Use N/A for inapplicable government-specific controls. Protect sensitive artifacts and secrets in approved restricted systems, not this Git repository.

## Part 1 — Answer Key: All 136 Questions

### 1. Application Overview

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| APP-01 | What is the application name, version, and primary business function? | Unknown; enter exact app name, version, CMDB ID and mission purpose. |
| APP-02 | Who are the business owner, technical owner, and application support team? | Unknown; assign accountable business owner, technical lead, DB owner, operations and ISSO contacts. |
| APP-03 | Is the application commercial off-the-shelf (COTS), custom-developed, open-source, or SaaS? | Unknown; identify COTS/custom/SaaS/open-source components and vendor support terms. |
| APP-04 | What environments exist (Development, Test, UAT, Staging, Production, DR)? | Unknown; inventory Dev/Test/UAT/Stage/Prod/DR, topology and data classification per environment. |
| APP-05 | How many internal and external users access the application? | Unknown; measure monthly active users, peak concurrency and external/service accounts. |
| APP-06 | What is the business criticality of the application? | Business owner must rank mission impact and criticality from a formal impact analysis. |
| APP-07 | What are the required operating hours and availability SLA? | Business owner must set uptime SLA, business hours and allowed maintenance windows. |
| APP-08 | Is the application scheduled for retirement, replacement, modernization, or upgrade? | Check retirement, modernization and vendor roadmap; avoid migrating an imminent retirement. |

### 2. Application Architecture and Technology Stack

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| TECH-01 | What is the current application architecture (monolithic, multi-tier, microservices, distributed)? | Document current architecture using a component diagram and distinguish stateful tiers. |
| TECH-02 | What programming languages, frameworks, and runtime versions are used? | Inventory exact programming language, runtime, framework and package versions. |
| TECH-03 | What operating systems and versions are required? | Inventory OS, kernel, version, architecture, image hardening and support end dates. |
| TECH-04 | What web servers, application servers, and middleware are used? | Inventory middleware, web/app server, proxy, brokers and versions. |
| TECH-05 | Does the application require physical servers, virtual machines, containers, or Kubernetes? | Record physical/VM/container/Kubernetes form factor; containerization is not required by default. |
| TECH-06 | Does the application support horizontal and vertical scaling? | Validate actual scaling behavior, state handling and shared sessions with load tests. |
| TECH-07 | Are there hardcoded IP addresses, hostnames, file paths, or environment-specific configurations? | Inventory hardcoded CIDRs, DNS, URLs, mounts, IP allowlists, certificates and paths. |
| TECH-08 | Are any components approaching end-of-life or end-of-support? | Flag unsupported/EOL runtime, OS, middleware and DB releases and plan remediation. |
| TECH-09 | Are there technical restrictions preventing the application from operating in a cloud environment? | Identify specialized hardware, device drivers, licensing, layer-2 and latency restrictions. |
| TECH-10 | Does the software vendor certify or support cloud deployments? | Obtain written vendor certification for exact app, OS, DB and proposed cloud platform. |

### 3. Database Requirements

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| DB-01 | What database technologies, editions, and versions are used (Oracle, SQL Server, PostgreSQL, MySQL, MongoDB, etc.)? | Inventory DB engine, edition, version, patch level, owner and environments. |
| DB-02 | How many database instances exist across all environments? | Count hosts, database instances, clusters, schemas and DR replicas by environment. |
| DB-03 | What is the current database size and anticipated annual growth? | Record used/allocated TB, logs, backup volume, daily writes and annual growth. |
| DB-04 | What are the current database CPU, memory, IOPS, throughput, and latency requirements? | Measure CPU/RAM, active sessions, IOPS, throughput, p95/p99 latency and peak demand. |
| DB-05 | Is the database deployed as a standalone instance, cluster, or replicated environment? | Document standalone, RAC/Always On/cluster/standby topology and quorum assumptions. |
| DB-06 | Does the application require database-specific features, extensions, stored procedures, or proprietary functionality? | Inventory proprietary SQL/features, extensions, stored code, Oracle options and dependencies. |
| DB-07 | Are there database links or dependencies on external databases? | Inventory DB links, remote joins, endpoints, authentication and cross-site latency. |
| DB-08 | What are the database backup, retention, replication, and recovery requirements? | Require encrypted, versioned and restorable backups; determine retention and test schedule. |
| DB-09 | Can the application use a managed database service, or must the database remain self-managed? | Select managed versus self-managed only after checking version, features, authorization and support. |
| DB-10 | Are database engine changes or version upgrades supported? | Engine/version changes require separate compatibility, migration and regression testing. |
| DB-11 | What database licensing and support agreements are currently in place? | Request exact licenses, support, core/OCPU entitlement and written BYOL/cloud approval. |
| DB-12 | What is the maximum acceptable downtime and data loss during database migration? | Define application-specific downtime/RPO; use backup, CDC or replication based on change rate. |

### 4. Infrastructure and Compute Requirements

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| INF-01 | How many physical servers and virtual machines support the application? | Inventory all VM/physical hosts and map to applications and environments. |
| INF-02 | What are the current CPU, memory, operating system, and storage specifications for each server? | Record vCPU/CPU topology, RAM, disks, NICs, OS, GPU and hardware reservations. |
| INF-03 | What are the average and peak CPU and memory utilization levels? | Collect 30–90 days of utilization percentiles and peaks, not provisioned capacity alone. |
| INF-04 | Are GPUs, specialized processors, or hardware accelerators required? | Record exact GPU model/equivalent, VRAM, CUDA/drivers, node count and software support. |
| INF-05 | Are there hardware-specific dependencies or licensing restrictions? | Identify HSM, USB, dongles, FPGA, local hardware and node-bound licenses. |
| INF-06 | What hypervisor or virtualization platform is currently used? | Inventory VMware/Hyper-V/KVM, VM image and export/conversion restrictions. |
| INF-07 | Are dedicated hosts, bare-metal servers, or shared compute resources required? | Prefer shared VM when eligible; use dedicated host/bare metal only for demonstrated needs. |
| INF-08 | What infrastructure capacity growth is anticipated over the next three to five years? | Forecast 3–5 year CPU/RAM/GPU, growth and DR headroom; verify regional quotas. |

### 5. Storage and Data Requirements

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| DATA-01 | What storage types are currently used (block, file, object, SAN, NAS)? | List SAN/NAS/file/block/object stores and access protocols by application. |
| DATA-02 | What are the total storage capacity, current utilization, and annual growth rate? | Measure used/allocated storage, replica/snapshot overhead, growth and retention. |
| DATA-03 | What are the required storage IOPS, throughput, and latency? | Record p95/p99 latency, IOPS, MB/s and peak mix by workload. |
| DATA-04 | Does the application require shared file systems, NFS, SMB, or persistent volumes? | Document NFS/SMB/POSIX, shared-write locking, mount paths and persistent volume behavior. |
| DATA-05 | What are the data retention, archival, and deletion requirements? | Data owner sets archive, legal hold, immutable retention and secure deletion rules. |
| DATA-06 | What data classification levels apply to the application? | Security/data owner classifies datasets (PII, CUI, FTI, ITAR, etc. as applicable). |
| DATA-07 | Are there data residency, geographic, or sovereignty restrictions? | Determine approved processing/storage regions, support access and sovereignty restrictions. |
| DATA-08 | What data must remain on-premises, if any, and why? | Document every keep-on-premises constraint with authority, reason and dependency. |

### 6. Networking and Connectivity

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| NET-01 | What network segments, subnets, IP ranges, and VLANs are currently used? | Inventory VLANs, CIDRs, routes, firewalls, NAT, egress and overlapping address blocks. |
| NET-02 | What inbound and outbound ports and protocols are required? | Create source/destination/protocol/port/owner firewall flow matrix. |
| NET-03 | What are the required network bandwidth and latency thresholds? | Measure bandwidth, RTT, jitter, packet loss and application latency requirements. |
| NET-04 | Does the application require internet access or private connectivity only? | Prefer restricted/private access when policy requires; approve necessary public egress explicitly. |
| NET-05 | What DNS, load balancer, proxy, and firewall dependencies exist? | Document authoritative/recursive DNS, split DNS, proxy, TLS, WAF and load balancer ownership. |
| NET-06 | Does the application require connectivity to on-premises systems after migration? | Identify remaining on-prem connections, bandwidth and latency; do not assume hybrid is needed. |
| NET-07 | Are there third-party or external network connections? | Inventory partner/agency interconnections, VPN/private circuits and change approvals. |
| NET-08 | Are static IP addresses, IP allowlists, or specific network configurations required? | Record static IP allowlists, DNS cutover requirements and endpoint/certificate changes. |
| NET-09 | What are the estimated daily and monthly inbound and outbound data transfer volumes? | Measure ingress/egress, AZ/region/DR transfer volumes to estimate network charges. |

### 7. Application Dependencies and Integrations

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| DEP-01 | What upstream and downstream applications depend on this application? | Create upstream/downstream dependency diagram with owners and business criticality. |
| DEP-02 | What internal and external APIs are utilized? | Inventory REST/SOAP/gRPC endpoints, versions, rate limits and auth protocols. |
| DEP-03 | Does the application integrate with messaging systems, queues, or event-streaming platforms? | Document queues, topics, brokers, delivery ordering and failure semantics. |
| DEP-04 | Are there dependencies on shared databases, file servers, or enterprise services? | List shared databases, file shares, directory, email and centralized services. |
| DEP-05 | What scheduled jobs, batch processes, and data pipelines exist? | Inventory batch jobs, ETL, schedulers, timing and cross-application file exchanges. |
| DEP-06 | Does the application integrate with external vendors or government systems? | Identify agency and vendor integrations plus MOU/ISA/security obligations. |
| DEP-07 | Which dependent applications must migrate together? | Group tightly coupled applications into migration waves; prove separation feasibility. |
| DEP-08 | What happens if a dependent application becomes unavailable or experiences increased latency? | Define retries, timeouts, degradation and data consistency when dependencies fail. |

### 8. Identity and Access Management

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| IAM-01 | What authentication and authorization mechanisms are currently used? | Inventory all identities, RBAC/ABAC, existing IdP and privileged access. |
| IAM-02 | Does the application integrate with Active Directory, LDAP, SAML, OIDC, or other identity providers? | Record AD/ADFS/LDAP/SAML/OIDC/Kerberos and federation/endpoint dependencies. |
| IAM-03 | Are single sign-on and multifactor authentication required? | Require policy-approved SSO, MFA and privileged phishing-resistant authentication where needed. |
| IAM-04 | What application roles, permissions, and privileged accounts exist? | Rebuild least privilege with separation of duties; avoid broad migrated admin roles. |
| IAM-05 | Does the application use service accounts, API keys, certificates, or machine identities? | Inventory service accounts, machine identities, token/cert use and rotation. |
| IAM-06 | How are credentials, secrets, and certificates stored and rotated? | Use approved secrets store, audit and rotation; never put secrets in Git. |
| IAM-07 | Are there restrictions on changing the existing identity provider? | Validate restrictions on federation changes, directory realm and hardware MFA. |

### 9. Security and Compliance

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| SEC-01 | What security and regulatory frameworks apply to the application? | Map applicable FISMA/NIST/FedRAMP, DoD IL, CJIS, IRS1075, HIPAA and ITAR rules, not blanket assumptions. |
| SEC-02 | Does the application process PII, CUI, classified, financial, or other sensitive information? | Record data classifications and PII/CUI/FTI/export-controlled handling obligations. |
| SEC-03 | What encryption requirements exist for data at rest and in transit? | Use encrypted at rest/in transit and policy-required FIPS-validated cryptography. |
| SEC-04 | Are customer-managed encryption keys or hardware security modules required? | Confirm need for customer-managed keys, BYOK, HSM and separation of duties. |
| SEC-05 | What endpoint protection, vulnerability scanning, and security monitoring tools are required? | Specify approved EDR, vulnerability scans, image hardening, patch SLAs and SIEM coverage. |
| SEC-06 | What logging, auditing, and security event retention requirements exist? | Centralize tamper-protected logs with approved retention and secure event export. |
| SEC-07 | Does the application currently have an Authorization to Operate (ATO), if applicable? | Verify existing agency system ATO, authorization boundary, POA&M and AO. |
| SEC-08 | Would cloud migration require a new ATO, authorization update, or security assessment? | ISSO/AO must decide required SSP updates, ATO/reassessment and inherited controls. |
| SEC-09 | Are there applicable FedRAMP, FISMA, NIST, agency-specific, or other compliance requirements? | Validate exact cloud service, feature, region and impact-level authorization scope. |
| SEC-10 | Are public cloud services restricted by policy, contract, or data classification? | Identify contractual/export-control and public-cloud restrictions before shortlisting. |

### 10. High Availability, Backup, and Disaster Recovery

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| DR-01 | What is the required application availability percentage? | Business owner specifies measurable uptime SLO; do not assume 99.9% fits every app. |
| DR-02 | What is the required Recovery Time Objective (RTO)? | Business owner defines maximum acceptable outage (RTO); not supplied. |
| DR-03 | What is the required Recovery Point Objective (RPO)? | Data owner defines maximum acceptable data loss (RPO); not supplied. |
| DR-04 | What high-availability architecture currently exists? | Document clustering, replicas, health checks and current single points of failure. |
| DR-05 | Is geographic redundancy or multi-region disaster recovery required? | Cross-region DR depends on data location, service availability, RTO/RPO and budget. |
| DR-06 | What is the current backup frequency and retention period? | Inventory backup cadence, encryption, retention, immutability and offsite access. |
| DR-07 | When was the last successful disaster recovery and backup restoration test? | Record date and results of latest actual restore/DR test and achieved objectives. |
| DR-08 | Is active-active, active-passive, warm standby, or backup-and-restore recovery required? | Compare active-active/passive, warm standby and restore based on approved objectives. |
| DR-09 | What are the application failover and failback procedures? | Document failover, fencing, rollback, DNS, data reconciliation and failback runs. |

### 11. Application Performance and Scalability

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| PERF-01 | What are the current average and peak transaction volumes? | Baseline average/p95/p99 and peak transactions, jobs and requests per second. |
| PERF-02 | What are the required application response times? | Define measured per-workflow p95/p99 response-time SLOs and user locations. |
| PERF-03 | Are there seasonal or unpredictable workload spikes? | Capture seasonal/fiscal peaks and traffic bursts with capacity headroom. |
| PERF-04 | What are the maximum concurrent user and connection requirements? | Measure concurrent users, API calls, DB connections and queue depth. |
| PERF-05 | Are automated scaling capabilities supported or required? | Use autoscaling only when app architecture supports stateless/controlled scaling. |
| PERF-06 | What existing performance benchmarks and load-testing results are available? | Maintain baseline load, soak and resilience test results; repeat post-migration. |

### 12. DevOps and Application Deployment

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| DEV-01 | Where is the application source code maintained? | Inventory source repository, code ownership, branch controls and build provenance. |
| DEV-02 | What CI/CD tools and deployment pipelines are currently used? | Record CI/CD runners, pipelines, scans, artifact repositories and access restrictions. |
| DEV-03 | Is infrastructure provisioned manually or through Infrastructure as Code? | Prefer reviewed IaC; defer Terraform/Bicep/CloudFormation choice until vendor decision. |
| DEV-04 | Does the application support automated deployment and rollback? | Define deploy and rollback procedure including stateful DB release constraints. |
| DEV-05 | Are container images and software artifacts maintained in centralized repositories? | Use approved signed/scanned images and track SBOM/CVE with authorized registries. |
| DEV-06 | What automated testing capabilities exist? | Document test automation scope and safe test-data strategy; expand missing tests. |
| DEV-07 | What deployment approvals and change management processes are required? | Preserve change approvals, release windows and audit evidence for the agency. |
| DEV-08 | Are application configuration and secrets separated from source code? | Externalize configuration and rotate secrets; prevent sensitive data in repositories. |

### 13. Monitoring and Operational Support

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| OPS-01 | What application and infrastructure monitoring tools are currently used? | Inventory APM, logs, DB/host metrics, dashboards and alert thresholds. |
| OPS-02 | What centralized logging and alerting platforms are required? | Define centralized logging, SIEM, paging ownership, retention and event routing. |
| OPS-03 | Who is responsible for application, operating system, database, and infrastructure support? | Assign RACI for app, DB, VM/container, OS, network, security and cloud operations. |
| OPS-04 | Is 24/7 operational support required? | Set operational hours, after-hours coverage and on-call escalation by SLA. |
| OPS-05 | What patching and maintenance schedules exist? | Document patch cadence, vulnerability SLAs, reboot and rollback windows. |
| OPS-06 | What incident management and service management tools are used? | Record ITSM/CMDB incident/problem/change tool integrations and ownership. |
| OPS-07 | Are there documented operational runbooks and troubleshooting procedures? | Require approved runbooks for deploy, restart, backup restore, certs and DR. |

### 14. Licensing and Financial Requirements

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| COST-01 | What are the current annual infrastructure and application operating costs? | Baseline all-in on-prem annual cost (hardware, licensing, power, facility, labor, network, DR). |
| COST-02 | What software, database, and operating system licenses are required? | Inventory OS, DB, app, EDR, monitoring and middleware contract renewals. |
| COST-03 | Are existing licenses eligible for cloud deployment or Bring Your Own License (BYOL)? | Confirm BYOL, core-count and cloud-region restrictions directly with licensors. |
| COST-04 | Are licenses based on users, processors, cores, servers, or consumption? | Record actual per-user/core/VM/OCPU/vCPU/storage/transaction license units. |
| COST-05 | Would migration require new licenses or vendor support agreements? | Identify added vendor support, marketplace, security and tooling licenses. |
| COST-06 | Are there existing contractual commitments, renewal dates, or termination penalties? | List end dates, minimum contracts, termination penalties and procurement lead time. |
| COST-07 | What budget constraints or financial requirements apply to the migration? | Model 3–5 year cloud TCO using Gov pricing, GPU, DR, storage, egress and staff. |

### 15. Cloud Migration Readiness

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| MIG-01 | Has the application previously been evaluated or tested in a cloud environment? | Review prior cloud pilots, constraints, vendor evidence and test results. |
| MIG-02 | Can the application migrate without significant code or architecture changes? | Rehost only if OS, middleware, network, license, security and performance fit. |
| MIG-03 | Can individual application components migrate independently? | Assess coupling and stateful boundaries; separate components only when supported. |
| MIG-04 | Are managed cloud services technically and contractually acceptable? | Use managed services only if compliant and technically/contractually supported. |
| MIG-05 | What application changes would be required before migration? | Maintain blockers/remediation backlog for version, DNS, IAM, DB and agents. |
| MIG-06 | What is the maximum acceptable migration downtime? | Obtain business-approved outage before selecting replication/cutover approach. |
| MIG-07 | Are there maintenance windows or migration blackout periods? | Inventory release freezes, audit windows and maintenance/change blackout periods. |
| MIG-08 | What are the major technical, operational, contractual, and security risks? | Maintain risks for ATO, vendor, DR, network, cost, data and program schedule. |
| MIG-09 | What resources and personnel are available to support migration? | Assign SMEs across application, DBA, infra, cyber, network, QA and AO. |
| MIG-10 | What is the target migration timeline? | Set dates only after provisioning, circuit, testing, license and ATO prerequisites. |
| MIG-11 | What testing, validation, and acceptance criteria must be satisfied before production cutover? | Write signed functional/data/security/performance/DR/UAT go-live exit criteria. |
| MIG-12 | What rollback capabilities are required if migration is unsuccessful? | Plan reversible cutover with DNS rollback, consistency check and no-return point. |

### 16. Future-State Requirements

| ID | Discovery question | Reference answer / validation method |
|---|---|---|
| FUT-01 | What current application or infrastructure challenges should cloud migration resolve? | Prioritize measurable current pain points and success metrics with stakeholders. |
| FUT-02 | What new capabilities or functionality are anticipated? | Document 3–5 year feature, support, integration, storage and user growth plans. |
| FUT-03 | Are application modernization or containerization planned? | Modernize or containerize only if benefit exceeds cost, risk and support hurdles. |
| FUT-04 | Is cloud portability or avoidance of proprietary cloud services a requirement? | Set portability requirement, exit plan, data export and accepted vendor lock-in. |
| FUT-05 | Are hybrid-cloud or multi-cloud architectures required, optional, or restricted? | Multi-cloud/hybrid should be justified by business need, not assumed. |
| FUT-06 | Are there requirements for AI, machine learning, GPU computing, or advanced analytics? | Record specific AI/GPU model, VRAM, framework, approved endpoint and usage needs. |
| FUT-07 | What are the measurable business and technical success criteria for cloud migration? | Business signs off measurable SLA, recovery, security, cost, performance and migration success. |

## Part 2 — Government Cloud: Pros and Cons

A government cloud is not automatically compliant for every workload. **Check the cloud service offering, exact service/feature, operating region, data flow, and required authorization impact level.** FedRAMP-certified services can provide inheritable controls; the agency still authorizes its own information system. DoD IL4/IL5 scope and conditional workload isolation must be checked separately. Classified IL6 has separate eligible environments and is not covered by a generic unclassified government cloud deployment.

| Platform / offering | Pros | Cons / limitations | Suitable candidate when… |
|---|---|---|---|
| **AWS GovCloud (US)** | Dedicated isolated US regions, stringent government-personnel controls, FedRAMP High and DoD IL scope, flexible VM/container/networking/IaC choices, breadth of services. | Separate partition with distinct credentials, endpoints and ARNs; linked commercial account for billing; some commercial AWS service features absent; egress, circuits, support and DR still cost money. | Application stacks suit AWS services and approved, region-specific product availability. |
| **Azure Government** | Dedicated US-government environment, screened US-person access commitment, strong fit to evaluate for .NET/Windows/SQL Server/AD/Entra/Microsoft administration; many gov-authorized core IaaS/PaaS services. | Separate identity/endpoint configuration; commercial service versions may lag or differ; some IL5 services require extra workload isolation; verify Microsoft integrations and Azure Government licensing/quotas. | Microsoft-centered workloads or existing identity/management tooling make integration attractive. |
| **Google Cloud + Assured Workloads** | Regulatory guardrails and US-region support/personnel controls; authorized GKE, analytics, AI, storage and infrastructure services; BigQuery/ML/Kubernetes strengths to evaluate. | Do **not** treat Assured Workloads as identical to a dedicated AWS/Azure government cloud partition; compliance coverage differs by service, feature, region and framework; certain models/AI services excluded or require special endpoints. | Containers, data analytics or ML fit authorized services and US data boundary policies. |
| **OCI US Government Cloud / OCI US Defense Cloud** | Oracle DB/Exadata fit to evaluate, OCI infrastructure/DR/network tools, government FedRAMP High and DoD IL environments; may fit existing Oracle investment. | **US Government Cloud = documented FedRAMP High / DISA IL4; US Defense Cloud = IL5**. Distinct realms, limited cross-realm subscriptions, government service/feature gaps and capacity/quotas; OCI US Government Cloud docs note some public DNS zone management limitations. | Oracle databases, licensing, existing OCI operations or dedicated database/GPU performance justify a complete comparison. |

### Government cloud advantages

- Inheritable security controls, approved service boundaries and personnel/data-residency assurances where applicable.
- Automation, managed compute/database services and elasticity can reduce physical hardware dependence.
- Provider-managed infrastructure and selectable fault domains/regions can improve resilience when architected and funded properly.
- Government procurement and compliance documentation can support agency security processes.

### Government cloud disadvantages

- ATO work remains; inherited FedRAMP authorization **does not authorize the migrated application**.
- Service features, new GPU shapes, AI models, regions, quotas and capacity may be different or unavailable.
- Procurement, restricted personnel, support agreements, identity realms and endpoint changes can increase complexity.
- Data egress, private connectivity, backup/DR, always-on GPU/DB, security, licensing and staff may raise five-year spend.
- Legacy middleware, DB features, IP/DNS dependencies and vendor certification can require rework.
- Provider/region failure still requires explicit DR architecture and tests; a second region is not automatic.

### Non-negotiable technical gates before cloud selection

| Gate | Must have |
|---|---|
| Security and ATO | Data category, cloud offering/service/region scope, ISSO/AO authorization approach, inherited control matrix and system boundary. |
| Application compatibility | Vendor-certified OS/runtime/DB/container versions, physical dependencies and required agents. |
| Database | Measured size/IOPS/latency; licensing/features; backup/replication; approved outage and RTO/RPO. |
| Networking | Complete traffic flow matrix, DNS ownership, private circuits, on-prem/external connections, latency and egress. |
| Compute and GPU | Count, model/equivalent, VRAM, GPU driver/CUDA, OS support and region-specific quota/capacity. |
| Operations | EDR, scanning, SIEM, access/federation, IaC, patching, DR and change control. |
| Cost and schedule | Gov-specific 3–5 year TCO, migration labor, license reviews, security authorization and cutover window. |

### Example technical baseline (subject to agency policy)

- **Servers:** Supported patched VMs with approved image hardening; containers/managed Kubernetes only if app stack and government cloud region support them.
- **Databases:** Keep exact Oracle/SQL Server/PostgreSQL/etc. version and proprietary feature requirements visible; select managed or self-managed after compatibility and compliance checks.
- **Security:** Classify data, encrypt rest/transit, enforce required FIPS-validated crypto, approved EDR and monitoring, MFA/federation, least privilege and controlled secrets.
- **Network:** Prefer private paths and least-required flows when mandated; plan DNS and certificate migrations before cutover.
- **Backups and DR:** Require tested restores, isolation and recovery plan; **do not assume any universal RTO/RPO target**.
- **Infrastructure:** Size with at least 30 days (ideally 90) of CPU/RAM/IOPS/bandwidth, transaction and GPU utilization, including peaks.
- **Modernization:** Do not require Kubernetes, PaaS, DB engine conversion or microservices unless justified by technical and business evidence.
- **Cost:** Estimate baseline on-prem total cost and full cloud run-rate plus migration/DR/egress/security/license/operational costs.

### Specialized considerations for document processing / graph analytics workloads

For container-hosted or GPU-intensive applications, obtain the vendor's Kubernetes/container runtime and RHEL support matrix; minimum and target GPU/VRAM/CUDA requirements; distributed storage semantics; throughput and application latency tests; cluster sizing; network ingress; and 24x7 GPU utilization. **Verify actual region and impact-level authorization, GPU reservations, and support for the exact target shape.** A commercial service catalog alone is insufficient.

For Oracle-centric applications, assess Oracle Database version/edition, licensed features, RAC/Exadata/Data Guard, BYOL restrictions, backup/DR, replication and migration tools in each candidate government cloud.

## Part 3 — Weighted Provider Decision Matrix

**Mandatory gate first:** Any provider failing a legal/regulatory, impact-level, region, vendor-certification or technical requirement is **ineligible regardless of score**.

| Category | Illustrative weight |
|---|---:|
| Security, impact-level scope, data residency, agency ATO approach | 25% |
| Application, database, GPU compatibility and performance | 25% |
| Networking, existing identities and integrations | 15% |
| 5-year fully burdened total cost of ownership | 15% |
| Operations, observability, automation and DR | 10% |
| Schedule, vendor support and migration risk | 10% |
| **Total** | **100%** |

Score eligible providers 0–5 against documented evidence (0 fails, 3 meets, 5 exceeds); calculate weighted score. **These weights are a suggested governance starting point, not an agency policy.** Keep "retain on-prem", "retire" and "replace with compliant SaaS" in the option set when justified.

## Part 4 — Cost Model and Decisions

`5-year TCO = migration and testing labor + license remediation + circuits/data transfer + compute/GPU + database + storage/backups/DR + internet/egress/region-transfer + SIEM/EDR + support/operations + training + decommissioning/exit costs`.

Model Dev, Test, Prod and DR separately; demand growth, peak use, discounts, ongoing licenses and overlap during migration. **Obtain government-specific quotes** and quota/capacity confirmations rather than treating commercial list prices as binding.

| Next action | Accountable group | Current state |
|---|---|---|
| Complete 136-question form with sources and ownership | Application teams | Pending |
| Identify data classification, ATO boundary and impact level | ISSO/AO/security | Pending |
| Validate dependency, DB, OS, network and utilization inventory | App, DBA and infrastructure | Pending |
| Validate cloud service/feature/region and GPU authorization | Cloud architects and vendors | Pending |
| Obtain 5-year comparable Gov price and licensing models | FinOps/procurement | Pending |
| Pilot selected eligible workloads, test rollback and security | Delivery/application owners | Pending |
| Approve target cloud only after evidence and governance | Architecture and agency authorities | Pending |

## Official Source Links (reviewed November 2026)

- [FedRAMP Marketplace and agency ATO guidance](https://www.fedramp.gov/marketplace/guide/)
- [AWS GovCloud differences](https://docs.aws.amazon.com/govcloud-us/latest/UserGuide/govcloud-differences.html)
- [AWS GovCloud service availability](https://docs.aws.amazon.com/govcloud-us/latest/UserGuide/using-services.html)
- [Azure Government vs global Azure](https://learn.microsoft.com/en-us/azure/azure-government/compare-azure-government-global-azure)
- [Azure Government authorization/service roadmap](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-product-roadmap)
- [Google Cloud FedRAMP/DoD service audit scope](https://docs.cloud.google.com/docs/security/compliance/fedramp-dod-compliance-scope)
- [Google Assured Workloads control frameworks](https://docs.cloud.google.com/assured-workloads/docs/framework-reference)
- [Oracle US Government Cloud](https://docs.oracle.com/en-us/iaas/Content/gov-cloud/govfedramp.htm)
- [Oracle US Defense Cloud](https://docs.oracle.com/en-us/iaas/Content/gov-cloud/govfeddod.htm)

**Important:** Authorization scope, service catalog and costs change. Revalidate current official documentation and the FedRAMP Marketplace before procurement, ATO approval or deployment.
