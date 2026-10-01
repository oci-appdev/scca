# OCI old-to-new landing-zone migration checklist

Updated: 2026-10-01. Repository: `oci-appdev/scca`.

Purpose: move approved resources from old compartments into the new landing-zone compartment structure, and migrate workloads from legacy `172.16` networks to approved `10.x` networks where required. This is an execution checklist, not approval to modify or delete resources.

## 1. Decide what “move” means

| Path | What changes | Use when |
|---|---|---|
| A: Compartment reassignment | Resource management/IAM location; supported resources retain their identity | Existing network and deployment remain acceptable |
| B: Network/workload migration | New network placement, potentially new IPs, endpoints and resource OCIDs | Workload must leave the legacy VCN/subnet and use the new landing zone |
| C: Compartment hierarchy reparenting | Entire compartment subtree changes parent and inherited policy context | The whole subtree is approved to move; it does not redesign its networks |
| D: Keep shared or retire later | Retain shared infrastructure or schedule approved decommission | Resource supports both environments or cannot yet migrate |

**Moving a VM to a new compartment does not place it in the new VCN. Moving the old VCN does not convert its CIDR to `10.x`.** Record the chosen path for every resource. Do not assume every resource supports a direct move or that every dependent resource moves with its parent.

Scope assumption: same OCI tenancy and region. If the destination is another tenancy, realm, or region, stop and create a separate copy/replication/rebuild migration plan. Verify service availability and supported features in the actual Government Cloud region.

## 2. Migration control sheet — complete before execution

- [ ] Tenancy name and exact OCID recorded: __________.
- [ ] Region/realm recorded: __________.
- [ ] Old landing-zone root compartment names and OCIDs recorded: __________.
- [ ] New landing-zone root and destination compartment names and OCIDs recorded: __________.
- [ ] Exact old CIDRs recorded; default `172.16.0.0/16` is only a starting assumption: __________.
- [ ] Exact target `10.x` allocations/subnet CIDRs recorded; `10.0.0.0/8` is a classification range, not a subnet design: __________.
- [ ] Application/business owner, network owner, DBA, security owner and executor assigned.
- [ ] Change ticket, approved maintenance window, bridge and escalation contacts recorded.
- [ ] RTO, RPO, maximum outage, rollback deadline and acceptance criteria agreed per workload.
- [ ] Business owner approves MOVE / MIGRATE / KEEP / RETIRE disposition; age alone is not sufficient.

Use one row per resource; duplicate this table as needed:

| Resource/type and OCID | Old compartment OCID | New compartment OCID | Old/new VCN-subnet-IP | Path | Dependencies | Backup/restore proof | Owner/change | Status/evidence |
|---|---|---|---|---|---|---|---|---|
| __________ | __________ | __________ | __________ | A/B/C/D | __________ | __________ | __________ | __________ |

## 3. Inventory and dependency discovery

- [ ] Read `HANDOFF.md` and the gap-analysis README before collecting evidence.
- [ ] Run the SDK gap collector with the correct region, confirmed tenancy/compartment scope and old landing-zone root OCIDs.
- [ ] Enter the exact requested OCIDs, review the full scan summary, then enter exact uppercase `YES` only for the intended read-only scan.
- [ ] Prefer a full tenancy scan to identify cross-compartment dependencies; repeat separately in every relevant region.
- [ ] Review `resources`, `dependencies`, `unresolved_links`, `coverage`, `errors`, `old_landing_zone_resources` and the decision template outputs.
- [ ] Resolve missing permissions, collection errors and unresolved links; do not treat absent inventory rows as proof of no dependency.
- [ ] Add resources outside collector coverage: buckets/backups, images, IAM policies, DNS zones/resolvers, keys/secrets/certificates, monitoring, logging, integration endpoints and service-specific private endpoints.
- [ ] Map VM-to-VNIC-to-subnet-to-VCN, VM-to-volumes, LB-to-backends, app-to-DB, app-to-FSS, VCN-to-DRG and on-premises connections.
- [ ] Inspect guest/application dependencies: hard-coded IPs, NFS mounts, `/etc/fstab`, DNS, NTP, license servers, SMTP, proxies, scheduled jobs and external allowlists.
- [ ] Record Terraform/CD3/Resource Manager ownership, state location and current plan; identify unmanaged resources and drift.
- [ ] Capture before-state configuration and inventories in a restricted evidence location; exclude passwords, keys and secret contents from Git.

## 4. Prepare destination compartments and IAM

- [ ] Confirm approved compartment hierarchy and separation of network/security, applications, databases, shared services and logging; do not invent target names during cutover.
- [ ] Validate source and destination OCIDs independently with a second reviewer.
- [ ] Check executor permissions in both source and target for each exact resource type; validate without granting unnecessary tenancy-wide access.
- [ ] Review inherited policies, compartment-path policies and OCID conditions before resource movement or compartment reparenting.
- [ ] Prepare destination group permissions and service-principal policies, then test operator access before moving resources.
- [ ] Review dynamic-group rules and instance/resource-principal access, especially conditions based on compartment OCID.
- [ ] Check quotas, limits, GPU/VM capacity, availability/fault domains and reservation requirements.
- [ ] Review Security Zone constraints; obtain security approval for any incompatibility, not an ad hoc bypass.
- [ ] Verify Vault/key, secret, certificate, Object Storage, backup and cross-compartment network permissions remain usable.
- [ ] Configure approved tags, cost allocation, budgets, alarm scope, audit/log routing and destination backup policies.
- [ ] Plan the IaC change: compartment IDs, network IDs and state/import references; peer-review a plan with no unintended replacements/deletions.

## 5. Network and shared-services checklist

### Path A: retain the current network and change compartment management

- [ ] Verify direct-move support for each VCN, subnet, NSG, security list, route table, gateway, DRG/attachment and firewall resource type.
- [ ] Inventory each object's current compartment; do not assume all network children share the VCN compartment.
- [ ] Document which associated objects move automatically versus require separate moves. Oracle documents associated VNIC/private/ephemeral-IP movement with a VCN; verify final placement after asynchronous completion.
- [ ] Execute only the approved object moves; monitor work requests/lifecycle state where provided.
- [ ] Re-inventory related resources and confirm routing/connectivity remains unchanged; update compartment-scoped alarms and access policies.

### Path B: migrate workloads to the new `10.x` network

- [ ] Reserve non-overlapping target CIDRs against on-premises, peered VCNs, VPNs and all connected networks.
- [ ] Build approved VCN/subnets, DNS/DHCP, NSGs/security lists, route tables and gateway/firewall paths with reviewed IaC.
- [ ] Review required ports/protocols and justification; do not copy broad legacy rules without approval.
- [ ] Validate the actual DRG topology, VCN attachments, DRG route tables/distributions and return paths.
- [ ] Verify FastConnect/IPSec routes with the on-premises network team, including `10.x` advertisements and return routing.
- [ ] Keep old routes available during coexistence unless the change plan explicitly removes them; prevent unintended transitive access.
- [ ] Validate jumpbox-to-new-private-VM SSH/RDP, application-to-DB, DNS/NTP, package repositories, Object Storage endpoints and outbound dependencies.
- [ ] Validate symmetric firewall routing, inspection exceptions and approved TLS/IPSec controls.
- [ ] Prepare DNS TTL/cutover changes, target LB listeners/backends, health checks, certificates and external allowlists.
- [ ] Record old/new subnet, IP, endpoint and DNS mappings; do not assume old private IPs can transfer to the new VCN.

## 6. Application VMs, storage and containers

### VM compartment reassignment

- [ ] Take an application-consistent backup and prove restore usability; record attached boot/block volumes and backup policies.
- [ ] For a supported Compute move, select instance > Actions/More actions > Move Resource; independently verify the destination OCID before confirming.
- [ ] Verify instance OCID and compartment after completion. Associated boot volumes and VNICs do **not** automatically move with an instance; inventory them and plan supported separate moves or their intended shared placement.
- [ ] Re-test SSH/RDP, instance-principal permissions, backup execution, monitoring, patching and application health.

### VM migration into a new VCN/subnet

- [ ] Select a supported new-instance migration method: tested custom image/boot-volume workflow or clean rebuild plus data migration.
- [ ] Do not assume an existing primary VNIC can simply be reassigned to another VCN/subnet; validate a documented service-specific method before any exception.
- [ ] Confirm OS/shape/architecture, drivers, licensing, capacity and image compatibility. For applicable DataWalk/Hyperscience workloads, verify approved RHEL 8.10 and GPU driver/CUDA requirements.
- [ ] Remove or parameterize obsolete static IPs, routes, NTP references, network mounts and boot dependencies; follow OS/application vendor guidance.
- [ ] Deploy target VM with destination compartment, target subnet/NSGs, encryption keys and approved boot/block-volume layout.
- [ ] Reinstall/configure endpoint security, SIEM forwarding, vulnerability scanning, monitoring and backup agents/policies.
- [ ] Perform initial data copy, then quiesce writers and synchronize final data in the approved window.
- [ ] Keep the old workload recoverable but prevent simultaneous writers, duplicate scheduled jobs and identity/IP conflicts.
- [ ] Test app login, APIs, batch jobs, file transfers, performance and downstream consumers before traffic cutover.
- [ ] For FSS, separately validate file-system/mount-target/export placement, client permissions, data-copy method and final synchronization.
- [ ] For OKE, review cluster/node-pool network constraints; use a replacement cluster/node pools and workload redeployment when required rather than assuming compartment movement relocates networking.
- [ ] Back up manifests/Helm values and persistent data; validate secrets, registry pull access, ingress/LB, storage classes and GPU scheduling as applicable.

## 7. Database migration checklist

- [ ] Identify the exact service: Base DB, Exadata/VM cluster, Autonomous, MySQL, PostgreSQL or self-managed DB; assign the DBA and business owner.
- [ ] Record version/edition, size, encryption keys, backup retention, connectivity endpoints, replication and application credentials dependencies.
- [ ] Choose compartment-only reassignment or data migration to a new network/deployment; these are different changes.
- [ ] Verify service-specific direct-move support, dependent-resource behavior, lifecycle prerequisites and permissions against the deployed service documentation.
- [ ] For a compartment-only move, use the supported Move Resource workflow and verify DB, backup, network, key and monitoring access after completion.
- [ ] For new-network placement, select a supported method with the DBA: backup/restore, export/import, database migration service or replication; do not assume subnet changes are universally supported.
- [ ] Provision and patch target DB; validate licensing, storage, parameter settings, users/roles, TLS, security rules and key permissions.
- [ ] Test restore/recovery and confirm achievable RPO/RTO before production migration.
- [ ] Test a rehearsal with representative data; compare schema objects, row counts/checksums where appropriate, privileges, jobs and performance.
- [ ] During cutover, stop/redirect application writers, synchronize final changes and verify replication lag/recovery point.
- [ ] Update connection strings, DNS/wallet references and approved secret values through secure channels; do not commit credentials.
- [ ] Re-enable jobs and writes only on the approved authoritative database; verify transactional correctness and application acceptance.
- [ ] Define reverse synchronization or explicit data-loss boundary before permitting post-cutover writes. Old snapshots alone cannot safely roll back new transactions.

## 8. Cutover go/no-go gate

- [ ] Restore proof, rehearsal evidence, IAM/network tests and owner/security approvals attached to the change ticket.
- [ ] All blockers resolved; any accepted exception is explicit, time-bound and owned.
- [ ] Baseline health/performance recorded; monitoring and rollback owners present on the bridge.
- [ ] Exact resource/source/destination OCIDs and region read back by executor and reviewer.
- [ ] Cutover steps, expected duration, stop conditions and rollback deadline reviewed.
- [ ] Change authority gives recorded GO before writes or traffic changes; the gap collector's `YES` approves inventory only, not migration.
- [ ] Execute dependency-aware waves: prepare target network/shared services, migrate data services, migrate app/compute tiers, then switch ingress/DNS and consumers. Adjust ordering to the documented dependency graph.
- [ ] Record every operation, timestamp, work-request ID where applicable and result.

## 9. Acceptance, rollback and stabilization

- [ ] Test on-premises-to-app and app-to-DB paths, forward/return routes, DNS, certificates and firewall inspection.
- [ ] Confirm authentication/authorization, end-to-end transactions, data integrity, scheduled jobs and external integrations.
- [ ] Confirm logging/SIEM, alarms, vulnerability monitoring, backups, encryption and target-compartment administration.
- [ ] Compare latency, error rate and throughput against agreed baseline; business owner signs acceptance.
- [ ] Reconcile inventories/IaC state: supported moves preserve existing resource identity, while replacements need explicit old/new OCID mapping.
- [ ] Re-run the read-only gap analysis and review unresolved relationships; keep shared resources protected.
- [ ] Observe the agreed stabilization period: __________; retain rollback assets and routes until approved exit.
- [ ] On a stop condition, freeze new writes as appropriate, capture evidence and call the rollback authority.
- [ ] Compartment rollback: confirm old IAM remains valid and the reverse move is supported; validate all dependent-resource placement again.
- [ ] Workload rollback: follow approved data reconciliation/reverse replication, restore traffic/DNS and verify only one authoritative writer.

## 10. Decommission — separate approval, never automatic

- [ ] Confirm migration acceptance and rollback-window expiry in writing.
- [ ] Confirm no remaining shared, external, guest, DNS, DRG or application dependency.
- [ ] Confirm backup/export retention, legal holds, immutable evidence and recovery obligations.
- [ ] Obtain resource-owner, security and change approval for exact resource OCIDs.
- [ ] Remove resources in dependency-aware order using a separately reviewed runbook; do not delete a whole old compartment based on naming or age.
- [ ] Retire obsolete routes, NSG rules, DNS, credentials, dynamic-group rules and policies only after dependency verification.
- [ ] Reconcile residual cost, inventory, CM-2/CM-8 baseline, diagrams, operational runbooks and audit evidence.
- [ ] Delete an old compartment only when truly empty, approved and no longer needed; preserve retained artifacts elsewhere.
- [ ] Update repository memory with completed waves, outstanding blockers and next owner/action.

## 11. Automation boundary

This checklist adds no mutation script. Any future automation must use the Oracle OCI Python SDK, not OCI CLI subprocesses or custom REST. A migration executor must independently confirm tenancy, region, source compartment, destination compartment and exact resource OCIDs; display a complete mutation plan; require explicit approval; support a no-write planning mode; and keep deletion a separate approval workflow. Use generated SDK operations/models and verify service support before implementation.

## Official references

Reviewed 2026-10-01; recheck the relevant service before each execution.

- [Moving resources between compartments](https://docs.oracle.com/en-us/iaas/Content/Identity/compartments/To_move_a_resource_to_a_different_compartment.htm)
- [Moving Compute resources; boot volumes and VNICs are separate](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/movingresourcescompute.htm)
- [Moving an instance](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/inst-move.htm)
- [Moving a VCN; associated resources and asynchronous completion](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/move_vcn_compartment.htm)
- [Moving a subnet](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/move_subnet_compartment.htm)
- [Managing compartments and hierarchy moves](https://docs.oracle.com/iaas/Content/Identity/Tasks/managingcompartments.htm)
- [Moving a Base Database DB system](https://docs.oracle.com/en/cloud/paas/bm-and-vm-dbs-cloud/dbschangingcompartment/index.html)
- [Moving a PostgreSQL DB system](https://docs.oracle.com/en-us/iaas/Content/postgresql/move-db.htm)
- [Oracle OCI Python SDK](https://github.com/oracle/oci-python-sdk)
