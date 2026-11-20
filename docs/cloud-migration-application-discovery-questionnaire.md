# Cloud Migration — Application Discovery and Requirements Questionnaire

> **Status:** Draft questionnaire — application owner responses pending  
> **Version:** 1.0  
> **Date:** 2026-11-20  
> **Audience:** Application owners, development teams, DBAs, infrastructure, network, cybersecurity, operations, architecture, and program management  
> **Cloud provider selection:** **Not decided** — evaluate AWS, Azure, GCP, OCI, or alternatives only after requirements are collected.

## Purpose

Capture the **current state**, **future-state requirements**, **constraints**, **evidence**, and **migration readiness** of each application before a cloud provider, landing zone, or migration strategy is selected. Complete one questionnaire **per application or logically coupled application suite**. These are discovery questions, not a commitment to migrate or modernize.

Do not answer questions by presuming any specific cloud provider, service name, pricing model, or reference architecture. Mark government-specific requirements **N/A** where they do not apply.

## Application and Respondent Information

| Field | Response |
|---|---|
| Application name and ID | TBD |
| Business function / portfolio | TBD |
| Business owner / contact | TBD |
| Application technical lead / contact | TBD |
| Database owner / contact | TBD |
| Infrastructure owner / contact | TBD |
| Security / compliance point of contact | TBD |
| Environments covered | TBD |
| Current hosting location / platform | TBD |
| Business criticality (Critical/High/Medium/Low) | TBD |
| Questionnaire prepared by | TBD |
| Date completed / last validated | TBD |
| Links to evidence and architecture diagrams | TBD |

## Completion Guidance

1. Complete the **Answer / evidence** column for every question using actual values, units, applicable environment, and source evidence wherever possible. Use **Unknown**, **TBD**, or **N/A**, not empty implied assumptions.
2. For **requirement priority**, enter **M** (Mandatory), **P** (Preferred), **O** (Optional), or **NA** (Not Applicable). Separate **current-state facts** from **future-state requirements** in the answer.
3. Record material unknowns, assumptions, blockers, and technical owners in the **Open Issues** section.
4. Attach current architecture and dependency diagrams and performance/utilization baselines; show dates for all measurements.
5. Do not commit passwords, private keys, tokens, sensitive configuration exports, classified information, or unredacted sensitive network/security details into this Git repository. Use approved restricted storage and provide references instead.
6. Capture differences by environment when configurations, capacity, or SLAs vary.

## Questionnaire (136 questions)

### 1. Application Overview

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| APP-01 | What is the application name, version, and primary business function? | TBD | TBD |
| APP-02 | Who are the business owner, technical owner, and application support team? | TBD | TBD |
| APP-03 | Is the application commercial off-the-shelf (COTS), custom-developed, open-source, or SaaS? | TBD | TBD |
| APP-04 | What environments exist (Development, Test, UAT, Staging, Production, DR)? | TBD | TBD |
| APP-05 | How many internal and external users access the application? | TBD | TBD |
| APP-06 | What is the business criticality of the application? | TBD | TBD |
| APP-07 | What are the required operating hours and availability SLA? | TBD | TBD |
| APP-08 | Is the application scheduled for retirement, replacement, modernization, or upgrade? | TBD | TBD |

### 2. Application Architecture and Technology Stack

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| TECH-01 | What is the current application architecture (monolithic, multi-tier, microservices, distributed)? | TBD | TBD |
| TECH-02 | What programming languages, frameworks, and runtime versions are used? | TBD | TBD |
| TECH-03 | What operating systems and versions are required? | TBD | TBD |
| TECH-04 | What web servers, application servers, and middleware are used? | TBD | TBD |
| TECH-05 | Does the application require physical servers, virtual machines, containers, or Kubernetes? | TBD | TBD |
| TECH-06 | Does the application support horizontal and vertical scaling? | TBD | TBD |
| TECH-07 | Are there hardcoded IP addresses, hostnames, file paths, or environment-specific configurations? | TBD | TBD |
| TECH-08 | Are any components approaching end-of-life or end-of-support? | TBD | TBD |
| TECH-09 | Are there technical restrictions preventing the application from operating in a cloud environment? | TBD | TBD |
| TECH-10 | Does the software vendor certify or support cloud deployments? | TBD | TBD |

### 3. Database Requirements

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| DB-01 | What database technologies, editions, and versions are used (Oracle, SQL Server, PostgreSQL, MySQL, MongoDB, etc.)? | TBD | TBD |
| DB-02 | How many database instances exist across all environments? | TBD | TBD |
| DB-03 | What is the current database size and anticipated annual growth? | TBD | TBD |
| DB-04 | What are the current database CPU, memory, IOPS, throughput, and latency requirements? | TBD | TBD |
| DB-05 | Is the database deployed as a standalone instance, cluster, or replicated environment? | TBD | TBD |
| DB-06 | Does the application require database-specific features, extensions, stored procedures, or proprietary functionality? | TBD | TBD |
| DB-07 | Are there database links or dependencies on external databases? | TBD | TBD |
| DB-08 | What are the database backup, retention, replication, and recovery requirements? | TBD | TBD |
| DB-09 | Can the application use a managed database service, or must the database remain self-managed? | TBD | TBD |
| DB-10 | Are database engine changes or version upgrades supported? | TBD | TBD |
| DB-11 | What database licensing and support agreements are currently in place? | TBD | TBD |
| DB-12 | What is the maximum acceptable downtime and data loss during database migration? | TBD | TBD |

### 4. Infrastructure and Compute Requirements

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| INF-01 | How many physical servers and virtual machines support the application? | TBD | TBD |
| INF-02 | What are the current CPU, memory, operating system, and storage specifications for each server? | TBD | TBD |
| INF-03 | What are the average and peak CPU and memory utilization levels? | TBD | TBD |
| INF-04 | Are GPUs, specialized processors, or hardware accelerators required? | TBD | TBD |
| INF-05 | Are there hardware-specific dependencies or licensing restrictions? | TBD | TBD |
| INF-06 | What hypervisor or virtualization platform is currently used? | TBD | TBD |
| INF-07 | Are dedicated hosts, bare-metal servers, or shared compute resources required? | TBD | TBD |
| INF-08 | What infrastructure capacity growth is anticipated over the next three to five years? | TBD | TBD |

### 5. Storage and Data Requirements

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| DATA-01 | What storage types are currently used (block, file, object, SAN, NAS)? | TBD | TBD |
| DATA-02 | What are the total storage capacity, current utilization, and annual growth rate? | TBD | TBD |
| DATA-03 | What are the required storage IOPS, throughput, and latency? | TBD | TBD |
| DATA-04 | Does the application require shared file systems, NFS, SMB, or persistent volumes? | TBD | TBD |
| DATA-05 | What are the data retention, archival, and deletion requirements? | TBD | TBD |
| DATA-06 | What data classification levels apply to the application? | TBD | TBD |
| DATA-07 | Are there data residency, geographic, or sovereignty restrictions? | TBD | TBD |
| DATA-08 | What data must remain on-premises, if any, and why? | TBD | TBD |

### 6. Networking and Connectivity

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| NET-01 | What network segments, subnets, IP ranges, and VLANs are currently used? | TBD | TBD |
| NET-02 | What inbound and outbound ports and protocols are required? | TBD | TBD |
| NET-03 | What are the required network bandwidth and latency thresholds? | TBD | TBD |
| NET-04 | Does the application require internet access or private connectivity only? | TBD | TBD |
| NET-05 | What DNS, load balancer, proxy, and firewall dependencies exist? | TBD | TBD |
| NET-06 | Does the application require connectivity to on-premises systems after migration? | TBD | TBD |
| NET-07 | Are there third-party or external network connections? | TBD | TBD |
| NET-08 | Are static IP addresses, IP allowlists, or specific network configurations required? | TBD | TBD |
| NET-09 | What are the estimated daily and monthly inbound and outbound data transfer volumes? | TBD | TBD |

### 7. Application Dependencies and Integrations

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| DEP-01 | What upstream and downstream applications depend on this application? | TBD | TBD |
| DEP-02 | What internal and external APIs are utilized? | TBD | TBD |
| DEP-03 | Does the application integrate with messaging systems, queues, or event-streaming platforms? | TBD | TBD |
| DEP-04 | Are there dependencies on shared databases, file servers, or enterprise services? | TBD | TBD |
| DEP-05 | What scheduled jobs, batch processes, and data pipelines exist? | TBD | TBD |
| DEP-06 | Does the application integrate with external vendors or government systems? | TBD | TBD |
| DEP-07 | Which dependent applications must migrate together? | TBD | TBD |
| DEP-08 | What happens if a dependent application becomes unavailable or experiences increased latency? | TBD | TBD |

### 8. Identity and Access Management

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| IAM-01 | What authentication and authorization mechanisms are currently used? | TBD | TBD |
| IAM-02 | Does the application integrate with Active Directory, LDAP, SAML, OIDC, or other identity providers? | TBD | TBD |
| IAM-03 | Are single sign-on and multifactor authentication required? | TBD | TBD |
| IAM-04 | What application roles, permissions, and privileged accounts exist? | TBD | TBD |
| IAM-05 | Does the application use service accounts, API keys, certificates, or machine identities? | TBD | TBD |
| IAM-06 | How are credentials, secrets, and certificates stored and rotated? | TBD | TBD |
| IAM-07 | Are there restrictions on changing the existing identity provider? | TBD | TBD |

### 9. Security and Compliance

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| SEC-01 | What security and regulatory frameworks apply to the application? | TBD | TBD |
| SEC-02 | Does the application process PII, CUI, classified, financial, or other sensitive information? | TBD | TBD |
| SEC-03 | What encryption requirements exist for data at rest and in transit? | TBD | TBD |
| SEC-04 | Are customer-managed encryption keys or hardware security modules required? | TBD | TBD |
| SEC-05 | What endpoint protection, vulnerability scanning, and security monitoring tools are required? | TBD | TBD |
| SEC-06 | What logging, auditing, and security event retention requirements exist? | TBD | TBD |
| SEC-07 | Does the application currently have an Authorization to Operate (ATO), if applicable? | TBD | TBD |
| SEC-08 | Would cloud migration require a new ATO, authorization update, or security assessment? | TBD | TBD |
| SEC-09 | Are there applicable FedRAMP, FISMA, NIST, agency-specific, or other compliance requirements? | TBD | TBD |
| SEC-10 | Are public cloud services restricted by policy, contract, or data classification? | TBD | TBD |

### 10. High Availability, Backup, and Disaster Recovery

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| DR-01 | What is the required application availability percentage? | TBD | TBD |
| DR-02 | What is the required Recovery Time Objective (RTO)? | TBD | TBD |
| DR-03 | What is the required Recovery Point Objective (RPO)? | TBD | TBD |
| DR-04 | What high-availability architecture currently exists? | TBD | TBD |
| DR-05 | Is geographic redundancy or multi-region disaster recovery required? | TBD | TBD |
| DR-06 | What is the current backup frequency and retention period? | TBD | TBD |
| DR-07 | When was the last successful disaster recovery and backup restoration test? | TBD | TBD |
| DR-08 | Is active-active, active-passive, warm standby, or backup-and-restore recovery required? | TBD | TBD |
| DR-09 | What are the application failover and failback procedures? | TBD | TBD |

### 11. Application Performance and Scalability

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| PERF-01 | What are the current average and peak transaction volumes? | TBD | TBD |
| PERF-02 | What are the required application response times? | TBD | TBD |
| PERF-03 | Are there seasonal or unpredictable workload spikes? | TBD | TBD |
| PERF-04 | What are the maximum concurrent user and connection requirements? | TBD | TBD |
| PERF-05 | Are automated scaling capabilities supported or required? | TBD | TBD |
| PERF-06 | What existing performance benchmarks and load-testing results are available? | TBD | TBD |

### 12. DevOps and Application Deployment

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| DEV-01 | Where is the application source code maintained? | TBD | TBD |
| DEV-02 | What CI/CD tools and deployment pipelines are currently used? | TBD | TBD |
| DEV-03 | Is infrastructure provisioned manually or through Infrastructure as Code? | TBD | TBD |
| DEV-04 | Does the application support automated deployment and rollback? | TBD | TBD |
| DEV-05 | Are container images and software artifacts maintained in centralized repositories? | TBD | TBD |
| DEV-06 | What automated testing capabilities exist? | TBD | TBD |
| DEV-07 | What deployment approvals and change management processes are required? | TBD | TBD |
| DEV-08 | Are application configuration and secrets separated from source code? | TBD | TBD |

### 13. Monitoring and Operational Support

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| OPS-01 | What application and infrastructure monitoring tools are currently used? | TBD | TBD |
| OPS-02 | What centralized logging and alerting platforms are required? | TBD | TBD |
| OPS-03 | Who is responsible for application, operating system, database, and infrastructure support? | TBD | TBD |
| OPS-04 | Is 24/7 operational support required? | TBD | TBD |
| OPS-05 | What patching and maintenance schedules exist? | TBD | TBD |
| OPS-06 | What incident management and service management tools are used? | TBD | TBD |
| OPS-07 | Are there documented operational runbooks and troubleshooting procedures? | TBD | TBD |

### 14. Licensing and Financial Requirements

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| COST-01 | What are the current annual infrastructure and application operating costs? | TBD | TBD |
| COST-02 | What software, database, and operating system licenses are required? | TBD | TBD |
| COST-03 | Are existing licenses eligible for cloud deployment or Bring Your Own License (BYOL)? | TBD | TBD |
| COST-04 | Are licenses based on users, processors, cores, servers, or consumption? | TBD | TBD |
| COST-05 | Would migration require new licenses or vendor support agreements? | TBD | TBD |
| COST-06 | Are there existing contractual commitments, renewal dates, or termination penalties? | TBD | TBD |
| COST-07 | What budget constraints or financial requirements apply to the migration? | TBD | TBD |

### 15. Cloud Migration Readiness

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| MIG-01 | Has the application previously been evaluated or tested in a cloud environment? | TBD | TBD |
| MIG-02 | Can the application migrate without significant code or architecture changes? | TBD | TBD |
| MIG-03 | Can individual application components migrate independently? | TBD | TBD |
| MIG-04 | Are managed cloud services technically and contractually acceptable? | TBD | TBD |
| MIG-05 | What application changes would be required before migration? | TBD | TBD |
| MIG-06 | What is the maximum acceptable migration downtime? | TBD | TBD |
| MIG-07 | Are there maintenance windows or migration blackout periods? | TBD | TBD |
| MIG-08 | What are the major technical, operational, contractual, and security risks? | TBD | TBD |
| MIG-09 | What resources and personnel are available to support migration? | TBD | TBD |
| MIG-10 | What is the target migration timeline? | TBD | TBD |
| MIG-11 | What testing, validation, and acceptance criteria must be satisfied before production cutover? | TBD | TBD |
| MIG-12 | What rollback capabilities are required if migration is unsuccessful? | TBD | TBD |

### 16. Future-State Requirements

| ID | Discovery question | Answer / evidence | Priority (M/P/O/NA) |
|---|---|---|---|
| FUT-01 | What current application or infrastructure challenges should cloud migration resolve? | TBD | TBD |
| FUT-02 | What new capabilities or functionality are anticipated? | TBD | TBD |
| FUT-03 | Are application modernization or containerization planned? | TBD | TBD |
| FUT-04 | Is cloud portability or avoidance of proprietary cloud services a requirement? | TBD | TBD |
| FUT-05 | Are hybrid-cloud or multi-cloud architectures required, optional, or restricted? | TBD | TBD |
| FUT-06 | Are there requirements for AI, machine learning, GPU computing, or advanced analytics? | TBD | TBD |
| FUT-07 | What are the measurable business and technical success criteria for cloud migration? | TBD | TBD |

## Required Supporting Documentation

Use approved document locations for sensitive assets; link to them from this questionnaire instead of committing sensitive evidence directly.

- [ ] Application architecture diagram (components, environments, data flows)
- [ ] Network architecture and communication / firewall flows
- [ ] Server, VM, container, and GPU inventory where applicable
- [ ] Database inventory, sizing, versions, and HA/DR configuration
- [ ] Technology stack, lifecycle, and vendor support matrix
- [ ] Upstream/downstream application dependency matrix
- [ ] Performance and capacity metrics with 30–90 days of data where available
- [ ] Storage capacity, growth, and retention report
- [ ] Software and database license / contract inventory
- [ ] Security controls, classifications, and authorization requirements
- [ ] Backup, restoration, and DR plans with latest test evidence
- [ ] Deployment, operations, and incident runbooks
- [ ] Cost baseline and forecast assumptions
- [ ] Vendor statements on cloud support, if applicable

## Open Issues and Assumptions

| Issue ID | Related question ID | Unknown, blocker, or assumption | Impact | Owner | Target resolution date | Status |
|---|---|---|---|---|---|---|
| ISSUE-001 | TBD | TBD | TBD | TBD | TBD | Open |

## Application Team Sign-Off

| Role | Name | Date | Status / notes |
|---|---|---|---|
| Business owner | TBD | TBD | Pending |
| Technical application owner | TBD | TBD | Pending |
| Database / platform owner | TBD | TBD | Pending |
| Security / compliance representative | TBD | TBD | Pending |

## Architecture Team Follow-On Assessment

**Do not use this section to predetermine a provider.** Once questionnaire answers are validated, the architecture team should:

1. Reconcile the application, server, database, storage, and dependency inventories.
2. Assess cloud blockers including unsupported versions, hardware coupling, vendor certifications, licensing, regulatory authorization, DNS/IP assumptions, and latency-sensitive dependencies.
3. Define candidate workload dispositions (retain, retire, replace, rehost, replatform, refactor) **based on evidence**.
4. Define target-state nonfunctional requirements: security, network, IAM, availability, RTO/RPO, data residency, scale, and operational ownership.
5. Evaluate eligible AWS, Azure, GCP, OCI, and other offerings **against the same weighted requirements**, including government-specific service availability and authorization where applicable.
6. Estimate one-time migration expenses, recurring compute/database/storage/network/egress/DR/licensing costs, staffing/support, and three- to five-year total cost of ownership using workload measurements.
7. Propose migration waves, sequencing, validation tests, cutover/rollback plans, and accountable owners.
8. Obtain decision approvals before committing to a provider or production migration.

### Expected Assessment Deliverables

| Deliverable | Primary responsible team |
|---|---|
| Completed application questionnaire | Application team |
| Application/compute/database inventory | Application, infrastructure, and database teams |
| Dependency and network flow assessment | Application and network teams |
| Security and authorization gap assessment | Cybersecurity / compliance |
| Cloud readiness and technical disposition | Enterprise / cloud architecture |
| Vendor-neutral requirements and cloud comparison | Enterprise / cloud architecture |
| TCO estimate and sensitivity analysis | FinOps / finance |
| Migration waves and project roadmap | Program / project management |

---

**Document control:** This questionnaire is a reusable baseline. Do not replace application-team evidence with inferred technical facts. Cloud provider selection is intentionally deferred.
