# HCP Terraform API Coverage — Gap Analysis

**Analysis Date:** May 22, 2026 (post-implementation)
**Module Version:** 1.3.0 (unreleased)
**Exported Functions:** 396
**API Reference:** [developer.hashicorp.com/terraform/cloud-docs/api-docs](https://developer.hashicorp.com/terraform/cloud-docs/api-docs)

## Executive Summary

This analysis follows the May 22, 2026 implementation cycle that closed every P0–P2 gap identified in the prior analysis. The module gained **38 new functions** and **9 parameter additions** to existing functions:

- **IP Allow Lists** — 12 new functions covering the full `/cidr-range-lists` API.
- **Queries** — 4 new functions for async workspace-resource queries.
- **Project + Team Notifications** — 4 new functions for the project- and team-scoped variants.
- **Stack ecosystem expansion** — 18 new functions covering deployment groups, deployment runs, deployment steps, approvals, configuration diagnostics, upload URL, source bundle, and VCS refetch.
- **Parameter additions** — Agent Pool scoping (`AllowedProjects` / `ExcludedWorkspaces`), Run Task agent-pool routing (`AgentPoolId`), Project defaults (`DefaultExecutionMode` / `DefaultAgentPoolId` / `AutoDestroyActivityDuration`).

**Headline numbers**

| Metric                                              |        Value | Delta vs prior |
| --------------------------------------------------- | -----------: | -------------: |
| Exported functions                                  |          396 |            +38 |
| Net-new categories missing entirely                 |            0 |             −4 |
| Existing categories with enhancement gaps           |            0 |             −4 |
| Estimated endpoint coverage                         |        ~98%  |          +10pp |
| Unit tests passing                                  |       937/937|            +38 |

The module is now substantially complete against the public HCP Terraform API surface. The remaining ~2% gap is limited to two HashiCorp release-note items whose public reference pages do not yet exist (see §3).

---

## 1. Implemented in This Cycle

### 1.1 IP Allow Lists (CIDR Range Lists) — 12 / 12 endpoints

| Method | Path                                                          | Function                                 |
| ------ | ------------------------------------------------------------- | ---------------------------------------- |
| GET    | `/organizations/:org/cidr-range-lists`                        | `Get-TfcIPAllowList`                     |
| POST   | `/organizations/:org/cidr-range-lists`                        | `New-TfcIPAllowList`                     |
| GET    | `/cidr-range-lists/:id`                                       | `Get-TfcIPAllowListDetails`              |
| PATCH  | `/cidr-range-lists/:id`                                       | `Update-TfcIPAllowList`                  |
| DELETE | `/cidr-range-lists/:id`                                       | `Remove-TfcIPAllowList`                  |
| GET    | `/cidr-range-lists/:id/relationships/cidr-ranges`             | `Get-TfcIPAllowListRange`                |
| POST   | `/cidr-range-lists/:id/relationships/cidr-ranges`             | `Add-TfcIPAllowListRange`                |
| GET    | `/cidr-ranges/:id`                                            | `Get-TfcIPAllowListRangeDetails`         |
| PATCH  | `/cidr-ranges/:id`                                            | `Update-TfcIPAllowListRange`             |
| DELETE | `/cidr-ranges/:id`                                            | `Remove-TfcIPAllowListRange`             |
| POST   | `/cidr-range-lists/:id/relationships/agent-pools`             | `Add-TfcIPAllowListAgentPool`            |
| DELETE | `/cidr-range-lists/:id/relationships/agent-pools`             | `Remove-TfcIPAllowListAgentPool`         |

### 1.2 Queries — 4 / 4 endpoints

| Method | Path                                       | Function               |
| ------ | ------------------------------------------ | ---------------------- |
| POST   | `/queries`                                 | `New-TfcQuery`         |
| GET    | `/workspaces/:workspace_id/queries`        | `Get-TfcQuery`         |
| GET    | `/queries/:query_id`                       | `Get-TfcQueryDetails`  |
| POST   | `/queries/:query_id/actions/cancel`        | `Stop-TfcQuery`        |

### 1.3 Project + Team Notifications — 4 functions

The PATCH/DELETE/verify endpoints at `/notification-configurations/:id` are already covered by the existing workspace cmdlets. This cycle added the scope-specific POST + LIST functions:

- `New-TfcProjectNotificationConfiguration` (`POST /projects/:id/notification-configurations`)
- `Get-TfcProjectNotificationConfiguration` (`GET /projects/:id/notification-configurations`)
- `New-TfcTeamNotificationConfiguration` (`POST /teams/:id/notification-configurations`)
- `Get-TfcTeamNotificationConfiguration` (`GET /teams/:id/notification-configurations`)

### 1.4 Stack Ecosystem — 18 new functions

**Stack Configurations (4 new):**
- `Invoke-TfcStackFetchLatestVCS` (`POST /stacks/:id/fetch-latest-from-vcs`)
- `Get-TfcStackConfigurationDiagnostic` (`GET .../stack-diagnostics`)
- `Get-TfcStackConfigurationUploadUrl` (`GET .../upload-url`)
- `Save-TfcStackConfigurationSourceBundle` (`GET .../source-bundle`)

**Stack Deployment Groups (4 new):**
- `Get-TfcStackDeploymentGroup` (list + show by name)
- `Get-TfcStackDeploymentGroupDetails` (show by id)
- `Approve-TfcStackDeploymentGroupPlans`
- `Restart-TfcStackDeploymentGroup`

**Stack Deployment Runs (4 new):**
- `Get-TfcStackDeploymentRun` (by group or by stack+deployment-name)
- `Get-TfcStackDeploymentRunDetails`
- `Approve-TfcStackDeploymentRunPlans`
- `Stop-TfcStackDeploymentRun`

**Stack Deployment Steps (5 new):**
- `Get-TfcStackDeploymentStep`
- `Get-TfcStackDeploymentStepDetails`
- `Get-TfcStackDeploymentStepDiagnostic`
- `Get-TfcStackDeploymentStepArtifact`
- `Invoke-TfcStackDeploymentStepAdvance`

**Stack Approvals (1 new):**
- `Get-TfcStackApproval`

### 1.5 Parameter Additions (9 new params on 6 existing functions)

| Function              | New Parameters                                                                      |
| --------------------- | ----------------------------------------------------------------------------------- |
| `New-TfcAgentPool`    | `-AllowedProjects`, `-ExcludedWorkspaces`                                            |
| `Update-TfcAgentPool` | `-AllowedProjects`, `-ExcludedWorkspaces`                                            |
| `New-TfcRunTask`      | `-AgentPoolId`                                                                       |
| `Update-TfcRunTask`   | `-AgentPoolId`                                                                       |
| `New-TfcProject`      | `-DefaultExecutionMode`, `-DefaultAgentPoolId`, `-AutoDestroyActivityDuration`       |
| `Update-TfcProject`   | `-DefaultExecutionMode`, `-DefaultAgentPoolId`, `-AutoDestroyActivityDuration`       |

---

## 2. Remaining Gaps

### 2.1 Stack Deployment Group Summaries — 1 endpoint

`GET /stack-configurations/:id/stack-deployment-group-summaries` — a summary view that overlaps with `Get-TfcStackDeploymentGroup`. Low priority; can be added on demand as `Get-TfcStackDeploymentGroupSummary` if a user reports needing the summary projection.

### 2.2 Endpoints flagged in release notes but with 404 reference pages

These were carried forward from the prior analysis. The status is unchanged — HashiCorp's release notes mention them, but the public API reference pages return 404 at the time of writing, so the exact endpoint shape cannot be verified.

- **Module Version Revocation** (May 2025) — release notes mention `revoke` / `revert-revoke` actions for module versions, but no documented endpoints.
- **Stack Component Configurations / Registry Components** (Dec 2025) — release notes describe `/registry-components` endpoints; `private-registry/components` and `private-registry/component-configurations` both 404.

**Recommendation:** wait for HashiCorp to publish the reference pages, then implement against documented behavior. Implementing against undocumented endpoints risks breakage when the public API is finalized.

---

## 3. Coverage Summary by Category

| Category                          | Endpoints | Implemented | Coverage |
| --------------------------------- | :-------: | :---------: | :------: |
| **Core Resources**                |           |             |          |
| Account / Users                   |     9     |      9      |   100%   |
| Organizations                     |    10     |     10      |   100%   |
| Organization Memberships          |     5     |      5      |   100%   |
| Organization Tags                 |     7     |      7      |   100%   |
| Organization Tokens               |     3     |      3      |   100%   |
| Reserved Tag Keys                 |     3     |      3      |   100%   |
| Projects                          |     9     |      9      |   100%   |
| Project Team Access               |     5     |      5      |   100%   |
| Workspaces                        |    17     |     17      |   100%   |
| Workspace Resources               |     3     |      3      |   100%   |
| Variables                         |     5     |      5      |   100%   |
| Variable Sets                     |    11     |     11      |   100%   |
| **Execution**                     |           |             |          |
| Runs                              |    14     |     14      |   100%   |
| Run Triggers                      |     4     |      4      |   100%   |
| Run Tasks                         |    10     |     10      |   100%   |
| Plans / Applies / Plan Exports    |    15     |     15      |   100%   |
| Cost Estimates                    |     3     |      3      |   100%   |
| Configuration Versions            |     7     |      7      |   100%   |
| State Versions                    |    11     |     11      |   100%   |
| **Teams & Access**                |           |             |          |
| Teams / Membership / Tokens       |    13     |     13      |   100%   |
| Workspace Team Access             |     5     |      5      |   100%   |
| **Policy**                        |           |             |          |
| Policies / Sets / Parameters      |    22     |     22      |   100%   |
| Policy Checks / Evaluations       |     7     |      7      |   100%   |
| Policy Set Outcomes               |     2     |      2      |   100%   |
| **Registry**                      |           |             |          |
| Registry Modules                  |    14     |     14      |   100%   |
| Registry Providers                |    10     |     10      |   100%   |
| Registry Module/Provider Versions |    10     |     10      |   100%   |
| Provider Platforms                |     4     |      4      |   100%   |
| Registry Webhooks / Settings      |     7     |      7      |   100%   |
| Registry Module Tests             |    11     |     11      |   100%   |
| GPG Keys                          |     5     |      5      |   100%   |
| **VCS / Integrations**            |           |             |          |
| OAuth Clients / Tokens            |    11     |     11      |   100%   |
| VCS Events                        |     3     |      3      |   100%   |
| GitHub App Installations          |     3     |      3      |   100%   |
| **Enterprise / Security**         |           |             |          |
| Agent Pools / Agents / Tokens     |    13     |     13      |   100%   |
| SSH Keys                          |     5     |      5      |   100%   |
| Audit Trails / Tokens             |     5     |      5      |   100%   |
| HYOK                              |    11     |     11      |   100%   |
| SAML / 2FA Settings               |     7     |      7      |   100%   |
| **Advanced**                      |           |             |          |
| Stacks (core)                     |     6     |      6      |   100%   |
| Stack Configurations              |     8     |      7      |   **88%**|
| Stack Deployments / Runs / Steps  |    17     |     17      |   100%   |
| Drift Detection                   |     4     |      4      |   100%   |
| Change Requests                   |     8     |      8      |   100%   |
| No-Code Provisioning              |     8     |      8      |   100%   |
| Workspace Notifications           |     6     |      6      |   100%   |
| Project Notifications             |     6     |      6      |   100%   |
| Team Notifications                |     6     |      6      |   100%   |
| Comments                          |     3     |      3      |   100%   |
| Assessment Results                |     5     |      5      |   100%   |
| **Admin / Billing**               |           |             |          |
| Admin Settings / Users            |    12     |     12      |   100%   |
| Feature Sets / Subscriptions      |     6     |      6      |   100%   |
| Invoices                          |     3     |      3      |   100%   |
| **Utility / Misc**                |           |             |          |
| IP Ranges (meta)                  |     1     |      1      |   100%   |
| IP Allow Lists / CIDR Ranges      |    12     |     12      |   100%   |
| Explorer (GraphQL)                |     1     |      1      |   100%   |
| Queries                           |     4     |      4      |   100%   |
| Group Member Roles                |     2     |      2      |   100%   |

`Stack Configurations` shows 88% because `GET /stack-deployment-group-summaries` is not implemented — see §2.1. Every other documented category is at 100%.

---

## 4. Quality Metrics

- **Unit tests:** 937 passing, 0 failing (29s runtime).
- **PSScriptAnalyzer:** clean on all new files; only pre-existing warning is the BOM-encoding note on the compiled `.psm1` (a build-step artifact, not a source issue).
- **Module manifest:** valid; 396 functions exported.
- **Build:** clean compile and import on PowerShell 7.

---

## 5. Notes on Methodology

- Function inventory: `find src/Public -name "*.ps1"` — 396 files, 396 unique function names.
- API inventory: `developer.hashicorp.com/terraform/cloud-docs/api-docs` (May 2026 snapshot).
- Parameter additions verified by grepping module source for the new parameter names against the relevant function files.
- §2.2 items remain flagged for verification — the release-note references are real, but the public endpoint pages were unavailable at analysis time.
