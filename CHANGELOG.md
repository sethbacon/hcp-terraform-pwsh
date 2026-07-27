# Changelog

All notable changes to the TerraformCloud PowerShell module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.3](https://github.com/sethbacon/hcp-terraform-pwsh/compare/v1.4.2...v1.4.3) (2026-07-27)


### Bug Fixes

* **ci:** correct dependabot schedule interval from biweekly to weekly ([#27](https://github.com/sethbacon/hcp-terraform-pwsh/issues/27)) ([7c6dc39](https://github.com/sethbacon/hcp-terraform-pwsh/commit/7c6dc39c5496e6ed8a4aaa303bd547b0c0c2b3da))

## [1.4.2](https://github.com/sethbacon/hcp-terraform-pwsh/compare/v1.4.1...v1.4.2) (2026-05-28)


### Bug Fixes

* **ci:** grant security-events: write to reusable CI call in release ([#18](https://github.com/sethbacon/hcp-terraform-pwsh/issues/18)) ([43a93f7](https://github.com/sethbacon/hcp-terraform-pwsh/commit/43a93f7e07750442901092c2da467c86db449c17))

## [1.4.1](https://github.com/sethbacon/hcp-terraform-pwsh/compare/v1.4.0...v1.4.1) (2026-05-27)


### Bug Fixes

* **ci:** grant security-events: write to reusable CI workflow call ([#17](https://github.com/sethbacon/hcp-terraform-pwsh/issues/17)) ([20eb7fe](https://github.com/sethbacon/hcp-terraform-pwsh/commit/20eb7fe46468c5b755f6843363572d0bcfcc7b4f))
* **security:** declare OutputType and emit BOM to clear scan alerts ([#15](https://github.com/sethbacon/hcp-terraform-pwsh/issues/15)) ([c248e3a](https://github.com/sethbacon/hcp-terraform-pwsh/commit/c248e3a9650c1f568dc47b2a4656ba2e81c8e583))

## [1.4.0](https://github.com/sethbacon/hcp-terraform-pwsh/compare/v1.3.0...v1.4.0) (2026-05-26)


### Features

* **ci:** emit PSScriptAnalyzer SARIF and add Legitify scan ([#12](https://github.com/sethbacon/hcp-terraform-pwsh/issues/12)) ([302eae6](https://github.com/sethbacon/hcp-terraform-pwsh/commit/302eae617eb815b4abc2452a9606aa892e8c1d1c))


### Bug Fixes

* **ci:** remove CodeQL job from weekly security scan ([#11](https://github.com/sethbacon/hcp-terraform-pwsh/issues/11)) ([333e692](https://github.com/sethbacon/hcp-terraform-pwsh/commit/333e69244d817230c6c1be714a8d95407d34fecf))

## [1.3.0](https://github.com/sethbacon/hcp-terraform-pwsh/compare/v1.2.1...v1.3.0) (2026-05-23)


### Features

* add IP Allow Lists (CIDR Range Lists) cmdlets ([38d950c](https://github.com/sethbacon/hcp-terraform-pwsh/commit/38d950cd43a2e773b7c5a61343ecc9b778a98403))
* add project and team notification configuration cmdlets ([1850926](https://github.com/sethbacon/hcp-terraform-pwsh/commit/1850926c3444157fc20d9157de73d9694786eed0))
* add Queries cmdlets ([07b77cd](https://github.com/sethbacon/hcp-terraform-pwsh/commit/07b77cd65712e3577b212fc9d64d41fb8cb77c96))
* expand Stacks coverage with deployment groups, runs, steps, approvals ([c6be04f](https://github.com/sethbacon/hcp-terraform-pwsh/commit/c6be04ff3f471540e46c3adf1cb4e216df838ae1))
* expose new agent-pool, run-task, and project parameters ([7d65056](https://github.com/sethbacon/hcp-terraform-pwsh/commit/7d65056cd607cd6df5cbb61f7c4c885ac149c291))


### Documentation

* refresh API coverage gap analysis post-implementation ([1df58ae](https://github.com/sethbacon/hcp-terraform-pwsh/commit/1df58ae2fdeb1658a7a1388bf9df6f1344de45a2))
* update README with new functions and examples ([fc836fa](https://github.com/sethbacon/hcp-terraform-pwsh/commit/fc836fad78fa0e0d5e0cf10c720b09ffee1b8cc8))

## [1.2.1](https://github.com/sethbacon/hcp-terraform-pwsh/compare/v1.2.0...v1.2.1) (2026-05-22)


### Documentation

* add PSGallery badges and fix stale contributing section ([00cee4b](https://github.com/sethbacon/hcp-terraform-pwsh/commit/00cee4b4fe732f8396f0289d73fb349e0177a969))

## [1.2.0](https://github.com/sethbacon/hcp-terraform-pwsh/compare/v1.1.0...v1.2.0) (2026-05-22)


### Features

* automate release assets and PSGallery link in CI publish job ([ed7c3c7](https://github.com/sethbacon/hcp-terraform-pwsh/commit/ed7c3c7bbaa80c8fae4a31c78e8216b72da1b480))

## [1.1.0] - 2026-03-02

### Fixed

- Remove nonexistent `actions/setup-powershell@v1` from CI workflow; `pwsh` is pre-installed on all GitHub-hosted runners
- Fix build script path in CI from `./Build/build.ps1` to `./Build-Module.ps1`
- Fix push trigger branch name from `develop` to `development`
- Suppress `PSAvoidUsingConvertToSecureStringWithPlainText` on functions that legitimately convert plaintext tokens from environment variables and credential files
- Add `SupportsShouldProcess` to 10 state-changing functions (`Update-TfcAccount`, `Update-TfcAccountPassword`, `Update-TfcChangeRequest`, `New-TfcRegistryModuleTestConfigVersion`, `New-TfcRegistryModuleTestRun`, `New-TfcRegistryModuleTestVariable`, `Update-TfcRegistryModuleTestVariable`, `Update-TfcReservedTagKey`, `New-TfcGPGKey`, `Update-TfcGPGKey`)
- Fix unused `$response` variable in `Publish-TfcProviderVersion` and `Publish-TfcRegistryModuleVersion`
- Wire up unused `$OrganizationName` parameter in `Get-TfcAuditTrail` to the API URI
- Add `[OutputType()]` attributes to 14 functions missing return-type declarations
- Add PSScriptAnalyzer settings file to exclude `PSUseSingularNouns` rule (intentional naming: `*Details`, `*Settings`)

### Changed

- Rewrite README to reflect current 358-function module with accurate API coverage (~95%), complete function reference by category, and updated installation/contributing instructions

## [1.0.0] - 2025-10-17

### Added - Initial Release

#### Core Infrastructure

- PowerShell module manifest (`.psd1`) with proper metadata and 194 exported functions
- Single consolidated module file (`TerraformCloud.psm1`) with ~8,400 lines of code
- Cross-platform compatibility (PowerShell 5.1+ and 7.x)
- Dual-source authentication (TFE_TOKEN environment variable or credentials file)
- Comprehensive test suite with mock mode support
- Industry-standard comment-based help documentation for all functions
- MIT License with proper copyright attribution
- Build automation and validation scripts

#### Comprehensive API Coverage (194 Functions)

##### Run Triggers (4 functions)

- `Get-TfcRunTrigger` - List run triggers for a workspace
- `New-TfcRunTrigger` - Create run trigger to link workspace to source workspace
- `Remove-TfcRunTrigger` - Delete run trigger with confirmation
- `Show-TfcRunTrigger` - Get specific run trigger details

##### Run Tasks (8 functions)

- `Get-TfcRunTask` - List organization run tasks
- `New-TfcRunTask` - Create new run task integration
- `Update-TfcRunTask` - Update run task URL and HMAC key
- `Remove-TfcRunTask` - Delete run task with confirmation
- `Get-TfcWorkspaceRunTask` - List run tasks attached to workspace
- `Add-TfcWorkspaceRunTask` - Attach run task to workspace with stage/enforcement
- `Update-TfcWorkspaceRunTask` - Update workspace run task configuration
- `Remove-TfcWorkspaceRunTask` - Remove run task from workspace

##### Notification Configurations (5 functions)

- `Get-TfcNotificationConfiguration` - List workspace notification configurations
- `New-TfcNotificationConfiguration` - Create notification (email, Slack, webhook, Microsoft Teams)
- `Update-TfcNotificationConfiguration` - Update notification settings and triggers
- `Remove-TfcNotificationConfiguration` - Delete notification configuration
- `Test-TfcNotificationConfiguration` - Send test notification to verify configuration

##### Enhanced Plans & Applies (7 functions)

- `Get-TfcPlanJson` - Retrieve structured JSON output from plan
- `Get-TfcPlanLog` - Get raw plan logs for debugging
- `Get-TfcApplyLog` - Get raw apply logs for audit trails
- `New-TfcPlanExport` - Create plan export (JSON format)
- `Get-TfcPlanExport` - Download plan export data
- `Get-TfcPlan` - Get plan information
- `Get-TfcApply` - Get apply information

##### Workspace Team Access (4 functions)

- `Add-TfcWorkspaceTeamAccess` - Grant team access to workspace with granular permissions
- `Update-TfcWorkspaceTeamAccess` - Modify team access levels (read, plan, write, admin, custom)
- `Remove-TfcWorkspaceTeamAccess` - Revoke team access from workspace
- `Show-TfcWorkspaceTeamAccess` - Get specific team access details

##### Agent Pools & Agents (5 functions)

- `Get-TfcAgentPool` - List organization agent pools or get specific pool
- `New-TfcAgentPool` - Create new agent pool for self-hosted agents
- `Update-TfcAgentPool` - Update agent pool name
- `Remove-TfcAgentPool` - Delete agent pool with confirmation
- `Get-TfcAgent` - List agents in agent pool

##### Agent Tokens (3 functions)

- `Get-TfcAgentToken` - List tokens for agent pool
- `New-TfcAgentToken` - Create agent token for agent authentication
- `Remove-TfcAgentToken` - Delete agent token with confirmation

##### SSH Keys (5 functions)

- `Get-TfcSSHKey` - List organization SSH keys or get specific key
- `New-TfcSSHKey` - Create SSH key for Git repository access
- `Update-TfcSSHKey` - Update SSH key name
- `Remove-TfcSSHKey` - Delete SSH key with confirmation
- `Set-TfcWorkspaceSSHKey` - Assign SSH key to workspace (or unassign)

##### Token Management (7 functions)

- `New-TfcTeamToken` - Generate authentication token for team
- `Remove-TfcTeamToken` - Delete team token with confirmation
- `New-TfcOrganizationToken` - Generate authentication token for organization
- `Remove-TfcOrganizationToken` - Delete organization token with confirmation
- `Get-TfcUserToken` - List user tokens
- `New-TfcUserToken` - Generate user authentication token
- `Remove-TfcUserToken` - Delete user token with confirmation

##### Additional Workspace Features (3 functions)

- `Get-TfcWorkspaceResource` - List resources managed by workspace
- `Get-TfcCostEstimate` - Get cost estimate for run
- `Get-TfcVCSEvent` - List VCS events (commits) for workspace

##### Policy Management & Compliance (17 functions)

- `Get-TfcPolicy` - List Sentinel/OPA policies in organization
- `New-TfcPolicy` - Create new policy with enforcement level
- `Update-TfcPolicy` - Update policy enforcement and settings
- `Remove-TfcPolicy` - Delete policy with confirmation
- `Invoke-TfcPolicyUpload` - Upload policy code content
- `Get-TfcPolicySet` - List policy sets in organization
- `New-TfcPolicySet` - Create new policy set
- `Update-TfcPolicySet` - Update policy set configuration
- `Remove-TfcPolicySet` - Delete policy set with confirmation
- `Add-TfcPolicySetPolicy` - Add policy to policy set
- `Set-TfcPolicySetWorkspace` - Assign policy set to workspaces
- `Set-TfcPolicySetProject` - Assign policy set to projects
- `Get-TfcPolicyCheck` - Get policy check results for run
- `Set-TfcPolicyCheckOverride` - Override soft-mandatory policy failures
- `Get-TfcAuditTrail` - Get audit trail events for organization
- `Get-TfcComment` - Get comments on runs
- `New-TfcComment` - Add comments to runs

##### Enhanced RBAC & Variables (20 functions)

- `Get-TfcVariableSetVariable` - Get variables in variable set
- `New-TfcVariableSetVariable` - Create variable in variable set
- `Update-TfcVariableSetVariable` - Update variable set variable
- `Remove-TfcVariableSetVariable` - Delete variable set variable
- `Get-TfcTeamMember` - List team organization memberships
- `Add-TfcTeamMember` - Add members to team
- `Get-TfcTeamMemberDetails` - Get specific team member details
- `Remove-TfcTeamMember` - Remove members from team
- `Add-TfcProjectTeamAccess` - Grant team access to project
- `Get-TfcProjectTeamAccess` - List project team access
- `Get-TfcProjectTeamAccessDetails` - Get specific project team access details
- `Update-TfcProjectTeamAccess` - Update project team access permissions
- `Remove-TfcProjectTeamAccess` - Revoke team access from project
- `Get-TfcOrganizationMembership` - List organization memberships
- `Remove-TfcOrganizationMembership` - Remove user from organization
- `Get-TfcOrganizationTag` - List organization tags
- `New-TfcOrganizationTag` - Create organization tag
- `Remove-TfcOrganizationTag` - Delete organization tag
- `Add-TfcOrganizationTagRelationship` - Tag workspaces
- `Remove-TfcOrganizationTagRelationship` - Untag workspaces

##### Extended Run/Resource Management (15 functions)

- `Get-TfcRunDetails` - Get detailed run information with relationships
- `Get-TfcRunTaskResult` - Get run task results for a run
- `Get-TfcRunTaskResultDetails` - Get detailed run task result information
- `Get-TfcWorkspaceResourceDetails` - Get detailed workspace resource information
- `Get-TfcOAuthToken` - List OAuth tokens for an OAuth client
- `Get-TfcOAuthTokenDetails` - Get detailed OAuth token information
- `Update-TfcOAuthToken` - Update an OAuth token
- `Remove-TfcOAuthToken` - Remove an OAuth token
- `Get-TfcAssessmentResult` - Get drift detection and health check results
- `Get-TfcAssessmentResultDetails` - Get detailed assessment result information
- `Get-TfcCostEstimateLog` - Download cost estimate logs
- `Get-TfcVCSEventDetails` - Get detailed VCS event information
- `Invoke-TfcStateRollback` - Rollback workspace to previous state

##### New Features & Innovation (20 functions)

- `Get-TfcChangeRequest` - List change requests for structured approval workflows
- `New-TfcChangeRequest` - Create a new change request
- `Get-TfcChangeRequestDetails` - Get detailed change request information
- `Approve-TfcChangeRequest` - Approve a change request to allow it to proceed
- `Deny-TfcChangeRequest` - Reject a change request to prevent it from proceeding
- `New-TfcNoCodeModule` - Create no-code module for self-service provisioning
- `Get-TfcNoCodeModule` - Get no-code module information
- `Update-TfcNoCodeModule` - Update a no-code module's configuration
- `Remove-TfcNoCodeModule` - Delete a no-code module
- `Update-TfcNoCodeModuleVariableOptions` - Upgrade variable options for no-code module
- `Get-TfcGitHubAppInstallation` - List GitHub App installations
- `Get-TfcGitHubAppInstallationDetails` - Get detailed GitHub App installation information
- `Invoke-TfcExplorerQuery` - Execute a GraphQL explorer query
- `Get-TfcIPRange` - Get Terraform Cloud IP ranges for network configuration
- `Get-TfcFeatureSet` - List available feature sets
- `Get-TfcFeatureSetDetails` - Get detailed feature set information

##### Enterprise & Admin Features (18 functions)

- `Get-TfcAdminSettings` - Get admin organization settings (requires admin access)
- `Update-TfcAdminSettings` - Update admin organization settings (requires admin access)
- `Get-TfcSAMLSettings` - Get SAML SSO configuration for an organization
- `Update-TfcSAMLSettings` - Update SAML SSO configuration for an organization
- `Revoke-TfcSAMLSettings` - Disable and remove SAML SSO configuration
- `Get-TfcAdminUser` - List admin users in Terraform Cloud
- `Suspend-TfcUser` - Suspend a user account (requires admin access)
- `Resume-TfcUser` - Reactivate a suspended user account (requires admin access)
- `Grant-TfcAdminPrivilege` - Grant site admin privileges to a user
- `Revoke-TfcAdminPrivilege` - Revoke site admin privileges from a user
- `Disable-TfcUserTwoFactor` - Disable 2FA for a user account (emergency use only)
- `New-TfcUserImpersonation` - Create an impersonation token to act as another user
- `Get-TfcRegistrySettings` - Get private registry settings for an organization
- `Update-TfcRegistrySettings` - Update private registry settings for an organization
- `Get-TfcSubscription` - Get billing subscription information (requires admin access)
- `Get-TfcInvoice` - Get billing invoices for an organization (requires admin access)
- `Get-TfcTwoFactorSettings` - Get 2FA settings for an organization
- `Update-TfcTwoFactorSettings` - Update 2FA requirements for an organization

##### Account & Organizations (6 functions)

- `Get-TfcAccount` - Get current user account information
- `Get-TfcOrganization` - Get organizations with optional filtering
- `Get-TfcOrganizationEntitlements` - Get feature entitlements for organizations
- `New-TfcOrganization` - Create new organizations
- `Update-TfcOrganization` - Update organization settings
- `Remove-TfcOrganization` - Delete organizations with confirmation

##### Projects (4 functions)

- `Get-TfcProject` - List projects or get specific project details
- `New-TfcProject` - Create new projects with descriptions
- `Update-TfcProject` - Update project names and descriptions
- `Remove-TfcProject` - Delete projects with confirmation

##### Workspaces (9 functions)

- `Get-TfcWorkspace` - Get workspaces with pagination and filtering
- `New-TfcWorkspace` - Create new workspaces with full configuration
- `Update-TfcWorkspace` - Update workspace settings
- `Remove-TfcWorkspace` - Delete workspaces with confirmation
- `Lock-TfcWorkspace` - Lock workspaces to prevent runs
- `Unlock-TfcWorkspace` - Unlock workspaces
- `Find-TfcWorkspace` - Find workspaces across organizations
- `Get-TfcWorkspaceTag` - Get tags assigned to a workspace
- `Set-TfcWorkspaceTag` - Add or replace workspace tags

##### Variables & Variable Sets (10 functions)

- `Get-TfcWorkspaceVariable` - Get workspace variables
- `Set-TfcWorkspaceVariable` - Create workspace variables
- `Update-TfcWorkspaceVariable` - Update existing variables
- `Remove-TfcWorkspaceVariable` - Delete workspace variables
- `Get-TfcVariableSet` - Get organization variable sets
- `New-TfcVariableSet` - Create new variable sets
- `Update-TfcVariableSet` - Update existing variable sets
- `Remove-TfcVariableSet` - Delete variable sets
- `Set-TfcVariableSetWorkspace` - Assign variable set to workspaces
- `Remove-TfcVariableSetWorkspace` - Remove variable set from workspaces

##### Configuration Versions (4 functions)

- `Get-TfcConfigurationVersionList` - List configuration versions for workspace
- `Get-TfcConfigurationVersion` - Get specific configuration version details
- `New-TfcConfigurationVersion` - Create new configuration version (prepare for upload)
- `Invoke-TfcConfigurationUpload` - Upload Terraform code tarball to configuration version

##### Runs, Plans & Applies (9 functions)

- `Get-TfcRun` - Get workspace runs with pagination
- `New-TfcRun` - Create new runs
- `Confirm-TfcRun` - Apply runs (approve)
- `Deny-TfcRun` - Discard runs (reject)
- `Stop-TfcRun` - Cancel in-progress runs
- `Stop-TfcRunForce` - Force cancel stuck runs
- `Invoke-TfcRunForceExecute` - Force execute runs bypassing queue
- `Get-TfcPlan` - Get plan information
- `Get-TfcApply` - Get apply information

##### State Management (4 functions)

- `Get-TfcCurrentStateVersion` - Get current state with download option
- `Get-TfcStateVersion` - List state versions or get specific version
- `New-TfcStateVersion` - Push new state versions (state migration)
- `Get-TfcStateVersionOutput` - Get outputs from state versions

##### Registry Modules (3 functions)

- `Get-TfcRegistryModule` - List or get registry modules
- `New-TfcRegistryModule` - Create modules from VCS repositories
- `Remove-TfcRegistryModule` - Delete registry modules

##### Registry Providers (3 functions)

- `Get-TfcRegistryProvider` - List or get registry providers
- `New-TfcRegistryProvider` - Create custom providers
- `Remove-TfcRegistryProvider` - Delete registry providers

##### Teams & Access (7 functions)

- `Get-TfcTeam` - Get organization teams
- `Get-TfcTeamAccess` - Get team workspace access
- `New-TfcTeam` - Create new teams
- `Update-TfcTeam` - Update team properties
- `Remove-TfcTeam` - Delete teams with confirmation
- `Get-TfcOAuthClient` - Get VCS providers (OAuth clients)
- `Get-TfcCurrentUser` - Get current user information

##### Utility Functions (3 functions)

- `Invoke-TfcApi` - Generic API call function for any endpoint
- `Test-TfcWorkspaceId` - Validate workspace ID format
- Private helper functions for pagination and connection management

#### Testing & Development

- Comprehensive test suite with 130 tests and mock mode support
- Build automation system (`Build-Module.ps1`) with validation and packaging
- PowerShell Script Analyzer integration for code quality
- Setup scripts for test organization configuration

#### Documentation

- Comprehensive README with quick start and examples
- Comment-based help documentation for all 147 functions
- TESTING.md guide for test suite usage
- API coverage analysis documenting ~59% endpoint coverage
- CHANGELOG following Keep a Changelog format

### API Coverage Summary

**Total Functions: 194** covering major Terraform Cloud API capabilities

**Coverage Statistics:**

- ~77% of Terraform Cloud API endpoints covered
- Comprehensive workspace, run, state, and variable management
- Full policy management and compliance features
- Enhanced RBAC with team membership and project access
- Enterprise features: agent pools, SSH keys, token management
- Advanced features: change requests, no-code provisioning, GraphQL queries
- Enterprise admin: SAML/SSO, user management, registry settings, billing

**Covered Categories:**

- ✅ Account & Organization Management (6 functions)
- ✅ Projects (4 functions)
- ✅ Workspaces (9 functions)
- ✅ Variables & Variable Sets (14 functions - includes variable set variables)
- ✅ Configuration Versions (4 functions)
- ✅ Runs, Plans & Applies (19 functions - enhanced with JSON/logs/details)
- ✅ State Management (5 functions - includes rollback)
- ✅ Registry Modules (3 functions)
- ✅ Registry Providers (3 functions)
- ✅ Teams & Access (15 functions - enhanced with membership & project access)
- ✅ Run Triggers (4 functions)
- ✅ Run Tasks (11 functions - includes task results)
- ✅ Notification Configurations (5 functions)
- ✅ Agent Pools & Agents (8 functions)
- ✅ SSH Keys (5 functions)
- ✅ Token Management (7 functions)
- ✅ Policy Management (17 functions - Sentinel/OPA policies, policy sets, checks)
- ✅ Organization Management (7 functions - memberships, tags)
- ✅ OAuth Management (4 functions - tokens)
- ✅ Assessment & Drift Detection (2 functions)
- ✅ Change Requests (5 functions - structured approval workflows)
- ✅ No-Code Provisioning (5 functions - self-service infrastructure)
- ✅ GitHub Integrations (2 functions - App installations)
- ✅ Advanced Query (1 function - GraphQL explorer)
- ✅ Network Configuration (1 function - IP ranges)
- ✅ Feature Sets (2 functions)
- ✅ Enterprise Admin (18 functions - SAML, user management, registry, billing, 2FA)
- ✅ Organization Management (7 functions - memberships, tags)
- ✅ Additional Features (3 functions - workspace resources, cost estimates, VCS events)

### Migration from Previous Scripts

| Old Script                        | New Function                      |
| --------------------------------- | --------------------------------- |
| `Get-TFCCurrentState.ps1`         | `Get-TfcCurrentStateVersion`      |
| `Get-TFCEntitlementSet.ps1`       | `Get-TfcOrganizationEntitlements` |
| `Get-TFCTeamAccess.ps1`           | `Get-TfcTeamAccess`               |
| `Get-TFCTeams.ps1`                | `Get-TfcTeam`                     |
| `Get-TFCUserFromToken.ps1`        | `Get-TfcCurrentUser`              |
| `Get-TFCWorkspaces.ps1`           | `Get-TfcWorkspace`                |
| `Get-TFCWorkspaceVariables.ps1`   | `Get-TfcWorkspaceVariable`        |
| `Set-TFCWorkspaceVariable.ps1`    | `Set-TfcWorkspaceVariable`        |
| `Update-TFCWorkspaceVariable.ps1` | `Update-TfcWorkspaceVariable`     |
| `Remove-TFCWorkspaceVariable.ps1` | `Remove-TfcWorkspaceVariable`     |
| `Find-TFCWorkspace.ps1`           | `Find-TfcWorkspace`               |
| `Test-TFCWorkspaceId.ps1`         | `Test-TfcWorkspaceId`             |

---

## Previous Individual Script Versions

### [0.1.9] - 2020-02-05

- Added Set-TFCWorkspaceAzureClientSecret

### [0.1.8] - 2020-01-29

- Added List-TFCWorkspaceVersions
- Changed ATLAS_TOKEN to TFE_TOKEN

### [0.1.7] - 2020-01-28

- Updated Set-TFCWorkspaceVariable for new API version
- Updated Get-TFCWorkspaceVariables for new API version
- Added Remove-TFCWorkspaceVariable
- Added Update-TFCWorkspaceVariable
- Added Rotate-TFCWorkspaceAWSAccessKeys
- Added Set-TFCWorkspaceAwsAccessKeys

### [0.1.6] - 2019-11-18

- Added Get-TFCEntitlementSet.ps1

### [0.1.5] - 2019-11-04

- Fix Test-Path issue

### [0.1.4] - 2019-10-30

- Change organization param to optional on Get-TFCWorkspaces.ps1
- Added switch to get all pages to Get-TFCWorkspaces.ps1
- Added Get-TFCCurrentState.ps1
- Added check for ATLAS_TOKEN to all scripts

### [0.1.3] - 2019-10-22

- Added Get-TFCUserFromToken.ps1

### [0.1.2] - 2019-09-27

- Updated NOTICE

### [0.1.1] - 2019-09-27

- Added NOTICE
- Added Set-TFCWorkspaceVariable.ps1

### [0.1.0] - 2019-09-20

- Initial Release with individual PowerShell scripts
