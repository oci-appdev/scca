# Azure Government Cloud Discovery — Scenario C
## Full cloud deployment: DataWalk and Hyperscience GPU and Kubernetes workloads

**Status:** Discovery only — proposed architecture; feasibility, capacity, pricing, and authorization unverified.

**Objective:** Deploy the complete DataWalk (DW) and Hyperscience (HS) application stacks in Azure Government, including application tiers, databases, datasets, models, compute, storage and required platform services. This is a full cloud migration of these two applications, not an enterprise-wide migration.

**Design requirement:** No DW/HS application runtime component or required runtime service may reside on premises. Cloud-hosted processing, data, identity dependencies, DNS, monitoring and recovery must continue independently of on-premises infrastructure. Approved external user access and temporary migration connections do not constitute hybrid hosting. Any unavoidable external integration must be documented and approved; no critical runtime dependency may be assumed.

> Public-reference edition: organization-specific inventory, network capacity, budget estimates, and target dates are intentionally omitted. Supply these through approved internal channels.

## 1. Planning assumptions

| Area | Proposed baseline |
|---|---|
| Cloud | Azure Government; US Gov Virginia as a candidate, not a confirmed selection |
| Workloads | DataWalk and Hyperscience |
| Environments | Separate development, test and production as required |
| OS | RHEL 8.10 requirement to validate with vendors |
| GPU | NVIDIA A10, 24 GB VRAM, as a comparison baseline |
| Kubernetes | Private AKS, subject to OS, GPU, vendor and authorization compatibility |
| Connectivity | Approved government access boundary, private cloud networking and temporary migration connectivity as needed |
| Runtime | All required application tiers, databases, datasets, models, queues and storage hosted in the approved cloud boundary |
| Identity and operations | Cloud-resident runtime identity, DNS, logging, endpoint security and management |
| Recovery | Cloud-to-cloud backup and disaster recovery, subject to authorized region and service availability |
| Security | SCCA/SACA, approved identity, endpoint protection and SIEM integrations |
| Cost | Five-year total cost of ownership |

## 2. Conceptual architecture

**Editable architecture diagram:** [Download the raw Draw.io file](https://raw.githubusercontent.com/oci-appdev/scca/main/docs/azure-government-scenario-c.drawio). Save it with the `.drawio` extension, then open it using **File > Open From > Device** in [diagrams.net](https://app.diagrams.net/) or Draw.io Desktop. Do not save the GitHub HTML preview page as a diagram. No Mermaid renderer is required.

Concept only. All application runtime components reside in Azure Government. External user access is not a hosting dependency. Microsoft and the vendors must validate topology, environment segregation, service authorization, data flows, cloud-resident identity and operational responsibilities.

## 3. Top 17 questions for Microsoft

1. Can Azure Government support both applications in a fully private Kubernetes environment?
2. Which region provides the required GPU availability, AKS capabilities and compliance?
3. Which A10, A100, L40S and H100 GPU VM SKUs are currently offered?
4. Can Microsoft guarantee production GPU capacity, and under what terms?
5. Are the proposed GPU SKUs authorized and appropriately isolated at the required DoD impact level?
6. Can AKS use RHEL 8.10 worker nodes, or is another supported OS or Kubernetes platform required?
7. Can Microsoft provide a SCCA/SACA landing zone for GPU and Kubernetes workloads?
8. What approved cloud access and private connectivity architecture supports the fully cloud-hosted applications without a permanent on-premises runtime dependency?
9. Can all application databases, storage, source datasets, models, queues and runtime dependencies be hosted in Azure Government?
10. How can Microsoft support and accelerate our workload ATO?
11. What is the five-year total cost of both workloads?
12. Can development/test GPU pools scale down when not used?
13. Can Microsoft provide engineering resources and funding for a proof of concept?
14. What are the known Azure Government AKS and GPU limitations?
15. What is the realistic critical path to production readiness, including migration, cloud-only operational acceptance, recovery validation and approvals?
16. Can both applications continue processing and operating if connectivity to the former data center is removed?
17. Can a second authorized Azure Government region provide application-consistent disaster recovery without reliance on on-premises recovery systems?

## 4. GPU infrastructure and availability — critical

1. Which GPU families and exact SKUs are available in US Gov Virginia, Texas and Arizona?
2. Is a VM with two full A10 GPUs available as a comparison to OCI VM.GPU.A10.2?
3. Are the instances supported for the required CUDA training and inference workloads?
4. Which SKUs are supported as AKS GPU worker nodes?
5. Can compute isolation and dedicated hardware requirements be met?
6. What are default GPU quotas, and how long do quota increases take?
7. Can capacity be reserved for the expected project lifetime? Distinguish reservations for price from capacity reservations.
8. What happens if capacity is unavailable following a restart or scale operation?
9. What NVIDIA driver, software or licensing costs are included or excluded?
10. Can Microsoft benchmark A10, A100 and H100 against representative workloads?
11. Are GPU sharing, time-slicing and dedicated allocations supported and approved?
12. What are the GPU maintenance, replacement and support commitments?

| GPU | VRAM per GPU | Hourly / annual cost | Gov region, quota and capacity |
|---|---:|---|---|
| A10 | 24 GB | Quote | Confirm |
| L4 | 24 GB | Quote | Confirm |
| L40S | 48 GB | Quote | Confirm |
| A100 | 40/80 GB | Quote | Confirm |
| H100 | 80 GB (configuration dependent) | Quote | Confirm |

Request single-GPU and multi-GPU configurations. GPU model availability does not establish AKS compatibility, physical capacity or authorization.

## 5. Private AKS and alternative Kubernetes platforms — critical

1. Can the API server and workloads be private, with no public workload endpoints?
2. Which Kubernetes versions and supported node OS images are available?
3. Is RHEL 8.10 supported for AKS worker nodes?
4. If RHEL is mandatory, can Microsoft support self-managed Kubernetes or Red Hat OpenShift in the required boundary?
5. Can we separate CPU and GPU node pools?
6. Should Dev, Test and Prod use separate clusters and subscriptions?
7. Can GPU pools scale to zero where operationally appropriate?
8. Can we use a private Azure Container Registry and private endpoints?
9. Can vendor Helm charts and container images be mirrored for restricted-network deployments?
10. Can we support the vendor-required CUDA versions, NVIDIA drivers and operators?
11. Which persistent volume, storage class and storage performance options are supported?
12. How are patching, upgrades, rollback and node image security handled?
13. What is the AKS shared responsibility model?
14. How are DISA STIGs and Kubernetes hardening implemented and evidenced?
15. What are the management, support and operational costs?

## 6. DataWalk discovery

- Can Microsoft coordinate directly with DataWalk to validate the target platform?
- Can the existing server architecture be consolidated into a smaller Kubernetes footprint?
- Does Azure Blob Storage meet decoupled storage requirements, or is an S3-compatible layer needed?
- What node-to-node throughput, storage IOPS and latency can be supported?
- Which DataWalk components require GPUs, if any?
- Which Azure-hosted database, search/index, messaging and storage components are vendor-supported for a complete DataWalk deployment?
- Can all required datasets be copied or ingested into approved cloud storage, with external source feeds decoupled from runtime processing?
- Can DataWalk operate and recover entirely in Azure after legacy infrastructure is disconnected?
- How can datasets be migrated and integrity verified?
- How are application-consistent backup and restore implemented?
- Can compute and storage scale independently?
- Would containerization change licensing, support or upgrade requirements?

**Required:** Vendor-approved architecture, sizing, storage compatibility and support confirmation.

## 7. Hyperscience discovery

1. Can Microsoft coordinate directly with Hyperscience to validate the deployment?
2. Can application servers, trainers and GPU inference workers be separated?
3. Which SKU is best for training?
4. Which SKU is best for document processing and inference?
5. Can the application operate in a restricted-network private cluster?
6. Which database and persistent storage services are vendor-supported?
7. Can all documents, training data, models, processing queues and output records be stored and processed within Azure Government?
   - What cloud-hosted ingestion and export interfaces are supported?
   - Can processing continue independently of the former data center?
8. Can GPU training resources be provisioned on demand?
9. How should existing server sizing translate into Kubernetes nodes and pods?
10. How are models, processing data, configuration and databases backed up and restored?

**Required:** Vendor-approved GPU, CUDA, OS, database, storage and Kubernetes compatibility matrix. Confirm application-version-specific VRAM and driver requirements.

## 8. Cloud networking, access and migration

1. What SACA hub-and-spoke architecture and subscription structure are recommended for a cloud-only deployment?
2. Can production, test and development be separated by subscription, VNet, cluster and security boundary?
3. Can all workload components use private endpoints, private DNS and private service-to-service routing?
4. Which approved government access boundary (including BCAP where applicable) is required for authorized users and administrators?
5. How will cloud-resident directory services, workload identity, DNS and administrative access operate independently of the former data center?
6. Can users access the applications through approved government network connectivity without exposing public workload endpoints?
7. Can Azure Firewall or approved third-party controls enforce inspection, egress allowlists and east-west segmentation?
8. What temporary approved connectivity and tools are recommended for migrating existing datasets, databases and images? Is ExpressRoute necessary or optional?
9. What bandwidth, migration duration, transfer costs and integrity checks are expected?
10. How can legacy data be synchronized for final cutover and how will migration paths be removed or restricted afterward?
11. Can administrators use approved cloud-hosted management and jump services without relying on an on-premises jump server?
12. How will vendor updates, container images, patches and license checks work within restricted government networking?
13. Can both stacks continue processing during loss of connectivity to the former data center? How will we demonstrate this?
14. What are the costs and availability of redundant cloud access, internal routing and security services?

### Cloud-only backup, high availability and disaster recovery

1. Which availability zones and secondary Azure Government regions support the required GPU, Kubernetes, database and storage services at the required impact level?
2. Can we implement application-consistent backups of databases, indexes, documents, models, configuration and persistent volumes?
3. What RPO/RTO can Microsoft and each vendor support? Provide estimates, assumptions and recovery test criteria.
4. Can backups be immutable, isolated, encrypted and restored entirely within authorized cloud regions?
5. How will recovery work if the primary region, AKS cluster, identity service or GPU capacity is unavailable?
6. Can the recovery region reserve equivalent GPU capacity and support required vendor licenses?
7. Can failover, failback and periodic recovery exercises be performed without on-premises infrastructure?
8. What are the separate costs for zonal HA, cloud-to-cloud warm standby and backup-only recovery? Recommend a design based on business-approved RPO/RTO.

## 9. ATO, security and SCCA — critical

| Area | Questions |
|---|---|
| Authorization | Which services, SKUs and regions are in scope for the required impact level? |
| ATO | Which controls are inherited, shared or customer-managed? Can Microsoft provide the authorization package and control matrix? |
| SCCA | How does SACA address BCAP, VDSS, VDMS and TCCM? Can IaC deploy the landing zone? |
| Isolation | How do GPU worker nodes meet applicable isolation and encryption requirements? |
| Encryption | Can storage, managed disks, registry and Kubernetes secrets use customer-managed keys where required? |
| Endpoint | Can CrowdStrike protect supported worker nodes and container workloads? |
| SIEM | Can a cloud-hosted authorized Splunk or equivalent SIEM receive and retain the necessary Azure and Kubernetes logs without an on-premises collector dependency? |
| Vulnerability | Can ACAS/Nessus and existing tools be integrated? |
| Identity | Can approved cloud-resident identity, CAC/PIV or YubiKey, least privilege and privileged access operate without on-premises AD/ADFS dependencies? |
| Logging | Can security logs use immutable retention policies? |
| Supply chain | How are vendor images scanned, signed, approved and mirrored? |
| Monitoring | Can compliance evidence and configuration drift be collected automatically? |
| Data boundary | How is unauthorized transfer outside the government boundary prevented? |
| Documentation | Can Microsoft support SSP, POA&M, RMF and control implementation documentation? |

Cloud provider authorization is not a workload ATO. Confirm the exact architecture with the authorizing official before production.

## 10. Five-year TCO and quote request

Request a bill of materials with monthly, annual and five-year estimates. Normalize capacity, availability, licensing, usage hours and support scope before comparing Azure Government, OCI Government and on-premises infrastructure.

| Cost component | Monthly | Annual | Five-year |
|---|---|---|---|
| CPU nodes | TBD | TBD | TBD |
| GPU nodes | TBD | TBD | TBD |
| Dedicated hardware, if required | TBD | TBD | TBD |
| AKS management | TBD | TBD | TBD |
| Container registry | TBD | TBD | TBD |
| Database services | TBD | TBD | TBD |
| Object and block storage | TBD | TBD | TBD |
| Government user access / cloud connectivity | TBD | TBD | TBD |
| Temporary migration connectivity and transfer (one-time) | TBD | TBD | TBD |
| Cloud-resident identity, DNS and management | TBD | TBD | TBD |
| Firewall and networking | TBD | TBD | TBD |
| Security and logging | TBD | TBD | TBD |
| Backup, high availability and cloud-to-cloud DR | TBD | TBD | TBD |
| RHEL and application/software licenses | TBD | TBD | TBD |
| Microsoft support | TBD | TBD | TBD |
| Migration and implementation | TBD | TBD | TBD |
| Total | TBD | TBD | TBD |

Request pay-as-you-go, one-year and three-year commitment scenarios; separately confirm capacity guarantees, POC funding, egress, operational staffing and cost controls.

## 11. Proof-of-concept readiness checklist

- [ ] Confirm impact level, service scope and region.
- [ ] Obtain GPU capacity, quota and pricing confirmation.
- [ ] Obtain both vendors' platform support and sizing.
- [ ] Obtain approval for the isolated POC and permitted test data.
- [ ] Deploy an isolated landing zone and approved connectivity.
- [ ] Deploy private Kubernetes and CPU/GPU node pools.
- [ ] Deploy DataWalk development and Hyperscience test workloads.
- [ ] Benchmark representative ingestion, training, inference, storage and network performance.
- [ ] Validate security controls, cloud-resident identity, backup/restore and ATO gaps.
- [ ] Demonstrate both application stacks run independently of the former data center; inventory and eliminate any required on-premises runtime dependency.
- [ ] Validate cloud-to-cloud recovery and document RPO/RTO, migration cutover and rollback.
- [ ] Complete normalized five-year TCO and recommendation.

## 12. Proposed implementation phases

| Phase | Deliverable | Gate |
|---|---|---|
| 1 | Discovery and requirements | Impact level and vendor constraints identified |
| 2 | Architecture, sizing and quote | GPU capacity and cost confirmed |
| 3 | Landing zone and POC | Approved connectivity and test environment |
| 4 | Application deployment and benchmarking | Vendor and performance acceptance |
| 5 | Security evidence and ATO readiness | Authorizing official review |
| 6 | Complete cloud migration, cutover and operational handoff | ATO, independent cloud operation and recovery acceptance approved |
| 7 | Legacy workload retirement | Retention, rollback window, migration acceptance and decommission approvals satisfied |

Ask Microsoft to estimate duration, dependencies, staffing and contingency for each phase. No production date is assumed.

## 13. Meeting agenda (60 minutes)

| Duration | Topic |
|---:|---|
| 5 min | Project overview |
| 10 min | Azure Government and compliance |
| 15 min | GPU availability and AKS |
| 10 min | DataWalk and Hyperscience |
| 5 min | Cloud networking, migration and recovery |
| 10 min | Pricing and timeline |
| 5 min | Deliverables and next steps |

## 14. References

- [Azure Government product roadmap](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-product-roadmap)
- [Azure Government IL5 guidance](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-impact-level-5)
- [AKS NVIDIA GPU node pools](https://learn.microsoft.com/en-us/azure/aks/use-nvidia-gpu)
- [Azure NVadsA10 v5 VM series](https://learn.microsoft.com/en-us/azure/virtual-machines/nva10v5-series)
- [DataWalk container deployment preparation](https://datawalk.com/preparing-for-datawalk-on-containers/)
- [Hyperscience Kubernetes installation overview](https://help.hyperscience.ai/deployment/docs/kubernetes-installation-overview)

## 15. Go/no-go decision gates

1. GPU availability, guaranteed capacity and compliant isolation.
2. RHEL and Kubernetes compatibility.
3. Written DataWalk and Hyperscience vendor support.
4. Complete cloud-resident runtime, approved cloud access, validated cloud recovery and acceptable five-year TCO.
5. A realistic, documented path to workload ATO.

6. Cloud-only operation proven without former data center dependencies; approved migration and retirement plan.

Do not commit to production infrastructure before resolving these gates. Request a written architecture, service authorization matrix, GPU capacity quote, vendor-approved sizing, POC scope, cost model and implementation schedule.

## Companion commercial questionnaire

- [Microsoft Azure Government — Account Executive Discovery Questions](./azure-government-scenario-c-account-executive-questions.md)
- [Strategic white paper — Azure Government vs. OCI Government](./azure-government-vs-oci-white-paper.md)
