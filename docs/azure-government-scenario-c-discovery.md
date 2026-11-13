# Azure Government Cloud Discovery — Scenario C
## Hybrid GPU and Kubernetes workloads: DataWalk and Hyperscience

**Status:** Discovery only — proposed architecture; feasibility, capacity, pricing, and authorization unverified.

**Objective:** Evaluate Azure Government for selected GPU-intensive and Kubernetes workloads while retaining other enterprise systems on premises. This is not a full enterprise migration proposal.

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
| Connectivity | ExpressRoute through approved government connectivity |
| Security | SCCA/SACA, approved identity, endpoint protection and SIEM integrations |
| Cost | Five-year total cost of ownership |

## 2. Conceptual architecture

**Editable architecture diagram:** [Download the Draw.io file](./azure-government-scenario-c.drawio). Open the file in [diagrams.net](https://app.diagrams.net/) or Draw.io Desktop. No Mermaid renderer is required.

Concept only. Microsoft and the application vendors must validate topology, environment segregation, service authorization, data flows, and operational responsibilities.

## 3. Top 15 questions for Microsoft

1. Can Azure Government support both applications in a fully private Kubernetes environment?
2. Which region provides the required GPU availability, AKS capabilities and compliance?
3. Which A10, A100, L40S and H100 GPU VM SKUs are currently offered?
4. Can Microsoft guarantee production GPU capacity, and under what terms?
5. Are the proposed GPU SKUs authorized and appropriately isolated at the required DoD impact level?
6. Can AKS use RHEL 8.10 worker nodes, or is another supported OS or Kubernetes platform required?
7. Can Microsoft provide a SCCA/SACA landing zone for GPU and Kubernetes workloads?
8. Can ExpressRoute reuse existing provider infrastructure, subject to network approval?
9. Can on-premises applications and databases communicate privately with the cloud workloads?
10. How can Microsoft support and accelerate our workload ATO?
11. What is the five-year total cost of both workloads?
12. Can development/test GPU pools scale down when not used?
13. Can Microsoft provide engineering resources and funding for a proof of concept?
14. What are the known Azure Government AKS and GPU limitations?
15. What is the realistic critical path to production readiness, including approvals?

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
- Can DataWalk securely connect to on-premises databases and source systems?
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
7. Can documents remain on premises, or must copies be transferred for processing?
8. Can GPU training resources be provisioned on demand?
9. How should existing server sizing translate into Kubernetes nodes and pods?
10. How are models, processing data, configuration and databases backed up and restored?

**Required:** Vendor-approved GPU, CUDA, OS, database, storage and Kubernetes compatibility matrix. Confirm application-version-specific VRAM and driver requirements.

## 8. Hybrid networking

1. Can the existing network provider establish ExpressRoute in the appropriate government environment?
2. Can approved physical infrastructure be reused without assuming the existing cloud circuit is transferable?
3. What bandwidth is required based on representative document ingestion and processing?
4. What are the costs and lead times for different ExpressRoute bandwidth tiers?
5. What latency and throughput should we expect from our on-premises site?
6. Can existing BCAP connectivity be leveraged subject to government approval?
7. Can private DNS and private endpoints support all dependencies?
8. Can existing AD and ADFS integrate with the government tenant?
9. Can administrators reach private cluster endpoints from approved jump servers?
10. How are TLS inspection, approved egress and centralized firewall policies enforced?
11. What happens to the workloads if connectivity is lost?
12. What is the cost and architecture for redundant circuits and failover?

## 9. ATO, security and SCCA — critical

| Area | Questions |
|---|---|
| Authorization | Which services, SKUs and regions are in scope for the required impact level? |
| ATO | Which controls are inherited, shared or customer-managed? Can Microsoft provide the authorization package and control matrix? |
| SCCA | How does SACA address BCAP, VDSS, VDMS and TCCM? Can IaC deploy the landing zone? |
| Isolation | How do GPU worker nodes meet applicable isolation and encryption requirements? |
| Encryption | Can storage, managed disks, registry and Kubernetes secrets use customer-managed keys where required? |
| Endpoint | Can CrowdStrike protect supported worker nodes and container workloads? |
| SIEM | Can Splunk receive the necessary Azure and Kubernetes security logs? |
| Vulnerability | Can ACAS/Nessus and existing tools be integrated? |
| Identity | Can CAC/PIV, YubiKey, least privilege and privileged access controls be retained? |
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
| ExpressRoute and carrier costs | TBD | TBD | TBD |
| Firewall and networking | TBD | TBD | TBD |
| Security and logging | TBD | TBD | TBD |
| Backup and recovery | TBD | TBD | TBD |
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
- [ ] Validate security controls, backup/restore and ATO gaps.
- [ ] Complete normalized five-year TCO and recommendation.

## 12. Proposed implementation phases

| Phase | Deliverable | Gate |
|---|---|---|
| 1 | Discovery and requirements | Impact level and vendor constraints identified |
| 2 | Architecture, sizing and quote | GPU capacity and cost confirmed |
| 3 | Landing zone and POC | Approved connectivity and test environment |
| 4 | Application deployment and benchmarking | Vendor and performance acceptance |
| 5 | Security evidence and ATO readiness | Authorizing official review |
| 6 | Production deployment | ATO and operational readiness approved |

Ask Microsoft to estimate duration, dependencies, staffing and contingency for each phase. No production date is assumed.

## 13. Meeting agenda (60 minutes)

| Duration | Topic |
|---:|---|
| 5 min | Project overview |
| 10 min | Azure Government and compliance |
| 15 min | GPU availability and AKS |
| 10 min | DataWalk and Hyperscience |
| 5 min | Hybrid networking |
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
4. Approved network connectivity and acceptable five-year TCO.
5. A realistic, documented path to workload ATO.

Do not commit to production infrastructure before resolving these gates. Request a written architecture, service authorization matrix, GPU capacity quote, vendor-approved sizing, POC scope, cost model and implementation schedule.
