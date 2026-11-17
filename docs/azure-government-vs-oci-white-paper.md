# Strategic White Paper: Why Azure Government Should Be the Preferred Candidate Over OCI Government

**November 2026 | A risk-adjusted platform decision for the full cloud deployment of DataWalk and Hyperscience**

**Status:** Decision support; Azure Government preferred for evaluation, not approved for production.

> Public-reference edition. Internal workload counts, budget estimates, project-specific security posture, procurement details and delivery dates are intentionally omitted. Use approved internal channels for these details.

## Executive summary

Azure Government should be advanced as the preferred evaluation candidate for DataWalk (DW) and Hyperscience (HS), not selected unconditionally for production. The strongest rationale is the potential to consolidate identity, policy, cloud management and security operations into a Microsoft-centric operating model while modernizing both applications on a vendor-supported cloud platform. Azure's broader general government IL5 authorization geography may also be advantageous if IL5 is required and the specific services satisfy isolation requirements. [1–3]

A comparative decision must account for network upgrade exposure, variable consumption costs, disaster recovery readiness, workload authorization and delivery risk. These are evaluation criteria, not proof that either provider cannot meet the requirements. A new provider does not automatically resolve them.

The target is a fully cloud-hosted DW/HS deployment. All application services, databases, storage, models, required identity dependencies, DNS, logging and recovery must reside within approved cloud boundaries. Authorized external user access and temporary migration connectivity are permitted; permanent on-premises runtime dependencies are not.

### Leadership decision requested

Approve a time-boxed, competitively evaluated Azure Government proof of concept (POC), while retaining OCI as the fallback. Require written GPU capacity, vendor platform support, a normalized five-year price proposal, a security authorization plan and a feasible delivery schedule before any production commitment.

| Azure potential advantage | OCI counterweight |
|---|---|
| Integrated Microsoft identity and governance | Existing CD3/SCCA assets and staff experience where applicable |
| Three general US Gov regions with IL5 authorization | Separate OCI Defense realm also supports IL5 |
| Opportunity to reset commercial and delivery terms | Competitive A10 configurations, connectivity and potential price advantages |

## 1. Scope and evaluation framework

This paper evaluates two providers for the selected applications only. It does not propose an enterprise-wide cloud migration. DataWalk development, test and production, and Hyperscience test and production, require vendor-approved sizing. RHEL 8.10 is a compatibility requirement under review; server counts must not be assumed equivalent to Kubernetes worker-node counts.

### Comparative assessment

| Dimension | Azure Government | OCI Government / Defense |
|---|---|---|
| Identity and access | Entra ID, Azure RBAC and Policy; attractive where Microsoft skills and agreements already exist. | OCI IAM identity domains and federation; existing configuration may be reusable. |
| Landing zone / IaC | ALZ + AVM, Terraform/Bicep, SACA guidance; government tailoring required. [4–5] | SCCA/CD3 workbook and Terraform implementation can reduce rebuild effort. |
| Kubernetes | Private AKS candidate; managed Linux node OS support is a compatibility gate. [6] | OKE candidate; exact supported image, version and shape must be verified. |
| GPU compute | Multiple GPU families and A10 configurations; region, capacity and AKS eligibility unverified. [7–8] | A10.2 comparison baseline; specific capacity and isolation also require confirmation. [9] |
| Compliance | FedRAMP High and IL4/IL5 in applicable US Gov regions; service-specific scope and isolation. [1–3] | US Government realm: FedRAMP High/IL4; separate Defense realm: IL5. [10–11] |
| Resilience | Three general Gov region choices; actual cross-region GPU and service parity unverified. | Two US Government regions; three Defense regions; validate recovery options in the authorized realm. [10–11] |
| Cost and delivery | Opportunity for negotiated funding and support; no confirmed quote or faster ATO. | Reuse potential, published network pricing and familiar platform where applicable. [12] |

Use verified evidence, not vendor feature counts. Score only after both providers submit equivalent architectures and commercial terms. An unresolved mandatory security, vendor support or capacity requirement is a no-go regardless of weighted score.

## 2. Why Azure may be the better fit

### A. Simplified operations and governance

Azure offers an integrated governance model using Entra ID, RBAC, Policy, Key Vault and monitoring. If enterprise Microsoft licensing, identity skills and government access approvals can be reused, Azure could reduce integration and operational friction. Cloud-resident identity must work without an on-premises AD/ADFS dependency. CrowdStrike and Splunk may be retained where required; migration or duplicate licensing costs must be assessed.

### B. Modern application deployment

DataWalk has announced that versions 5.2 and later require containerization and decoupled storage, with support for non-container deployments ending November 2027. Its preparation guidance identifies RHEL 8.10 or Rocky Linux 8. Hyperscience documents GPU requirements that vary by version and use case. These factors make a vendor-supported Kubernetes design and GPU sizing essential on either cloud, not uniquely Azure advantages. [13–14]

Azure's managed Kubernetes ecosystem can reduce control-plane and node-pool management overhead if the application vendors approve AKS. Standard AKS Linux node OS options do not list RHEL 8.10. A vendor exception or a supported alternative, such as self-managed Kubernetes on RHEL, must be evaluated before AKS is selected. [6]

### C. Government cloud geography and recovery

Microsoft documents FedRAMP High and IL5 authorizations in US Gov Virginia, Texas and Arizona, subject to applicable isolation guidance. OCI's standard US Government realm has East and West regions and IL4 authorization; OCI's separate Defense realm offers IL5 and three regions. A potential Azure advantage exists only if the required authorization and actual service/GPU availability align. Neither provider supplies a workload ATO by default. [1–3, 10–11]

### D. Commercial opportunity and implementation reset

Request a Microsoft-funded or subsidized POC, technical workshops, named delivery staff, negotiated unit rates, GPU capacity assurance and milestone-based production commitments after ATO approval. These are requests, not confirmed offers. A new vendor engagement can reset the delivery plan but also introduces procurement and onboarding risks.

## 3. Where OCI remains stronger

| OCI advantage | Implication for the decision |
|---|---|
| Existing infrastructure investment | Reuse existing SCCA/CD3 landing zone, IaC, network design and operational knowledge where technically and legally appropriate. Azure requires new deployment artifacts, policy mappings and training. |
| GPU baseline | OCI VM.GPU.A10.2 provides two 24 GB A10 GPUs, 30 OCPUs and 480 GB RAM. Azure NV72ads_A10_v5 has two A10 GPUs, 72 vCPUs and 880 GiB RAM. These are not equivalent CPU/RAM configurations. Confirm the best compute-oriented Azure SKU rather than assuming the graphics-oriented NV family is optimal. [7, 9] |
| Network economics | Oracle publishes favorable outbound transfer allowances and FastConnect port pricing. Azure ExpressRoute has metered and other plan structures. Compare negotiated government rates and carrier costs; full-cloud hosting does not eliminate approved access, egress or replication costs. [12, 15] |
| CD3 automation | An existing Excel-to-Terraform workflow is a concrete reuse advantage. Azure ALZ/AVM offers modular IaC, but a CD3-style workbook and export workflow would need integration or custom development. Government-cloud tailoring is necessary. [4] |
| Lower transition risk | OCI may win if its landing zone, GPU allocation, security evidence and recovery requirements can be delivered more quickly and cheaply than a new Azure environment. |

### Azure disadvantages and mitigations

- Higher potential cost: request a complete government quote, including dedicated compute if required, security, logging, networking, storage and DR.
- New authorization boundary and skills: reuse valid documentation and control mappings only where approved; budget for training and reauthorization work.
- AKS/OS/GPU compatibility: obtain written vendor and Microsoft support for exact versions, node images, drivers and VM sizes.
- Vendor lock-in: retain portable containers, Terraform, documented backup formats and an exit plan where practical.

## 4. Cost, risk and schedule

### Five-year total cost of ownership

Compare equivalent on-premises, OCI and Azure configurations using normalized capacity, performance, availability, security and cost boundaries. Historical estimates are not comparable procurement quotes. Azure pricing must be obtained before a savings percentage can be justified.

| Cost category | Required comparison inputs |
|---|---|
| Compute / GPU | CPU and GPU quantities, hours, SKU, isolation, quota, idle time and discounts |
| Storage / database | Capacity, IOPS, throughput, retention, requests, managed services and licenses |
| Network / security | Approved access, migration transfer, egress, firewalls, logging, SIEM and endpoint security |
| Resilience / operations | Backup, DR GPU capacity, recovery tests, licensing, support and labor |
| Transition | Implementation, security assessment, migration, parallel run, training and retirement; credit offsets |

Five-year TCO = one-time transition costs + five years of recurring consumption, software, connectivity, support and operations + recovery costs − confirmed credits. Avoid double-counting DR or licensing already included in consumption. Compare identical performance, security and recovery targets; include committed and on-demand scenarios.

### Primary risks and mitigation

| Risk | Mitigation / acceptance criterion |
|---|---|
| Workload ATO | Confirm authorization boundary, inherited controls, assessment evidence and authorizing official schedule. |
| GPU shortage / isolation | Written SKU and region capacity, approved isolation design and vendor-supported performance POC. |
| Delivery deadline | Reverse-plan from the approved target; establish procurement, landing zone, migration and ATO dependencies before committing. |
| Cloud-only failure | Demonstrate both stacks can process, authenticate, monitor and recover without the former data center. |

## 5. Decision gates and execution plan

The recommendation is Azure-first discovery, not Azure-only procurement. Treat OCI as the competitive baseline and fallback. No irreversible infrastructure or production consumption commitment should be approved until all mandatory gates are satisfied.

| Gate / proposed weight | Evidence required |
|---|---|
| Security and ATO — 25% | Approved impact level, exact services and GPU isolation; inherited/shared controls and achievable ATO plan. |
| Five-year TCO — 20% | Comparable itemized offers, realistic utilization, negotiated rates, one-time costs and sensitivity analysis. |
| Schedule and delivery — 20% | Named resources, procurement path, funded POC, critical path and contingency. |
| Vendor/GPU fit — 20% | Written DW/HS support, OS compatibility, regional GPU allocation and performance results. |
| Operations and DR — 15% | Cloud-only operational acceptance, authorized recovery design, tested RPO/RTO and staffing plan. |
| **Total — 100%** | All mandatory gates satisfied. |

Weights are proposed for leadership approval. Score 0–5 per criterion after evidence is obtained; calculate the weighted score as the sum of each weight multiplied by its score divided by five. A failed mandatory gate overrides any numerical result.

### Proposed work plan

| Phase | Milestone / owner |
|---|---|
| Discovery | Microsoft and Oracle: written architectures, service/authorization matrices, GPU and commercial offers; security team confirms impact level. |
| Proof of concept | Platform and application vendors: isolated approved POC, GPU benchmark, storage compatibility, migration rehearsal and independent cloud operation. |
| Decision and authorization | Security and operations: evidence review, recovery exercise, TCO and go/no-go decision; confirm ATO critical path. |
| Production cutover | Proceed only if ATO, performance, recovery, procurement and operational acceptance are complete. |

### Final recommendation

Authorize the evaluation. Prefer Azure only if it demonstrates a lower risk-adjusted cost or materially better operational and delivery outcomes at equivalent security and performance. If GPU, RHEL/Kubernetes, authorization or timeline gates fail, retain OCI or defer migration rather than forcing a risky cutover.

## 6. Companion documentation

- [Technical discovery questionnaire — full cloud deployment](./azure-government-scenario-c-discovery.md)
- [Account executive discovery questionnaire](./azure-government-scenario-c-account-executive-questions.md)
- [Editable Draw.io full cloud architecture](./azure-government-scenario-c.drawio)

## References and evidence status

Public technical references from the original November 2026 white paper. Confirm current service availability and contract terms directly with both providers.

1. [Microsoft — Azure Government compliance](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-plan-compliance)
2. [Microsoft — Azure services in FedRAMP/DoD audit scope](https://learn.microsoft.com/en-us/azure/azure-government/compliance/azure-services-in-fedramp-auditscope)
3. [Microsoft — IL5 isolation guidelines](https://learn.microsoft.com/en-us/azure/azure-government/documentation-government-impact-level-5)
4. [Microsoft — Deploy Azure Landing Zones; sovereign cloud requirements](https://learn.microsoft.com/en-us/azure/architecture/landing-zones/landing-zone-deploy)
5. [Microsoft — Secure Azure Computing Architecture (SACA)](https://learn.microsoft.com/en-us/azure/azure-government/compliance/secure-azure-computing-architecture)
6. [Microsoft — AKS FAQ and supported Linux operating systems](https://learn.microsoft.com/en-us/azure/aks/faq)
7. [Microsoft — NVadsA10 v5 VM sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/gpu-accelerated/nvadsa10v5-series)
8. [Microsoft — AKS GPU support](https://learn.microsoft.com/en-us/azure/aks/use-nvidia-gpu)
9. [Oracle — OCI Compute Shapes](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm)
10. [Oracle — US Government Cloud authorizations and regions](https://docs.oracle.com/en-us/iaas/Content/gov-cloud/govfedramp.htm)
11. [Oracle — Government/Defense service availability](https://www.oracle.com/cloud/distributed-cloud/service-availability/)
12. [Oracle — Cloud pricing and network economics](https://www.oracle.com/cloud/pricing/)
13. [DataWalk — Preparing for DataWalk on Containers](https://datawalk.com/preparing-for-datawalk-on-containers/)
14. [Hyperscience — Kubernetes installation overview](https://help.hyperscience.ai/deployment/docs/kubernetes-installation-overview)
15. [Microsoft — ExpressRoute pricing](https://azure.microsoft.com/en-us/pricing/details/expressroute/)
16. [Microsoft — On-demand capacity reservations](https://learn.microsoft.com/en-us/azure/virtual-machines/capacity-reservation-overview)

### Outstanding confirmations

Azure government pricing, exact GPU availability and reservations [16], application vendor support, tenant/region selection, required impact level, funding, procurement conditions, DR capacity and actual ATO schedule remain unverified. The white paper is decision support, not authorization to deploy.
