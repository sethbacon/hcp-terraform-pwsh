# HCP Terraform PowerShell Module - Function Reference

Generated on: 2026-03-01

This document contains reference documentation for all 358 public functions in the HCP Terraform PowerShell module.

---

## Add-TfcOrganizationTagRelationship

**Synopsis:** Adds workspace relationships to a tag

**Description:** Associates one or more workspaces with a specific tag by creating tag-workspace relationships

**Parameters:**

- **TagId** (string): The tag ID
- **WorkspaceIds** (string[]): Array of workspace IDs to associate with the tag

**Examples:**

```powershell
Add-TfcOrganizationTagRelationship -TagId "tag-abc123" -WorkspaceIds @("ws-123", "ws-456")
```

---

## Add-TfcPolicySetPolicy

**Synopsis:** Adds policies to a policy set

**Description:** Attaches one or more policies to a policy set

**Parameters:**

- **PolicySetId** (string): The policy set ID
- **PolicyIds** (string[]): Array of policy IDs to add

**Examples:**

```powershell
Add-TfcPolicySetPolicy -PolicySetId "polset-123" -PolicyIds @("pol-1", "pol-2")
```

---

## Add-TfcProjectTeamAccess

**Synopsis:** Adds team access to a project

**Description:** Grants a team access to a project with configurable permission levels including runs, variables, state versions, sentinel mocks, and workspace locking

**Parameters:**

- **ProjectId** (string): The project ID
- **TeamId** (string): The team ID to grant access to
- **Access** (string): Access level ('read', 'maintain', 'admin', or 'write')
- **RunsAccess** (string): Custom permission for runs ('read', 'write', 'apply', or 'none')
- **VariablesAccess** (string): Custom permission for variables ('read', 'write', or 'none')
- **StateVersionsAccess** (string): Custom permission for state versions ('read', 'write', or 'none')
- **SentinelMocksAccess** (string): Custom permission for sentinel mocks ('read', 'write', or 'none')
- **WorkspaceLockingAccess** (string): Custom permission for workspace locking ('read', 'write', or 'none')

**Examples:**

```powershell
Add-TfcProjectTeamAccess -ProjectId "prj-abc123" -TeamId "team-xyz789" -Access "read"
```

---

## Add-TfcTagWorkspace

**Synopsis:** Adds workspaces to a tag

**Description:** Associates one or more workspaces with a specific tag

**Parameters:**

- **TagId** (string): The tag ID
- **WorkspaceIds** (string[]): Array of workspace IDs to add to the tag

**Examples:**

```powershell
Add-TfcTagWorkspace -TagId "tag-abc123" -WorkspaceIds @("ws-abc123", "ws-def456")
```

---

## Add-TfcTeamMember

**Synopsis:** Adds members to a team

**Description:** Adds one or more organization members to a team using their organization membership IDs

**Parameters:**

- **TeamId** (string): The team ID
- **OrganizationMembershipIds** (string[]): Array of organization membership IDs to add to the team

**Examples:**

```powershell
Add-TfcTeamMember -TeamId "team-abc123" -OrganizationMembershipIds @("ou-123", "ou-456")
```

---

## Add-TfcWorkspaceRunTask

**Synopsis:** Attaches a run task to a workspace

**Description:** Creates a relationship between a run task and a workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **RunTaskId** (string): The run task ID to attach
- **EnforcementLevel** (string): Enforcement level: 'advisory' or 'mandatory'
- **Stage** (string): Stage to run: 'pre_plan', 'post_plan', 'pre_apply', or 'post_apply'

**Examples:**

```powershell
Add-TfcWorkspaceRunTask -WorkspaceId "ws-123" -RunTaskId "task-abc" -EnforcementLevel "mandatory" -Stage "pre_plan"
```

---

## Add-TfcWorkspaceTeamAccess

**Synopsis:** Adds team access to a workspace

**Description:** Grants a team access to a workspace with specified permissions

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **TeamId** (string): The team ID to grant access
- **Access** (string): Access level: 'read', 'plan', 'write', 'admin', or 'custom'
- **Runs** (string): Custom permission for runs: 'read', 'plan', or 'apply'
- **Variables** (string): Custom permission for variables: 'none', 'read', or 'write'
- **StateVersions** (string): Custom permission for state: 'none', 'read', 'read-outputs', or 'write'
- **SentinelMocks** (string): Custom permission for sentinel mocks: 'none' or 'read'
- **WorkspaceLocking** (bool): Custom permission for locking: true or false
- **RunTasks** (bool): Custom permission for run tasks: true or false

**Examples:**

```powershell
Add-TfcWorkspaceTeamAccess -WorkspaceId "ws-123" -TeamId "team-abc" -Access "write"
```

```powershell
Add-TfcWorkspaceTeamAccess -WorkspaceId "ws-123" -TeamId "team-abc" -Access "custom" -Runs "plan" -Variables "read" -StateVersions "read"
```

---

## Approve-TfcChangeRequest

**Synopsis:** Approve a change request

**Description:** Approves a change request to allow it to proceed

**Parameters:**

- **ChangeRequestId** (string): The ID of the change request (format: chreq-xxxxx)
- **Comment** (string): Optional comment for the approval

**Examples:**

```powershell
Approve-TfcChangeRequest -ChangeRequestId chreq-abc123 -Comment "Approved by team lead"
```

---

## Confirm-TfcNoCodeWorkspaceUpgrade

**Synopsis:** Confirms a no-code workspace upgrade

**Description:** Confirms and applies an upgrade for a workspace provisioned from a no-code module

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module (format: ncm-xxxxx)
- **WorkspaceId** (string): The workspace ID
- **UpgradeId** (string): The upgrade ID to confirm

**Examples:**

```powershell
Confirm-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId "ncm-abc123" -WorkspaceId "ws-xyz789" -UpgradeId "ncup-def456"
```

---

## Confirm-TfcRun

**Synopsis:** Applies a run

**Description:** Applies a run that is awaiting confirmation

**Parameters:**

- **RunId** (string): The run ID to apply
- **Comment** (string): Optional comment for the apply

**Examples:**

```powershell
Confirm-TfcRun -RunId "run-123" -Comment "Approved by admin"
```

---

## Deny-TfcChangeRequest

**Synopsis:** Reject a change request

**Description:** Rejects a change request to prevent it from proceeding

**Parameters:**

- **ChangeRequestId** (string): The ID of the change request (format: chreq-xxxxx)
- **Comment** (string): Optional comment for the rejection

**Examples:**

```powershell
Deny-TfcChangeRequest -ChangeRequestId chreq-abc123 -Comment "Does not meet security requirements"
```

---

## Deny-TfcRun

**Synopsis:** Discards a run

**Description:** Discards a run that is awaiting confirmation

**Parameters:**

- **RunId** (string): The run ID to discard
- **Comment** (string): Optional comment for the discard action

**Examples:**

```powershell
Deny-TfcRun -RunId "run-123" -Comment "Changes not approved"
```

---

## Disable-TfcDriftDetection

**Synopsis:** Disable drift detection for a workspace

**Description:** Disables automated drift detection for a workspace

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace

**Examples:**

```powershell
Disable-TfcDriftDetection -WorkspaceId "ws-123"
```

---

## Disable-TfcUserTwoFactor

**Synopsis:** Disable two-factor authentication for a user

**Description:** Disables 2FA for a user account (requires admin access, emergency use only)

**Parameters:**

- **UserId** (string): The ID of the user (format: user-xxxxx)

**Examples:**

```powershell
Disable-TfcUserTwoFactor -UserId user-abc123
```

---

## Enable-TfcDriftDetection

**Synopsis:** Enable drift detection for a workspace

**Description:** Enables automated drift detection for a workspace

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace
- **Schedule** (string): Cron schedule for drift detection (e.g., "0 0 * * *" for daily)

**Examples:**

```powershell
Enable-TfcDriftDetection -WorkspaceId "ws-123" -Schedule "0 0 * * *"
```

---

## Find-TfcRegistryModule

**Synopsis:** Search for registry modules

**Description:** Searches the Terraform Registry for modules matching the query

**Parameters:**

- **OrganizationName** (string): The name of the organization (for private registry search)
- **Query** (string): Search query string
- **Provider** (string): Filter by provider (e.g., "aws", "azurerm")
- **Verified** (switch): Filter to verified modules only
- **PageSize** (int): Number of results per page (default: 20)
- **PageNumber** (int): Page number to retrieve (default: 1)

**Examples:**

```powershell
Find-TfcRegistryModule -OrganizationName "my-org" -Query "vpc"
```

```powershell
Find-TfcRegistryModule -Query "vpc" -Provider "aws" -Verified
```

---

## Find-TfcRegistryProvider

**Synopsis:** Search for registry providers

**Description:** Searches the Terraform Registry for providers matching the query

**Parameters:**

- **OrganizationName** (string): The name of the organization (for private registry search)
- **Query** (string): Search query string
- **PageSize** (int): Number of results per page (default: 20)
- **PageNumber** (int): Page number to retrieve (default: 1)

**Examples:**

```powershell
Find-TfcRegistryProvider -OrganizationName "my-org" -Query "aws"
```

```powershell
Find-TfcRegistryProvider -Query "custom-provider"
```

---

## Find-TfcWorkspace

**Synopsis:** Finds a workspace by name across organizations

**Description:** Searches for a workspace by name, optionally within a specific organization

**Parameters:**

- **WorkspaceName** (string): The name of the workspace to find
- **Organization** (string): Optional organization name to limit the search
- **ListOrganizations** (switch): Switch to list all accessible organizations instead of searching for a workspace

**Examples:**

```powershell
Find-TfcWorkspace -WorkspaceName "my-workspace"
```

```powershell
Find-TfcWorkspace -WorkspaceName "my-workspace" -Organization "my-org"
```

```powershell
Find-TfcWorkspace -ListOrganizations
```

---

## Get-TfcAccount

**Synopsis:** Gets the current user account information

**Description:** Retrieves information about the current user account from Terraform Cloud

**Examples:**

```powershell
Get-TfcAccount
```

---

## Get-TfcAdminSettings

**Synopsis:** Get admin organization settings

**Description:** Retrieves administrative settings for Terraform Cloud (requires admin access)

**Examples:**

```powershell
Get-TfcAdminSettings
```

---

## Get-TfcAdminUser

**Synopsis:** List admin users

**Description:** Retrieves all admin users in Terraform Cloud (requires admin access)

**Parameters:**

- **Email** (string)
- **Username** (string)

**Examples:**

```powershell
Get-TfcAdminUser
```

---

## Get-TfcAgent

**Synopsis:** Gets agents in an agent pool

**Description:** Retrieves agents registered to an agent pool

**Parameters:**

- **AgentPoolId** (string): The agent pool ID

**Examples:**

```powershell
Get-TfcAgent -AgentPoolId "apool-abc123"
```

---

## Get-TfcAgentDetails

**Synopsis:** Gets details of an agent

**Description:** Retrieves details of a specific agent by ID

**Parameters:**

- **AgentId** (string): The agent ID

**Examples:**

```powershell
Get-TfcAgentDetails -AgentId "agent-abc123"
```

---

## Get-TfcAgentPool

**Synopsis:** Gets agent pools for an organization

**Description:** Retrieves agent pools used for self-hosted Terraform execution

**Parameters:**

- **Organization** (string): The organization name
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcAgentPool -Organization "my-org"
```

---

## Get-TfcAgentPoolDetails

**Synopsis:** Gets details of an agent pool

**Description:** Retrieves details of a specific agent pool by ID

**Parameters:**

- **AgentPoolId** (string): The agent pool ID

**Examples:**

```powershell
Get-TfcAgentPoolDetails -AgentPoolId "apool-abc123"
```

---

## Get-TfcAgentToken

**Synopsis:** Gets agent tokens for an agent pool

**Description:** Retrieves authentication tokens for agents

**Parameters:**

- **AgentPoolId** (string): The agent pool ID

**Examples:**

```powershell
Get-TfcAgentToken -AgentPoolId "apool-abc123"
```

---

## Get-TfcAgentTokenDetails

**Synopsis:** Gets details of an agent token

**Description:** Retrieves details of a specific authentication token by ID

**Parameters:**

- **TokenId** (string): The authentication token ID

**Examples:**

```powershell
Get-TfcAgentTokenDetails -TokenId "at-abc123"
```

---

## Get-TfcApply

**Synopsis:** Gets applies for a run

**Description:** Retrieves apply information for a specific run

**Parameters:**

- **RunId** (string): The run ID

**Examples:**

```powershell
Get-TfcApply -RunId "run-123"
```

---

## Get-TfcApplyErroredState

**Synopsis:** Gets the errored state of an apply

**Description:** Retrieves the errored state output for a specific apply

**Parameters:**

- **ApplyId** (string): The apply ID

**Examples:**

```powershell
Get-TfcApplyErroredState -ApplyId "apply-abc123"
```

---

## Get-TfcApplyLog

**Synopsis:** Gets apply logs

**Description:** Retrieves the logs from an apply execution

**Parameters:**

- **ApplyId** (string): The apply ID

**Examples:**

```powershell
Get-TfcApplyLog -ApplyId "apply-abc123"
```

---

## Get-TfcAssessmentResult

**Synopsis:** Get assessment results for a workspace

**Description:** Retrieves drift detection and health check assessment results

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace (format: ws-xxxxx)

**Examples:**

```powershell
Get-TfcAssessmentResult -WorkspaceId ws-abc123
```

---

## Get-TfcAssessmentResultDetails

**Synopsis:** Get detailed assessment result information

**Description:** Retrieves detailed information about a specific assessment result

**Parameters:**

- **AssessmentResultId** (string): The ID of the assessment result (format: asmtrs-xxxxx)

**Examples:**

```powershell
Get-TfcAssessmentResultDetails -AssessmentResultId asmtrs-abc123
```

---

## Get-TfcAssessmentResultJsonOutput

**Synopsis:** Gets JSON output of an assessment result

**Description:** Retrieves the JSON output for a specific assessment result

**Parameters:**

- **AssessmentResultId** (string): The assessment result ID

**Examples:**

```powershell
Get-TfcAssessmentResultJsonOutput -AssessmentResultId "asmtresult-abc123"
```

---

## Get-TfcAssessmentResultJsonSchema

**Synopsis:** Gets JSON schema of an assessment result

**Description:** Retrieves the JSON schema for a specific assessment result

**Parameters:**

- **AssessmentResultId** (string): The assessment result ID

**Examples:**

```powershell
Get-TfcAssessmentResultJsonSchema -AssessmentResultId "asmtresult-abc123"
```

---

## Get-TfcAssessmentResultLog

**Synopsis:** Gets log output of an assessment result

**Description:** Retrieves the log output for a specific assessment result

**Parameters:**

- **AssessmentResultId** (string): The assessment result ID

**Examples:**

```powershell
Get-TfcAssessmentResultLog -AssessmentResultId "asmtresult-abc123"
```

---

## Get-TfcAuditTrail

**Synopsis:** Gets audit trail events

**Description:** Retrieves audit trail events for compliance logging

**Parameters:**

- **OrganizationName** (string): Optional organization name to filter events
- **Since** (datetime): Optional start date for filtering
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcAuditTrail -OrganizationName "my-org"
```

---

## Get-TfcAuditTrailToken

**Synopsis:** Gets audit trail tokens

**Description:** Retrieves all audit trail tokens for an organization (admin only)

**Parameters:**

- **Organization** (string): The name of the organization

**Examples:**

```powershell
Get-TfcAuditTrailToken -Organization "my-org"
```

---

## Get-TfcChangeRequest

**Synopsis:** List change requests for a workspace

**Description:** Retrieves all change requests for a workspace

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace (format: ws-xxxxx)

**Examples:**

```powershell
Get-TfcChangeRequest -WorkspaceId ws-abc123
```

---

## Get-TfcChangeRequestComment

**Synopsis:** Lists comments on a change request

**Description:** Retrieves comments for a specific change request

**Parameters:**

- **ChangeRequestId** (string): The change request ID

**Examples:**

```powershell
Get-TfcChangeRequestComment -ChangeRequestId "cr-abc123"
```

---

## Get-TfcChangeRequestDetails

**Synopsis:** Get detailed change request information

**Description:** Retrieves detailed information about a specific change request

**Parameters:**

- **ChangeRequestId** (string): The ID of the change request (format: chreq-xxxxx)

**Examples:**

```powershell
Get-TfcChangeRequestDetails -ChangeRequestId chreq-abc123
```

---

## Get-TfcComment

**Synopsis:** Gets comments on a run

**Description:** Retrieves comments added to a Terraform run for collaboration

**Parameters:**

- **RunId** (string): The run ID
- **CommentId** (string): Optional specific comment ID

**Examples:**

```powershell
Get-TfcComment -RunId "run-123"
```

---

## Get-TfcConfigurationVersion

**Synopsis:** Gets a specific configuration version

**Description:** Retrieves details of a specific configuration version by ID

**Parameters:**

- **ConfigurationVersionId** (string): The configuration version ID

**Examples:**

```powershell
Get-TfcConfigurationVersion -ConfigurationVersionId "cv-abc123"
```

---

## Get-TfcConfigurationVersionIngressAttributes

**Synopsis:** Gets ingress attributes for a configuration version

**Description:** Retrieves the ingress attributes (VCS metadata) associated with a configuration version

**Parameters:**

- **ConfigurationVersionId** (string): The configuration version ID

**Examples:**

```powershell
Get-TfcConfigurationVersionIngressAttributes -ConfigurationVersionId "cv-abc123"
```

---

## Get-TfcConfigurationVersionList

**Synopsis:** Lists configuration versions for a workspace

**Description:** Retrieves all configuration versions for a specific workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcConfigurationVersionList -WorkspaceId "ws-abc123"
```

---

## Get-TfcCostEstimate

**Synopsis:** Gets cost estimate for a run

**Description:** Retrieves cost estimate information for a Terraform run

**Parameters:**

- **RunId** (string): The run ID

**Examples:**

```powershell
Get-TfcCostEstimate -RunId "run-abc123"
```

---

## Get-TfcCostEstimateLog

**Synopsis:** Download cost estimate logs

**Description:** Downloads the logs for a cost estimate

**Parameters:**

- **CostEstimateId** (string): The ID of the cost estimate (format: ce-xxxxx)

**Examples:**

```powershell
Get-TfcCostEstimateLog -CostEstimateId ce-abc123
```

---

## Get-TfcCurrentStateVersion

**Synopsis:** Gets the current state version for a workspace

**Description:** Retrieves the current state version from a Terraform Cloud workspace and optionally downloads the state file

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **OutputPath** (string): Optional path to save the state file

**Examples:**

```powershell
Get-TfcCurrentStateVersion -WorkspaceId "ws-123"
```

```powershell
Get-TfcCurrentStateVersion -WorkspaceId "ws-123" -OutputPath "./terraform.tfstate"
```

---

## Get-TfcCurrentUser

**Synopsis:** Gets user information from a token

**Description:** Retrieves user information for the specified user token

**Parameters:**

- **UserToken** (string): The user token to get information for (if not provided, uses current token)

**Examples:**

```powershell
Get-TfcCurrentUser
```

```powershell
Get-TfcCurrentUser -UserToken "user-token-here"
```

---

## Get-TfcDriftDetection

**Synopsis:** Get drift detection runs

**Description:** Retrieves drift detection runs for a workspace

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace
- **PageSize** (int): Number of results per page (default: 20)
- **PageNumber** (int): Page number to retrieve (default: 1)
- **AllPages** (switch): Retrieve all pages of results

**Examples:**

```powershell
Get-TfcDriftDetection -WorkspaceId "ws-123"
```

---

## Get-TfcDriftStatus

**Synopsis:** Get drift detection status

**Description:** Retrieves the current drift detection status and configuration for a workspace

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace

**Examples:**

```powershell
Get-TfcDriftStatus -WorkspaceId "ws-123"
```

---

## Get-TfcFeatureSet

**Synopsis:** List feature sets

**Description:** Retrieves available feature sets for Terraform Cloud

**Examples:**

```powershell
Get-TfcFeatureSet
```

---

## Get-TfcFeatureSetDetails

**Synopsis:** Get detailed feature set information

**Description:** Retrieves detailed information about a specific feature set

**Parameters:**

- **FeatureSetId** (string): The ID of the feature set (format: fs-xxxxx)

**Examples:**

```powershell
Get-TfcFeatureSetDetails -FeatureSetId fs-abc123
```

---

## Get-TfcGitHubAppInstallation

**Synopsis:** List GitHub App installations

**Description:** Retrieves all GitHub App installations for an organization

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Get-TfcGitHubAppInstallation -OrganizationName my-org
```

---

## Get-TfcGitHubAppInstallationDetails

**Synopsis:** Get detailed GitHub App installation information

**Description:** Retrieves detailed information about a specific GitHub App installation

**Parameters:**

- **InstallationId** (string): The ID of the GitHub App installation (format: ghain-xxxxx)

**Examples:**

```powershell
Get-TfcGitHubAppInstallationDetails -InstallationId ghain-abc123
```

---

## Get-TfcGPGKey

**Synopsis:** Lists GPG keys for a registry

**Description:** Retrieves GPG keys for a given registry namespace

**Parameters:**

- **RegistryName** (string): The registry name (e.g., "private")
- **Namespace** (string): The namespace (organization name)

**Examples:**

```powershell
Get-TfcGPGKey -RegistryName "private" -Namespace "my-org"
```

---

## Get-TfcGPGKeyDetails

**Synopsis:** Gets details of a GPG key

**Description:** Retrieves details of a specific GPG key by namespace and key ID

**Parameters:**

- **RegistryName** (string): The registry name (e.g., "private")
- **Namespace** (string): The namespace (organization name)
- **KeyId** (string): The GPG key ID

**Examples:**

```powershell
Get-TfcGPGKeyDetails -RegistryName "private" -Namespace "my-org" -KeyId "12345"
```

---

## Get-TfcGroupMemberRole

**Synopsis:** Lists group member roles for a resource

**Description:** Retrieves group member roles for a specific resource type and ID

**Parameters:**

- **ResourceType** (string): The resource type (e.g., "organizations", "projects", "workspaces")
- **ResourceId** (string): The resource ID

**Examples:**

```powershell
Get-TfcGroupMemberRole -ResourceType "organizations" -ResourceId "org-abc123"
```

---

## Get-TfcGroupMemberRoleDetails

**Synopsis:** Gets group member role details with group filter

**Description:** Retrieves group member roles for a specific resource, filtered by group

**Parameters:**

- **ResourceType** (string): The resource type (e.g., "organizations", "projects", "workspaces")
- **ResourceId** (string): The resource ID
- **GroupId** (string): The group ID to filter by

**Examples:**

```powershell
Get-TfcGroupMemberRoleDetails -ResourceType "organizations" -ResourceId "org-abc123" -GroupId "group-abc123"
```

---

## Get-TfcHYOKConfiguration

**Synopsis:** Lists HYOK configurations for an organization

**Description:** Retrieves Hold Your Own Key (HYOK) configurations for the specified organization. Supports pagination and retrieving all pages of results.

**Parameters:**

- **Organization** (string): The name of the organization
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of results per page (default: 20, max: 100)
- **PageNumber** (int): Page number to retrieve (default: 1)

**Examples:**

```powershell
Get-TfcHYOKConfiguration -Organization "my-org"
```

```powershell
Get-TfcHYOKConfiguration -Organization "my-org" -AllPages
```

```powershell
Get-TfcHYOKConfiguration -Organization "my-org" -PageSize 50 -PageNumber 2
```

---

## Get-TfcHYOKConfigurationDetails

**Synopsis:** Gets details of a specific HYOK configuration

**Description:** Retrieves detailed information about a specific Hold Your Own Key (HYOK) configuration

**Parameters:**

- **ConfigurationId** (string): The ID of the HYOK configuration

**Examples:**

```powershell
Get-TfcHYOKConfigurationDetails -ConfigurationId "hyokc-abc123"
```

---

## Get-TfcHYOKEncryptedDataKey

**Synopsis:** Gets a HYOK encrypted data key

**Description:** Retrieves a specific HYOK encrypted data key by ID

**Parameters:**

- **EncryptedDataKeyId** (string): The HYOK encrypted data key ID

**Examples:**

```powershell
Get-TfcHYOKEncryptedDataKey -EncryptedDataKeyId "hyokdek-abc123"
```

---

## Get-TfcHYOKKeyVersion

**Synopsis:** Gets HYOK key versions for a configuration

**Description:** Retrieves key versions associated with a HYOK configuration

**Parameters:**

- **ConfigurationId** (string): The HYOK configuration ID
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcHYOKKeyVersion -ConfigurationId "hyok-abc123"
```

---

## Get-TfcHYOKKeyVersionDetails

**Synopsis:** Gets details of a HYOK key version

**Description:** Retrieves details of a specific HYOK customer key version

**Parameters:**

- **KeyVersionId** (string): The HYOK customer key version ID

**Examples:**

```powershell
Get-TfcHYOKKeyVersionDetails -KeyVersionId "hyokkv-abc123"
```

---

## Get-TfcHYOKKeyVersionRefresh

**Synopsis:** Refreshes HYOK key versions

**Description:** Queries for newly available key versions for a HYOK configuration

**Parameters:**

- **ConfigurationId** (string): The HYOK configuration ID

**Examples:**

```powershell
Get-TfcHYOKKeyVersionRefresh -ConfigurationId "hyok-abc123"
```

---

## Get-TfcInvoice

**Synopsis:** List invoices

**Description:** Retrieves billing invoices for an organization (requires admin access)

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Get-TfcInvoice -OrganizationName my-org
```

---

## Get-TfcInvoiceDetails

**Synopsis:** Gets invoice details

**Description:** Retrieves invoice details for an organization (admin only)

**Parameters:**

- **Organization** (string): The name of the organization
- **InvoiceId** (string): Optional specific invoice ID to retrieve

**Examples:**

```powershell
Get-TfcInvoiceDetails -Organization "my-org"
```

```powershell
Get-TfcInvoiceDetails -Organization "my-org" -InvoiceId "inv-123"
```

---

## Get-TfcIPRange

**Synopsis:** Get Terraform Cloud IP ranges

**Description:** Retrieves the IP ranges used by Terraform Cloud for network configuration

**Examples:**

```powershell
Get-TfcIPRange
```

---

## Get-TfcNextInvoice

**Synopsis:** Gets the next invoice for an organization

**Description:** Retrieves the upcoming invoice for a specified organization

**Parameters:**

- **Organization** (string): The organization name

**Examples:**

```powershell
Get-TfcNextInvoice -Organization "my-org"
```

---

## Get-TfcNoCodeModule

**Synopsis:** Get no-code module information

**Description:** Retrieves information about a no-code module

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module (format: ncm-xxxxx)

**Examples:**

```powershell
Get-TfcNoCodeModule -NoCodeModuleId ncm-abc123
```

---

## Get-TfcNoCodeWorkspaceUpgrade

**Synopsis:** Gets the status of a no-code workspace upgrade

**Description:** Retrieves information about a specific no-code workspace upgrade

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module (format: ncm-xxxxx)
- **WorkspaceId** (string): The workspace ID
- **UpgradeId** (string): The upgrade ID

**Examples:**

```powershell
Get-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId "ncm-abc123" -WorkspaceId "ws-xyz789" -UpgradeId "ncup-def456"
```

---

## Get-TfcNotificationConfiguration

**Synopsis:** Gets notification configurations for a workspace

**Description:** Retrieves notification configurations (webhooks, Slack, etc.) for a workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID

**Examples:**

```powershell
Get-TfcNotificationConfiguration -WorkspaceId "ws-123"
```

---

## Get-TfcOAuthClient

**Synopsis:** Gets OAuth clients for an organization

**Description:** Retrieves VCS providers (OAuth clients) for a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name

**Examples:**

```powershell
Get-TfcOAuthClient -Organization "my-org"
```

---

## Get-TfcOAuthClientDetails

**Synopsis:** Gets detailed OAuth client information

**Description:** Retrieves detailed OAuth client information with relationships

**Parameters:**

- **OAuthClientId** (string): The ID of the OAuth client to retrieve
- **Include** (string): Optional comma-separated list of relationships to include (e.g., "organization,oauth-tokens")

**Examples:**

```powershell
Get-TfcOAuthClientDetails -OAuthClientId "oc-123"
```

```powershell
Get-TfcOAuthClientDetails -OAuthClientId "oc-123" -Include "organization,oauth-tokens"
```

---

## Get-TfcOAuthClientOrganization

**Synopsis:** Gets OAuth client organizations

**Description:** Retrieves the organization associated with an OAuth client

**Parameters:**

- **OAuthClientId** (string): The ID of the OAuth client to get organization for

**Examples:**

```powershell
Get-TfcOAuthClientOrganization -OAuthClientId "oc-123"
```

---

## Get-TfcOAuthToken

**Synopsis:** List OAuth tokens for an OAuth client

**Description:** Retrieves all OAuth tokens associated with an OAuth client

**Parameters:**

- **OAuthClientId** (string): The ID of the OAuth client (format: oc-xxxxx)

**Examples:**

```powershell
Get-TfcOAuthToken -OAuthClientId oc-abc123
```

---

## Get-TfcOAuthTokenDetails

**Synopsis:** Get detailed OAuth token information

**Description:** Retrieves detailed information about a specific OAuth token

**Parameters:**

- **OAuthTokenId** (string): The ID of the OAuth token (format: ot-xxxxx)

**Examples:**

```powershell
Get-TfcOAuthTokenDetails -OAuthTokenId ot-abc123
```

---

## Get-TfcOrganization

**Synopsis:** Gets organizations accessible to the current user

**Description:** Retrieves a list of organizations that the current user has access to

**Parameters:**

- **Name** (string): Optional organization name to filter results
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcOrganization
```

```powershell
Get-TfcOrganization -Name "my-org"
```

---

## Get-TfcOrganizationEntitlements

**Synopsis:** Gets the entitlement set for an organization

**Description:** Retrieves the feature entitlements for a specific organization

**Parameters:**

- **Organization** (string): The organization name

**Examples:**

```powershell
Get-TfcOrganizationEntitlements -Organization "my-org"
```

---

## Get-TfcOrganizationMembership

**Synopsis:** Gets organization memberships

**Description:** Retrieves organization memberships. Can list all memberships for an organization or get a specific membership by ID.

**Parameters:**

- **OrganizationName** (string): The organization name
- **MembershipId** (string): Optional membership ID to get a specific membership

**Examples:**

```powershell
Get-TfcOrganizationMembership -OrganizationName "my-org"
```

```powershell
Get-TfcOrganizationMembership -OrganizationName "my-org" -MembershipId "ou-abc123"
```

---

## Get-TfcOrganizationMembershipDetails

**Synopsis:** Gets organization membership details

**Description:** Retrieves detailed information about an organization membership including relationships

**Parameters:**

- **MembershipId** (string): The ID of the organization membership
- **Include** (string[]): Optional array of relationships to include (user, teams, organization)

**Examples:**

```powershell
Get-TfcOrganizationMembershipDetails -MembershipId "om-123"
```

```powershell
Get-TfcOrganizationMembershipDetails -MembershipId "om-123" -Include @('user', 'teams')
```

---

## Get-TfcOrganizationModuleProducer

**Synopsis:** Gets organization module producers

**Description:** Lists all registry module producers configured for an organization

**Parameters:**

- **Organization** (string): The name of the organization

**Examples:**

```powershell
Get-TfcOrganizationModuleProducer -Organization "my-org"
```

---

## Get-TfcOrganizationRun

**Synopsis:** Lists runs for an organization

**Description:** Retrieves runs across all workspaces in an organization

**Parameters:**

- **Organization** (string): The organization name
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcOrganizationRun -Organization "my-org"
```

---

## Get-TfcOrganizationSubscription

**Synopsis:** Gets the subscription for an organization

**Description:** Retrieves the subscription details for a specified organization

**Parameters:**

- **Organization** (string): The organization name

**Examples:**

```powershell
Get-TfcOrganizationSubscription -Organization "my-org"
```

---

## Get-TfcOrganizationTag

**Synopsis:** Gets organization tags

**Description:** Retrieves tags for an organization. Can list all tags or get a specific tag by ID.

**Parameters:**

- **OrganizationName** (string): The organization name
- **TagId** (string): Optional tag ID to get a specific tag

**Examples:**

```powershell
Get-TfcOrganizationTag -OrganizationName "my-org"
```

```powershell
Get-TfcOrganizationTag -OrganizationName "my-org" -TagId "tag-abc123"
```

---

## Get-TfcOrganizationTeamToken

**Synopsis:** Lists team tokens for an organization

**Description:** Retrieves team tokens for a specified organization

**Parameters:**

- **Organization** (string): The organization name

**Examples:**

```powershell
Get-TfcOrganizationTeamToken -Organization "my-org"
```

---

## Get-TfcPlan

**Synopsis:** Gets plans for a run

**Description:** Retrieves plan information for a specific run

**Parameters:**

- **RunId** (string): The run ID

**Examples:**

```powershell
Get-TfcPlan -RunId "run-123"
```

---

## Get-TfcPlanExport

**Synopsis:** Gets a plan export

**Description:** Retrieves details of a plan export and optionally downloads it

**Parameters:**

- **PlanExportId** (string): The plan export ID
- **OutputPath** (string): Optional path to save the export file

**Examples:**

```powershell
Get-TfcPlanExport -PlanExportId "pe-abc123" -OutputPath "./plan-export.tar.gz"
```

---

## Get-TfcPlanJson

**Synopsis:** Gets plan JSON output

**Description:** Retrieves the JSON representation of a plan for programmatic analysis

**Parameters:**

- **PlanId** (string): The plan ID

**Examples:**

```powershell
Get-TfcPlanJson -PlanId "plan-abc123"
```

---

## Get-TfcPlanLog

**Synopsis:** Gets plan logs

**Description:** Retrieves the logs from a plan execution

**Parameters:**

- **PlanId** (string): The plan ID

**Examples:**

```powershell
Get-TfcPlanLog -PlanId "plan-abc123"
```

---

## Get-TfcPolicy

**Synopsis:** Gets policies in an organization

**Description:** Retrieves Sentinel or OPA policies for policy-as-code enforcement

**Parameters:**

- **OrganizationName** (string): The organization name
- **PolicyId** (string): Optional specific policy ID to retrieve
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcPolicy -OrganizationName "my-org"
```

```powershell
Get-TfcPolicy -OrganizationName "my-org" -PolicyId "pol-123"
```

---

## Get-TfcPolicyCheck

**Synopsis:** Gets policy checks for a run

**Description:** Retrieves policy check results for a Terraform run

**Parameters:**

- **RunId** (string): The run ID
- **PolicyCheckId** (string): Optional specific policy check ID

**Examples:**

```powershell
Get-TfcPolicyCheck -RunId "run-123"
```

---

## Get-TfcPolicyContent

**Synopsis:** Gets policy content (code)

**Description:** Downloads the policy code/content for a specific policy

**Parameters:**

- **PolicyId** (string): The ID of the policy to download content for
- **OutputPath** (string): Optional file path to save the downloaded policy content

**Examples:**

```powershell
Get-TfcPolicyContent -PolicyId "pol-123"
```

```powershell
Get-TfcPolicyContent -PolicyId "pol-123" -OutputPath "./policy.sentinel"
```

---

## Get-TfcPolicyEvaluation

**Synopsis:** Gets policy evaluation information

**Description:** Retrieves policy evaluation details for a run in Terraform Cloud

**Parameters:**

- **RunId** (string): The ID of the run to get policy evaluations for
- **PolicyEvaluationId** (string): Optional specific policy evaluation ID to retrieve

**Examples:**

```powershell
Get-TfcPolicyEvaluation -RunId "run-123"
```

```powershell
Get-TfcPolicyEvaluation -RunId "run-123" -PolicyEvaluationId "poleval-456"
```

---

## Get-TfcPolicyEvaluationDetails

**Synopsis:** Gets detailed policy evaluation information

**Description:** Retrieves detailed policy evaluation with relationships for a specific policy evaluation

**Parameters:**

- **PolicyEvaluationId** (string): The ID of the policy evaluation to retrieve
- **Include** (string): Optional comma-separated list of relationships to include (e.g., "policy-set,policy-set-outcomes")

**Examples:**

```powershell
Get-TfcPolicyEvaluationDetails -PolicyEvaluationId "poleval-123"
```

```powershell
Get-TfcPolicyEvaluationDetails -PolicyEvaluationId "poleval-123" -Include "policy-set,policy-set-outcomes"
```

---

## Get-TfcPolicyEvaluationTask

**Synopsis:** Gets policy evaluation tasks

**Description:** Retrieves policy evaluation tasks (OPA/Sentinel) for a task stage

**Parameters:**

- **TaskStageId** (string): The ID of the task stage to get policy tasks for

**Examples:**

```powershell
Get-TfcPolicyEvaluationTask -TaskStageId "ts-123"
```

---

## Get-TfcPolicyEvaluationTaskDetails

**Synopsis:** Gets detailed policy evaluation task information

**Description:** Retrieves detailed information for a specific policy evaluation task

**Parameters:**

- **PolicyEvaluationId** (string): The ID of the policy evaluation task to retrieve details for
- **Include** (string): Optional comma-separated list of relationships to include

**Examples:**

```powershell
Get-TfcPolicyEvaluationTaskDetails -PolicyEvaluationId "poleval-123"
```

---

## Get-TfcPolicySet

**Synopsis:** Gets policy sets in an organization

**Description:** Retrieves policy sets that group policies together for workspace targeting

**Parameters:**

- **OrganizationName** (string): The organization name
- **PolicySetId** (string): Optional specific policy set ID to retrieve
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcPolicySet -OrganizationName "my-org"
```

```powershell
Get-TfcPolicySet -OrganizationName "my-org" -PolicySetId "polset-123"
```

---

## Get-TfcPolicySetOutcome

**Synopsis:** Lists policy set outcomes for a policy evaluation

**Description:** Retrieves policy set outcomes for a specific policy evaluation

**Parameters:**

- **PolicyEvaluationId** (string): The policy evaluation ID
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcPolicySetOutcome -PolicyEvaluationId "poleval-abc123"
```

---

## Get-TfcPolicySetOutcomeDetails

**Synopsis:** Gets details of a policy set outcome

**Description:** Retrieves details of a specific policy set outcome

**Parameters:**

- **PolicySetOutcomeId** (string): The policy set outcome ID

**Examples:**

```powershell
Get-TfcPolicySetOutcomeDetails -PolicySetOutcomeId "psout-abc123"
```

---

## Get-TfcPolicySetParameter

**Synopsis:** Gets policy set parameters

**Description:** Retrieves parameters for a policy set in Terraform Cloud

**Parameters:**

- **PolicySetId** (string): The ID of the policy set to get parameters for
- **ParameterId** (string): Optional specific parameter ID to retrieve

**Examples:**

```powershell
Get-TfcPolicySetParameter -PolicySetId "polset-123"
```

```powershell
Get-TfcPolicySetParameter -PolicySetId "polset-123" -ParameterId "param-456"
```

---

## Get-TfcProject

**Synopsis:** Gets projects for an organization

**Description:** Retrieves projects from a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): Optional project name to get a specific project
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcProject -Organization "my-org"
```

```powershell
Get-TfcProject -Organization "my-org" -Name "production"
```

---

## Get-TfcProjectEffectiveTagBinding

**Synopsis:** Gets effective tag bindings for a project

**Description:** Retrieves the effective tag bindings for a project, including inherited tag bindings

**Parameters:**

- **ProjectId** (string): The project ID

**Examples:**

```powershell
Get-TfcProjectEffectiveTagBinding -ProjectId "prj-abc123"
```

---

## Get-TfcProjectTagBinding

**Synopsis:** Gets tag bindings for a project

**Description:** Retrieves the tag bindings associated with a specific project

**Parameters:**

- **ProjectId** (string): The project ID

**Examples:**

```powershell
Get-TfcProjectTagBinding -ProjectId "prj-abc123"
```

---

## Get-TfcProjectTeamAccess

**Synopsis:** Lists team access for a project

**Description:** Retrieves all team access configurations for a specific project

**Parameters:**

- **ProjectId** (string): The project ID

**Examples:**

```powershell
Get-TfcProjectTeamAccess -ProjectId "prj-abc123"
```

---

## Get-TfcProjectTeamAccessDetails

**Synopsis:** Gets team project access details

**Description:** Retrieves details of a specific team-project access relationship by its ID

**Parameters:**

- **TeamProjectId** (string): The team project relationship ID

**Examples:**

```powershell
Get-TfcProjectTeamAccessDetails -TeamProjectId "tprj-abc123"
```

---

## Get-TfcProjectVariableSet

**Synopsis:** Gets variable sets for a project

**Description:** Retrieves variable sets assigned to a specific project

**Parameters:**

- **ProjectId** (string): The project ID
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcProjectVariableSet -ProjectId "prj-abc123"
```

```powershell
Get-TfcProjectVariableSet -ProjectId "prj-abc123" -AllPages
```

---

## Get-TfcRegistryModule

**Synopsis:** Gets registry modules

**Description:** Retrieves registry modules from a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): Optional module name to get a specific module
- **Provider** (string): Optional provider name (required with Name)
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcRegistryModule -Organization "my-org"
```

```powershell
Get-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
```

---

## Get-TfcRegistryModuleDependencies

**Synopsis:** Get registry module dependencies

**Description:** Retrieves dependencies for a module version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name
- **Version** (string): The version string

**Examples:**

```powershell
Get-TfcRegistryModuleDependencies -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
```

---

## Get-TfcRegistryModuleDownloadUrl

**Synopsis:** Get registry module download URL

**Description:** Retrieves the download URL for a module version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name
- **Version** (string): The version string

**Examples:**

```powershell
Get-TfcRegistryModuleDownloadUrl -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
```

---

## Get-TfcRegistryModuleStats

**Synopsis:** Get registry module statistics

**Description:** Retrieves download statistics for a module

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name

**Examples:**

```powershell
Get-TfcRegistryModuleStats -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws"
```

---

## Get-TfcRegistryModuleTestRun

**Synopsis:** Lists test runs for a registry module

**Description:** Retrieves test runs for a specified private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name

**Examples:**

```powershell
Get-TfcRegistryModuleTestRun -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
```

---

## Get-TfcRegistryModuleTestRunDetails

**Synopsis:** Gets details of a registry module test run

**Description:** Retrieves details of a specific test run for a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name
- **TestRunId** (string): The test run ID

**Examples:**

```powershell
Get-TfcRegistryModuleTestRunDetails -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -TestRunId "modtestrun-abc123"
```

---

## Get-TfcRegistryModuleTestVariable

**Synopsis:** Lists test variables for a registry module

**Description:** Retrieves variables configured for testing a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name

**Examples:**

```powershell
Get-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
```

---

## Get-TfcRegistryModuleVersion

**Synopsis:** List registry module versions

**Description:** Lists all versions of a registry module

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name (e.g., "private")
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name

**Examples:**

```powershell
Get-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws"
```

---

## Get-TfcRegistryModuleVersionDetails

**Synopsis:** Get registry module version details

**Description:** Retrieves detailed information about a specific module version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name
- **Version** (string): The version string (e.g., "1.0.0")

**Examples:**

```powershell
Get-TfcRegistryModuleVersionDetails -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
```

---

## Get-TfcRegistryProvider

**Synopsis:** Gets registry providers

**Description:** Retrieves registry providers from a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): Optional provider name to get a specific provider
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcRegistryProvider -Organization "my-org"
```

```powershell
Get-TfcRegistryProvider -Organization "my-org" -Name "aws"
```

---

## Get-TfcRegistryProviderPlatform

**Synopsis:** Get registry provider platforms

**Description:** Lists all platforms for a specific provider version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider
- **Version** (string): The version string

**Examples:**

```powershell
Get-TfcRegistryProviderPlatform -OrganizationName "my-org" -RegistryName "private" -Namespace "hashicorp" -Name "aws" -Version "5.0.0"
```

---

## Get-TfcRegistryProviderVersion

**Synopsis:** List registry provider versions

**Description:** Lists all versions of a registry provider

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider

**Examples:**

```powershell
Get-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "hashicorp" -Name "aws"
```

---

## Get-TfcRegistryProviderVersionDetails

**Synopsis:** Get registry provider version details

**Description:** Retrieves detailed information about a specific provider version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider
- **Version** (string): The version string

**Examples:**

```powershell
Get-TfcRegistryProviderVersionDetails -OrganizationName "my-org" -RegistryName "private" -Namespace "hashicorp" -Name "aws" -Version "5.0.0"
```

---

## Get-TfcRegistrySettings

**Synopsis:** Get registry settings for an organization

**Description:** Retrieves private registry settings for an organization

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Get-TfcRegistrySettings -OrganizationName my-org
```

---

## Get-TfcRegistryWebhook

**Synopsis:** List registry webhooks

**Description:** Retrieves registry webhooks for an organization

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Get-TfcRegistryWebhook -OrganizationName "my-org"
```

---

## Get-TfcReservedTagKey

**Synopsis:** Gets reserved tag keys

**Description:** Lists all reserved tag keys in an organization that cannot be used for workspace tagging

**Parameters:**

- **Organization** (string): The name of the organization

**Examples:**

```powershell
Get-TfcReservedTagKey -Organization "my-org"
```

---

## Get-TfcRun

**Synopsis:** Gets runs for a workspace

**Description:** Retrieves runs from a Terraform Cloud workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcRun -WorkspaceId "ws-123"
```

---

## Get-TfcRunDetails

**Synopsis:** Get detailed run information

**Description:** Retrieves detailed information about a specific run including relationships and additional data

**Parameters:**

- **RunId** (string): The ID of the run (format: run-xxxxx)

**Examples:**

```powershell
Get-TfcRunDetails -RunId run-abc123
```

---

## Get-TfcRunEvent

**Synopsis:** Gets run events

**Description:** Retrieves timeline events for a run (creation, status changes, etc.)

**Parameters:**

- **RunId** (string): The ID of the run

**Examples:**

```powershell
Get-TfcRunEvent -RunId "run-123"
```

---

## Get-TfcRunPermission

**Synopsis:** Gets run permissions for the current user

**Description:** Retrieves the permissions the current user has on a specific run

**Parameters:**

- **RunId** (string): The ID of the run

**Examples:**

```powershell
Get-TfcRunPermission -RunId "run-123"
```

---

## Get-TfcRunTask

**Synopsis:** Gets run tasks for an organization

**Description:** Retrieves run tasks configured in an organization

**Parameters:**

- **Organization** (string): The organization name
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcRunTask -Organization "my-org"
```

---

## Get-TfcRunTaskDetails

**Synopsis:** Gets details of a run task

**Description:** Retrieves details of a specific run task by ID

**Parameters:**

- **TaskId** (string): The run task ID

**Examples:**

```powershell
Get-TfcRunTaskDetails -TaskId "task-abc123"
```

---

## Get-TfcRunTaskResult

**Synopsis:** Get run task results for a run

**Description:** Retrieves the results of run tasks that were executed for a specific run

**Parameters:**

- **RunId** (string): The ID of the run (format: run-xxxxx)

**Examples:**

```powershell
Get-TfcRunTaskResult -RunId run-abc123
```

---

## Get-TfcRunTaskResultDetails

**Synopsis:** Get detailed run task result information

**Description:** Retrieves detailed information about a specific run task result

**Parameters:**

- **TaskResultId** (string): The ID of the task result (format: taskrs-xxxxx)

**Examples:**

```powershell
Get-TfcRunTaskResultDetails -TaskResultId taskrs-abc123
```

---

## Get-TfcRunTaskStage

**Synopsis:** Gets run task stages

**Description:** Retrieves the run task stages for a run (pre-plan, post-plan, pre-apply)

**Parameters:**

- **RunId** (string): The ID of the run

**Examples:**

```powershell
Get-TfcRunTaskStage -RunId "run-123"
```

---

## Get-TfcRunTrigger

**Synopsis:** Gets run triggers for a workspace

**Description:** Retrieves run triggers that link workspaces together for orchestration

**Parameters:**

- **WorkspaceId** (string): The workspace ID to get triggers for
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcRunTrigger -WorkspaceId "ws-123"
```

---

## Get-TfcSAMLSettings

**Synopsis:** List SAML settings for an organization

**Description:** Retrieves SAML SSO configuration for an organization (requires admin access)

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Get-TfcSAMLSettings -OrganizationName my-org
```

---

## Get-TfcSSHKey

**Synopsis:** Gets SSH keys for an organization

**Description:** Retrieves SSH keys used for accessing private Git repositories

**Parameters:**

- **Organization** (string): The organization name

**Examples:**

```powershell
Get-TfcSSHKey -Organization "my-org"
```

---

## Get-TfcStack

**Synopsis:** List stacks in an organization

**Description:** Retrieves a list of stacks for the specified organization

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **PageSize** (int): Number of results per page (default: 20, max: 100)
- **PageNumber** (int): Page number to retrieve (default: 1)
- **AllPages** (switch): Retrieve all pages of results

**Examples:**

```powershell
Get-TfcStack -OrganizationName "my-org"
```

```powershell
Get-TfcStack -OrganizationName "my-org" -AllPages
```

---

## Get-TfcStackConfiguration

**Synopsis:** Get stack configuration

**Description:** Retrieves the configuration for a stack

**Parameters:**

- **StackId** (string): The ID of the stack

**Examples:**

```powershell
Get-TfcStackConfiguration -StackId "stack-123"
```

---

## Get-TfcStackDeployment

**Synopsis:** List stack deployments

**Description:** Retrieves deployments for a specific stack

**Parameters:**

- **StackId** (string): The ID of the stack
- **PageSize** (int): Number of results per page (default: 20)
- **PageNumber** (int): Page number to retrieve (default: 1)
- **AllPages** (switch): Retrieve all pages of results

**Examples:**

```powershell
Get-TfcStackDeployment -StackId "stack-123"
```

---

## Get-TfcStackDeploymentDetails

**Synopsis:** Get stack deployment details

**Description:** Retrieves detailed information about a specific stack deployment

**Parameters:**

- **DeploymentId** (string): The ID of the deployment

**Examples:**

```powershell
Get-TfcStackDeploymentDetails -DeploymentId "sd-123"
```

---

## Get-TfcStackDeploymentLog

**Synopsis:** Get stack deployment logs

**Description:** Retrieves logs for a stack deployment

**Parameters:**

- **DeploymentId** (string): The ID of the deployment
- **OutputPath** (string): Optional file path to save logs

**Examples:**

```powershell
Get-TfcStackDeploymentLog -DeploymentId "sd-123"
```

```powershell
Get-TfcStackDeploymentLog -DeploymentId "sd-123" -OutputPath "./deployment.log"
```

---

## Get-TfcStackDetails

**Synopsis:** Get details of a specific stack

**Description:** Retrieves detailed information about a stack including its configuration and relationships

**Parameters:**

- **StackId** (string): The ID of the stack

**Examples:**

```powershell
Get-TfcStackDetails -StackId "stack-123"
```

---

## Get-TfcStackOutput

**Synopsis:** Get stack outputs

**Description:** Retrieves the outputs from a stack

**Parameters:**

- **StackId** (string): The ID of the stack

**Examples:**

```powershell
Get-TfcStackOutput -StackId "stack-123"
```

---

## Get-TfcStackResource

**Synopsis:** Get stack resources

**Description:** Retrieves resources managed by a stack

**Parameters:**

- **StackId** (string): The ID of the stack

**Examples:**

```powershell
Get-TfcStackResource -StackId "stack-123"
```

---

## Get-TfcStateFile

**Synopsis:** Downloads the state file from a state version

**Description:** Downloads the raw Terraform state file content from a state version

**Parameters:**

- **StateVersionId** (string): The ID of the state version
- **OutputPath** (string): Optional path to save the state file

**Examples:**

```powershell
Get-TfcStateFile -StateVersionId "sv-123" -OutputPath "terraform.tfstate"
```

```powershell
Get-TfcStateFile -StateVersionId "sv-123"
```

---

## Get-TfcStateVersion

**Synopsis:** Gets state versions for a workspace

**Description:** Retrieves state versions from a Terraform Cloud workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **StateVersionId** (string): Optional state version ID to get a specific version
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcStateVersion -WorkspaceId "ws-123"
```

```powershell
Get-TfcStateVersion -StateVersionId "sv-abc123"
```

---

## Get-TfcStateVersionOutput

**Synopsis:** Gets state version outputs

**Description:** Retrieves outputs from a specific state version

**Parameters:**

- **StateVersionId** (string): The state version ID

**Examples:**

```powershell
Get-TfcStateVersionOutput -StateVersionId "sv-abc123"
```

---

## Get-TfcStateVersionOutputDetails

**Synopsis:** Gets details of a state version output

**Description:** Retrieves details of a specific state version output by ID

**Parameters:**

- **StateVersionOutputId** (string): The state version output ID

**Examples:**

```powershell
Get-TfcStateVersionOutputDetails -StateVersionOutputId "wsout-abc123"
```

---

## Get-TfcSubscription

**Synopsis:** List subscriptions

**Description:** Retrieves billing subscription information (requires admin access)

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Get-TfcSubscription -OrganizationName my-org
```

---

## Get-TfcTeam

**Synopsis:** Gets teams for an organization

**Description:** Retrieves teams from a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **AllPages** (switch): Switch to retrieve all pages of results

**Examples:**

```powershell
Get-TfcTeam -Organization "my-org"
```

---

## Get-TfcTeamAccess

**Synopsis:** Gets team access for a workspace

**Description:** Retrieves team access permissions for a specific workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID

**Examples:**

```powershell
Get-TfcTeamAccess -WorkspaceId "ws-123"
```

---

## Get-TfcTeamDetails

**Synopsis:** Gets details of a team

**Description:** Retrieves details of a specific team by ID

**Parameters:**

- **TeamId** (string): The team ID

**Examples:**

```powershell
Get-TfcTeamDetails -TeamId "team-abc123"
```

---

## Get-TfcTeamMember

**Synopsis:** Lists members of a team

**Description:** Retrieves all organization membership relationships for a specific team

**Parameters:**

- **TeamId** (string): The team ID

**Examples:**

```powershell
Get-TfcTeamMember -TeamId "team-abc123"
```

---

## Get-TfcTeamMemberDetails

**Synopsis:** Gets details of a team member

**Description:** Retrieves details of a specific organization membership within a team

**Parameters:**

- **TeamId** (string): The team ID
- **OrganizationMembershipId** (string): The organization membership ID

**Examples:**

```powershell
Get-TfcTeamMemberDetails -TeamId "team-abc123" -OrganizationMembershipId "ou-xyz789"
```

---

## Get-TfcTwoFactorSettings

**Synopsis:** Get two-factor authentication settings

**Description:** Retrieves 2FA settings for an organization

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Get-TfcTwoFactorSettings -OrganizationName my-org
```

---

## Get-TfcUserMembership

**Synopsis:** Lists organization memberships for the current user

**Description:** Retrieves all organization memberships for the authenticated user

**Parameters:**

- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcUserMembership
```

---

## Get-TfcUserToken

**Synopsis:** Gets user tokens

**Description:** Retrieves API tokens for the current user

**Examples:**

```powershell
Get-TfcUserToken
```

---

## Get-TfcVariableSet

**Synopsis:** Gets variable sets for an organization

**Description:** Retrieves variable sets from a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcVariableSet -Organization "my-org"
```

```powershell
Get-TfcVariableSet -Organization "my-org" -AllPages
```

---

## Get-TfcVariableSetDetails

**Synopsis:** Gets details of a specific variable set

**Description:** Retrieves detailed information about a variable set by its ID

**Parameters:**

- **VariableSetId** (string): The variable set ID

**Examples:**

```powershell
Get-TfcVariableSetDetails -VariableSetId "varset-abc123"
```

---

## Get-TfcVariableSetVariable

**Synopsis:** Gets variables from a variable set

**Description:** Retrieves variables from a variable set. Can list all variables or get a specific variable by ID.

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **VariableId** (string): Optional variable ID to get a specific variable

**Examples:**

```powershell
Get-TfcVariableSetVariable -VariableSetId "varset-abc123"
```

```powershell
Get-TfcVariableSetVariable -VariableSetId "varset-abc123" -VariableId "var-xyz789"
```

---

## Get-TfcVCSEvent

**Synopsis:** Gets VCS events for a workspace

**Description:** Retrieves version control system events for debugging VCS connections

**Parameters:**

- **WorkspaceId** (string): The workspace ID

**Examples:**

```powershell
Get-TfcVCSEvent -WorkspaceId "ws-123"
```

---

## Get-TfcVCSEventDetails

**Synopsis:** Get detailed VCS event information

**Description:** Retrieves detailed information about a specific VCS event

**Parameters:**

- **VCSEventId** (string): The ID of the VCS event (format: vcsev-xxxxx)

**Examples:**

```powershell
Get-TfcVCSEventDetails -VCSEventId vcsev-abc123
```

---

## Get-TfcWorkspace

**Synopsis:** Gets workspaces from an organization

**Description:** Retrieves workspaces from a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): Optional workspace name to get a specific workspace
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcWorkspace -Organization "my-org"
```

```powershell
Get-TfcWorkspace -Organization "my-org" -Name "my-workspace"
```

```powershell
Get-TfcWorkspace -Organization "my-org" -AllPages
```

---

## Get-TfcWorkspaceReadme

**Synopsis:** Gets workspace README content

**Description:** Retrieves the README

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace to get README for

**Examples:**

```powershell
Get-TfcWorkspaceReadme -WorkspaceId "ws-123"
```

---

## Get-TfcWorkspaceResource

**Synopsis:** Gets workspace resources

**Description:** Retrieves resources managed by a workspace from the latest state

**Parameters:**

- **WorkspaceId** (string): The workspace ID

**Examples:**

```powershell
Get-TfcWorkspaceResource -WorkspaceId "ws-123"
```

---

## Get-TfcWorkspaceResourceDetails

**Synopsis:** Get detailed workspace resource information

**Description:** Retrieves detailed information about a specific resource managed by a workspace

**Parameters:**

- **ResourceId** (string): The ID of the resource (format: wsres-xxxxx)

**Examples:**

```powershell
Get-TfcWorkspaceResourceDetails -ResourceId wsres-abc123
```

---

## Get-TfcWorkspaceRunTask

**Synopsis:** Gets workspace run tasks

**Description:** Retrieves run tasks attached to a workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID

**Examples:**

```powershell
Get-TfcWorkspaceRunTask -WorkspaceId "ws-123"
```

---

## Get-TfcWorkspaceTag

**Synopsis:** Gets tags from a workspace

**Description:** Retrieves all tags assigned to a workspace

**Parameters:**

- **Organization** (string): The organization name
- **Workspace** (string): The workspace name

**Examples:**

```powershell
Get-TfcWorkspaceTag -Organization "my-org" -Workspace "my-workspace"
```

---

## Get-TfcWorkspaceVariable

**Synopsis:** Gets variables from a workspace

**Description:** Retrieves all variables from a specific workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID

**Examples:**

```powershell
Get-TfcWorkspaceVariable -WorkspaceId "ws-1234567890abcdef"
```

---

## Get-TfcWorkspaceVariableSet

**Synopsis:** Gets variable sets for a workspace

**Description:** Retrieves variable sets assigned to a specific workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **AllPages** (switch): Switch to retrieve all pages of results
- **PageSize** (int): Number of items per page (1-100, default 20)
- **PageNumber** (int): Page number to retrieve (default 1)

**Examples:**

```powershell
Get-TfcWorkspaceVariableSet -WorkspaceId "ws-abc123"
```

```powershell
Get-TfcWorkspaceVariableSet -WorkspaceId "ws-abc123" -AllPages
```

---

## Grant-TfcAdminPrivilege

**Synopsis:** Grant admin privileges to a user

**Description:** Grants site admin privileges to a user (requires admin access)

**Parameters:**

- **UserId** (string): The ID of the user (format: user-xxxxx)

**Examples:**

```powershell
Grant-TfcAdminPrivilege -UserId user-abc123
```

---

## Invoke-TfcConfigurationUpload

**Synopsis:** Uploads configuration files to a configuration version

**Description:** Uploads a tarball of Terraform configuration files to a configuration version. The tarball should be gzipped and contain

**Parameters:**

- **UploadUrl** (string): The upload URL from the configuration version (data.attributes.upload-url)
- **TarballPath** (string): Path to the .tar.gz file containing Terraform configuration

**Examples:**

```powershell
$cv = New-TfcConfigurationVersion -WorkspaceId "ws-abc123"
    Invoke-TfcConfigurationUpload -UploadUrl $cv.data.attributes.'upload-url' -TarballPath "./config.tar.gz"
```

---

## Invoke-TfcConfigurationVersionArchive

**Synopsis:** Archives a configuration version

**Description:** Triggers the archive action on a configuration version, making it read-only

**Parameters:**

- **ConfigurationVersionId** (string): The configuration version ID to archive

**Examples:**

```powershell
Invoke-TfcConfigurationVersionArchive -ConfigurationVersionId "cv-abc123"
```

---

## Invoke-TfcExplorerQuery

**Synopsis:** Execute a GraphQL explorer query

**Description:** Executes a GraphQL query against the Terraform Cloud API

**Parameters:**

- **Query** (string): The GraphQL query to execute
- **Variables** (hashtable): Optional variables for the GraphQL query

**Examples:**

```powershell
Invoke-TfcExplorerQuery -Query "query { organization(name: \"my-org\") { name } }"
```

---

## Invoke-TfcNoCodeWorkspaceUpgrade

**Synopsis:** Initiates an upgrade for a no-code workspace

**Description:** Triggers an upgrade process for a workspace provisioned from a no-code module

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module (format: ncm-xxxxx)
- **WorkspaceId** (string): The workspace ID to upgrade

**Examples:**

```powershell
Invoke-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId "ncm-abc123" -WorkspaceId "ws-xyz789"
```

---

## Invoke-TfcOrganizationMembershipInvite

**Synopsis:** Sends an organization membership invitation

**Description:** Invites a user to join an organization via email

**Parameters:**

- **Organization** (string): The name of the organization
- **Email** (string): The email address of the user to invite
- **TeamIds** (string[]): Optional array of team IDs to add the user to

**Examples:**

```powershell
Invoke-TfcOrganizationMembershipInvite -Organization "my-org" -Email "user@example.com"
```

```powershell
Invoke-TfcOrganizationMembershipInvite -Organization "my-org" -Email "user@example.com" -TeamIds @("team-123", "team-456")
```

---

## Invoke-TfcPolicyUpload

**Synopsis:** Uploads policy code content

**Description:** Uploads or updates the code content for a Sentinel or OPA policy

**Parameters:**

- **PolicyId** (string): The policy ID
- **PolicyCode** (string): The policy code content

**Examples:**

```powershell
Invoke-TfcPolicyUpload -PolicyId "pol-123" -PolicyCode $code
```

---

## Invoke-TfcRegistryModuleTestConfigUpload

**Synopsis:** Uploads a test configuration to a registry module

**Description:** Uploads a tarball containing test configuration to the upload URL from New-TfcRegistryModuleTestConfigVersion

**Parameters:**

- **UploadUrl** (string): The upload URL from the configuration version response
- **TarballPath** (string): Path to the tar.gz file containing the test configuration

**Examples:**

```powershell
Invoke-TfcRegistryModuleTestConfigUpload -UploadUrl "https://archivist.terraform.io/v1/object/..." -TarballPath "./test-config.tar.gz"
```

---

## Invoke-TfcRegistryModuleVersionUpload

**Synopsis:** Uploads a registry module version tarball

**Description:** Uploads a tarball containing Terraform module source code to a registry module version. The upload URL is obtained from a previously created module version.

**Parameters:**

- **UploadUrl** (string): The upload URL from the module version (data.links.upload)
- **TarballPath** (string): Path to the .tar.gz file containing the module source code

**Examples:**

```powershell
$version = New-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-org" -Name "vpc" -Provider "aws" -Version "1.0.0"
    Invoke-TfcRegistryModuleVersionUpload -UploadUrl $version.data.links.upload -TarballPath "./module.tar.gz"
```

---

## Invoke-TfcRegistryProviderPlatformUpload

**Synopsis:** Uploads a registry provider platform binary

**Description:** Uploads a provider platform binary to a registry provider platform. The upload URL is obtained from a previously created provider platform.

**Parameters:**

- **UploadUrl** (string): The upload URL from the provider platform (data.links.provider-binary-upload)
- **FilePath** (string): Path to the provider binary file to upload (e.g., terraform-provider-custom_1.0.0_linux_amd64.zip)

**Examples:**

```powershell
$platform = New-TfcRegistryProviderPlatform -OrganizationName "my-org" -RegistryName "private" -Namespace "my-org" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64" -Shasum "abc123..." -Filename "terraform-provider-custom_1.0.0_linux_amd64.zip"
    Invoke-TfcRegistryProviderPlatformUpload -UploadUrl $platform.data.links.'provider-binary-upload' -FilePath "./terraform-provider-custom_1.0.0_linux_amd64.zip"
```

---

## Invoke-TfcRegistryProviderVersionUpload

**Synopsis:** Uploads a registry provider version binary

**Description:** Uploads a provider binary to a registry provider version. The upload URL is obtained from a previously created provider version.

**Parameters:**

- **UploadUrl** (string): The upload URL from the provider version (data.links.shasums-upload or data.links.shasums-sig-upload)
- **FilePath** (string): Path to the file to upload (SHA256SUMS or SHA256SUMS.sig)

**Examples:**

```powershell
$version = New-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-org" -Name "custom" -Version "1.0.0" -KeyId "abc123" -Protocols @("5.0")
    Invoke-TfcRegistryProviderVersionUpload -UploadUrl $version.data.links.'shasums-upload' -FilePath "./SHA256SUMS"
```

---

## Invoke-TfcRunForceExecute

**Synopsis:** Force executes a run

**Description:** Forces a run to execute immediately, bypassing normal queue rules

**Parameters:**

- **RunId** (string): The run ID to force execute

**Examples:**

```powershell
Invoke-TfcRunForceExecute -RunId "run-abc123"
```

---

## Invoke-TfcStateRollback

**Synopsis:** Rollback workspace to previous state

**Description:** Rolls back a workspace to a previous state version

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace (format: ws-xxxxx)
- **StateVersionId** (string): The ID of the state version to roll back to (format: sv-xxxxx)

**Examples:**

```powershell
Invoke-TfcStateRollback -WorkspaceId ws-abc123 -StateVersionId sv-xyz789
```

---

## Invoke-TfcWorkspaceForceUnlock

**Synopsis:** Force unlocks a workspace

**Description:** Force unlocks a workspace, even if it was locked by another user or a run

**Parameters:**

- **WorkspaceId** (string): The workspace ID to force unlock

**Examples:**

```powershell
Invoke-TfcWorkspaceForceUnlock -WorkspaceId "ws-abc123"
```

---

## Lock-TfcStateVersion

**Synopsis:** Locks a state version

**Description:** Locks a state version to prevent modifications

**Parameters:**

- **StateVersionId** (string): The ID of the state version to lock
- **Reason** (string): Optional reason for locking the state version

**Examples:**

```powershell
Lock-TfcStateVersion -StateVersionId "sv-123" -Reason "Maintenance window"
```

---

## Lock-TfcWorkspace

**Synopsis:** Locks a workspace

**Description:** Locks a workspace to prevent runs

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The workspace name
- **Reason** (string): Optional reason for locking the workspace

**Examples:**

```powershell
Lock-TfcWorkspace -Organization "my-org" -Name "my-workspace" -Reason "Maintenance"
```

---

## Move-TfcWorkspaceToProject

**Synopsis:** Moves workspace(s) to a project

**Description:** Moves one or more workspaces into a specified project

**Parameters:**

- **ProjectId** (string): The project ID to move workspaces into
- **WorkspaceIds** (string[]): Array of workspace IDs to move into the project

**Examples:**

```powershell
Move-TfcWorkspaceToProject -ProjectId "prj-abc123" -WorkspaceIds @("ws-123", "ws-456")
```

---

## New-TfcAgentPool

**Synopsis:** Creates an agent pool

**Description:** Creates a new agent pool for self-hosted agents

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The agent pool name
- **OrganizationScoped** (bool): Whether the pool is available to all workspaces (default: true)

**Examples:**

```powershell
New-TfcAgentPool -Organization "my-org" -Name "production-agents"
```

---

## New-TfcAgentToken

**Synopsis:** Creates an agent token

**Description:** Creates a new authentication token for agents to register with a pool

**Parameters:**

- **AgentPoolId** (string): The agent pool ID
- **Description** (string): Description for the token

**Examples:**

```powershell
New-TfcAgentToken -AgentPoolId "apool-abc123" -Description "Production agent token"
```

---

## New-TfcAuditTrailToken

**Synopsis:** Creates an audit trail token

**Description:** Generates a new audit trail token for streaming audit logs (admin only)

**Parameters:**

- **Organization** (string): The name of the organization
- **ExpiresAt** (datetime): Optional expiration date for the token

**Examples:**

```powershell
New-TfcAuditTrailToken -Organization "my-org"
```

```powershell
New-TfcAuditTrailToken -Organization "my-org" -ExpiresAt (Get-Date).AddDays(90)
```

---

## New-TfcChangeRequest

**Synopsis:** Create a new change request

**Description:** Creates a new change request for structured approval workflows

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace (format: ws-xxxxx)
- **Message** (string): The message describing the change request
- **ConfigurationVersionId** (string): The ID of the configuration version (format: cv-xxxxx)

**Examples:**

```powershell
New-TfcChangeRequest -WorkspaceId ws-abc123 -Message "Update production infrastructure" -ConfigurationVersionId cv-xyz789
```

---

## New-TfcComment

**Synopsis:** Creates a comment on a run

**Description:** Adds a comment to a Terraform run for collaboration

**Parameters:**

- **RunId** (string): The run ID
- **Body** (string): The comment text

**Examples:**

```powershell
New-TfcComment -RunId "run-123" -Body "Approved for production deployment"
```

---

## New-TfcConfigurationVersion

**Synopsis:** Creates a new configuration version

**Description:** Creates a new configuration version for a workspace to prepare for code upload

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **Speculative** (switch): Whether this is a speculative plan (optional, default false)
- **Provisional** (switch): Whether this configuration version can be used for planning (optional)
- **AutoQueueRuns** (bool): Whether to automatically queue a run after upload (optional, default true)

**Examples:**

```powershell
New-TfcConfigurationVersion -WorkspaceId "ws-abc123"
```

```powershell
New-TfcConfigurationVersion -WorkspaceId "ws-abc123" -Speculative -AutoQueueRuns:$false
```

---

## New-TfcGPGKey

**Synopsis:** Creates a new GPG key

**Description:** Uploads a new GPG key to the specified registry

**Parameters:**

- **RegistryName** (string): The registry name (e.g., "private")
- **Namespace** (string): The namespace (organization name)
- **AsciiArmor** (string): The ASCII-armored GPG public key

**Examples:**

```powershell
New-TfcGPGKey -RegistryName "private" -Namespace "my-org" -AsciiArmor "-----BEGIN PGP PUBLIC KEY BLOCK-----..."
```

---

## New-TfcHYOKConfiguration

**Synopsis:** Creates a new HYOK configuration

**Description:** Creates a new Hold Your Own Key (HYOK) configuration for the specified organization

**Parameters:**

- **Organization** (string): The name of the organization
- **Name** (string): The name of the HYOK configuration
- **KeyProviderId** (string): The ID of the key provider
- **KeyName** (string): The name of the encryption key
- **KeyVersion** (string): The version of the encryption key (optional)

**Examples:**

```powershell
New-TfcHYOKConfiguration -Organization "my-org" -Name "prod-key" -KeyProviderId "kp-abc123" -KeyName "my-key"
```

```powershell
New-TfcHYOKConfiguration -Organization "my-org" -Name "prod-key" -KeyProviderId "kp-abc123" -KeyName "my-key" -KeyVersion "1"
```

---

## New-TfcNoCodeModule

**Synopsis:** Create a no-code module

**Description:** Creates a no-code module for self-service infrastructure provisioning

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryModuleId** (string): The ID of the registry module to use
- **Name** (string): The name of the no-code module
- **Enabled** (bool): Whether the module is enabled for use

**Examples:**

```powershell
New-TfcNoCodeModule -OrganizationName my-org -RegistryModuleId rm-abc123 -Name "S3 Bucket" -Enabled $true
```

---

## New-TfcNoCodeWorkspace

**Synopsis:** Creates a workspace from a no-code module

**Description:** Creates a new workspace using a no-code module for self-service provisioning. Optionally allows setting variable values for the workspace.

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module (format: ncm-xxxxx)
- **Name** (string): The name for the new workspace
- **Variables** (hashtable): Optional hashtable of variable values to configure on the workspace

**Examples:**

```powershell
New-TfcNoCodeWorkspace -NoCodeModuleId "ncm-abc123" -Name "my-s3-bucket"
```

```powershell
New-TfcNoCodeWorkspace -NoCodeModuleId "ncm-abc123" -Name "my-s3-bucket" -Variables @{bucket_name="my-bucket"; region="us-east-1"}
```

---

## New-TfcNotificationConfiguration

**Synopsis:** Creates a notification configuration

**Description:** Creates a new notification configuration for a workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **DestinationType** (string): Type: 'slack', 'generic', 'email', or 'microsoft-teams'
- **Name** (string): Configuration name
- **Url** (string): Webhook URL (for slack, generic, microsoft-teams)
- **Enabled** (bool): Whether enabled (default: true)
- **Triggers** (string[]): Array of triggers: 'run:created', 'run:planning', 'run:needs_attention', 'run:applying', 'run:completed', 'run:errored'
- **EmailAddresses** (string[]): Email addresses (for email type)
- **EmailUserIds** (string[]): User IDs to email (for email type)

**Examples:**

```powershell
New-TfcNotificationConfiguration -WorkspaceId "ws-123" -DestinationType "slack" -Name "Slack Alerts" -Url "https://hooks.slack.com/..." -Triggers @("run:completed", "run:errored")
```

---

## New-TfcOAuthClient

**Synopsis:** Creates a new OAuth client

**Description:** Creates a new OAuth client for VCS integration in Terraform Cloud

**Parameters:**

- **Organization** (string): The organization name to create the OAuth client in
- **ServiceProvider** (string): The VCS service provider (e.g., 'github', 'gitlab', 'bitbucket', 'azure_devops')
- **HttpUrl** (string): The HTTP URL of the VCS provider
- **ApiUrl** (string): The API URL of the VCS provider
- **Key** (string): OAuth application key/client ID
- **Secret** (string): OAuth application secret
- **Name** (string): Optional display name for the OAuth client

**Examples:**

```powershell
New-TfcOAuthClient -Organization "my-org" -ServiceProvider "github" -HttpUrl "https://github.com" -ApiUrl "https://api.github.com" -Key "clientid" -Secret "secret"
```

---

## New-TfcOrganization

**Synopsis:** Creates a new organization

**Description:** Creates a new organization in Terraform Cloud

**Parameters:**

- **Name** (string): The organization name
- **Email** (string): Admin email address for the organization
- **SessionTimeout** (int): Session timeout in minutes (optional)
- **SessionRemember** (int): Session remember duration in minutes (optional)
- **CollaboratorAuthPolicy** (string): Authentication policy: 'password', 'two_factor_mandatory' (optional)

**Examples:**

```powershell
New-TfcOrganization -Name "my-new-org" -Email "admin@example.com"
```

---

## New-TfcOrganizationTag

**Synopsis:** Creates a new organization tag

**Description:** Creates a new tag in an organization for categorizing workspaces

**Parameters:**

- **OrganizationName** (string): The organization name
- **Name** (string): The name for the new tag

**Examples:**

```powershell
New-TfcOrganizationTag -OrganizationName "my-org" -Name "production"
```

---

## New-TfcOrganizationToken

**Synopsis:** Creates an organization token

**Description:** Generates an API token for an organization

**Parameters:**

- **Organization** (string): The organization name
- **ExpiredAt** (string): Optional expiration date (RFC3339 format)

**Examples:**

```powershell
New-TfcOrganizationToken -Organization "my-org"
```

---

## New-TfcPlanExport

**Synopsis:** Creates a plan export

**Description:** Creates an export of a plan for compliance and auditing

**Parameters:**

- **PlanId** (string): The plan ID to export
- **DataType** (string): Export data type: 'sentinel-mock-bundle-v0' or 'opa-bundle-v0'

**Examples:**

```powershell
New-TfcPlanExport -PlanId "plan-abc123" -DataType "sentinel-mock-bundle-v0"
```

---

## New-TfcPolicy

**Synopsis:** Creates a new policy

**Description:** Creates a Sentinel or OPA policy for compliance enforcement

**Parameters:**

- **OrganizationName** (string): The organization name
- **Name** (string): The policy name
- **Description** (string): Optional policy description
- **Kind** (string): Policy kind: sentinel or opa
- **EnforcementLevel** (string): Enforcement level: advisory, soft-mandatory, or hard-mandatory
- **PolicyCode** (string): The policy code content

**Examples:**

```powershell
New-TfcPolicy -OrganizationName "my-org" -Name "require-tags" -Kind "sentinel" -Enforcement "soft-mandatory" -PolicyCode $code
```

---

## New-TfcPolicySet

**Synopsis:** Creates a new policy set

**Description:** Creates a policy set to group policies and target workspaces or projects

**Parameters:**

- **OrganizationName** (string): The organization name
- **Name** (string): The policy set name
- **Description** (string): Optional policy set description
- **Global** (switch): Whether this is a global policy set (applies to all workspaces)
- **Kind** (string): Policy kind: sentinel or opa
- **Overridable** (switch): Whether policy checks can be overridden

**Examples:**

```powershell
New-TfcPolicySet -OrganizationName "my-org" -Name "production-policies" -Kind "sentinel"
```

---

## New-TfcPolicySetParameter

**Synopsis:** Creates a new policy set parameter

**Description:** Creates a new parameter for a policy set in Terraform Cloud

**Parameters:**

- **PolicySetId** (string): The ID of the policy set to add the parameter to
- **Key** (string): The parameter key/name
- **Value** (string): The parameter value
- **Category** (string): The parameter category: 'policy-set' (default)
- **Sensitive** (switch): Whether the parameter value is sensitive

**Examples:**

```powershell
New-TfcPolicySetParameter -PolicySetId "polset-123" -Key "environment" -Value "production"
```

```powershell
New-TfcPolicySetParameter -PolicySetId "polset-123" -Key "api_key" -Value "secret123" -Sensitive
```

---

## New-TfcProject

**Synopsis:** Creates a new project

**Description:** Creates a new project in a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The project name
- **Description** (string): Optional description for the project

**Examples:**

```powershell
New-TfcProject -Organization "my-org" -Name "production" -Description "Production workspaces"
```

---

## New-TfcRegistryModule

**Synopsis:** Creates a registry module from VCS

**Description:** Creates a new registry module in Terraform Cloud from a VCS repository

**Parameters:**

- **Organization** (string): The organization name
- **VcsRepoIdentifier** (string): The VCS repository identifier (e.g., "org/repo")
- **OAuthTokenId** (string): The OAuth token ID for VCS authentication

**Examples:**

```powershell
New-TfcRegistryModule -Organization "my-org" -VcsRepoIdentifier "myorg/terraform-aws-vpc" -OAuthTokenId "ot-abc123"
```

---

## New-TfcRegistryModuleTestConfigVersion

**Synopsis:** Creates a configuration version for module tests

**Description:** Creates a new configuration version for testing a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name

**Examples:**

```powershell
New-TfcRegistryModuleTestConfigVersion -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
```

---

## New-TfcRegistryModuleTestRun

**Synopsis:** Creates a new test run for a registry module

**Description:** Initiates a new test run for a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name
- **ConfigurationVersionId** (string): Optional configuration version ID to use for the test

**Examples:**

```powershell
New-TfcRegistryModuleTestRun -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
```

---

## New-TfcRegistryModuleTestVariable

**Synopsis:** Creates a test variable for a registry module

**Description:** Creates a new variable for testing a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name
- **Key** (string): The variable key name
- **Value** (string): The variable value
- **Category** (string): The variable category (terraform or env)
- **HCL** (bool): Whether the value is HCL
- **Sensitive** (bool): Whether the variable is sensitive

**Examples:**

```powershell
New-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -Key "region" -Value "us-east-1" -Category "terraform"
```

---

## New-TfcRegistryModuleVersion

**Synopsis:** Create a new registry module version

**Description:** Creates a new version of a registry module

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name
- **Version** (string): The version string (e.g., "1.0.0")

**Examples:**

```powershell
New-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.1.0"
```

---

## New-TfcRegistryProvider

**Synopsis:** Creates a registry provider

**Description:** Creates a new registry provider in Terraform Cloud

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The provider name
- **RegistryName** (string): The registry name (default: "private")

**Examples:**

```powershell
New-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
```

---

## New-TfcRegistryProviderPlatform

**Synopsis:** Create a registry provider platform

**Description:** Adds a new platform to a provider version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider
- **Version** (string): The version string
- **Os** (string): Operating system (e.g., "linux", "darwin", "windows")
- **Arch** (string): Architecture (e.g., "amd64", "arm64", "386")
- **Shasum** (string): SHA256 checksum of the binary
- **Filename** (string): Filename of the binary

**Examples:**

```powershell
New-TfcRegistryProviderPlatform -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64" -Shasum "abc123..." -Filename "terraform-provider-custom_1.0.0_linux_amd64.zip"
```

---

## New-TfcRegistryProviderVersion

**Synopsis:** Create a new registry provider version

**Description:** Creates a new version of a registry provider

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider
- **Version** (string): The version string
- **KeyId** (string): GPG key ID for signing
- **Protocols** (string[]): Array of supported protocol versions (e.g., @("5.0", "6.0"))

**Examples:**

```powershell
New-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Protocols @("5.0")
```

---

## New-TfcRegistryWebhook

**Synopsis:** Create a registry webhook

**Description:** Creates a new webhook for registry events

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **Url** (string): The webhook URL
- **Events** (string[]): Array of events to trigger the webhook (e.g., @("module.published", "provider.published"))
- **Enabled** (bool): Whether the webhook is enabled (default: true)

**Examples:**

```powershell
New-TfcRegistryWebhook -OrganizationName "my-org" -Url "https://example.com/webhook" -Events @("module.published")
```

---

## New-TfcReservedTagKey

**Synopsis:** Creates a reserved tag key

**Description:** Creates a new reserved tag key that cannot be used for workspace tagging

**Parameters:**

- **Organization** (string): The name of the organization
- **Key** (string): The tag key to reserve

**Examples:**

```powershell
New-TfcReservedTagKey -Organization "my-org" -Key "production"
```

---

## New-TfcRun

**Synopsis:** Creates a new run

**Description:** Creates a new run in a Terraform Cloud workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **Message** (string): Optional message for the run
- **IsDestroy** (switch): Whether this is a destroy run
- **AutoApply** (switch): Whether to auto-apply this run
- **ConfigurationVersionId** (string): Optional configuration version ID
- **TargetAddrs** (string[])

**Examples:**

```powershell
New-TfcRun -WorkspaceId "ws-123" -Message "Deploy new infrastructure"
```

```powershell
New-TfcRun -WorkspaceId "ws-123" -IsDestroy -Message "Destroy test environment"
```

---

## New-TfcRunTask

**Synopsis:** Creates a run task

**Description:** Creates a new run task in an organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The run task name
- **Url** (string): The URL of the external service to call
- **HmacKey** (string): Optional HMAC key for request signing
- **Enabled** (bool): Whether the task is enabled (default: true)
- **Description** (string): Optional description

**Examples:**

```powershell
New-TfcRunTask -Organization "my-org" -Name "security-scan" -Url "https://scanner.example.com/validate"
```

---

## New-TfcRunTrigger

**Synopsis:** Creates a run trigger

**Description:** Creates a link between a source workspace and a target workspace for run orchestration

**Parameters:**

- **SourceWorkspaceId** (string): The source workspace ID that will trigger runs
- **TargetWorkspaceId** (string): The target workspace ID that will be triggered

**Examples:**

```powershell
New-TfcRunTrigger -SourceWorkspaceId "ws-source123" -TargetWorkspaceId "ws-target456"
```

---

## New-TfcSSHKey

**Synopsis:** Creates an SSH key

**Description:** Uploads an SSH private key for accessing private Git repositories

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The SSH key name
- **Value** (string): The SSH private key content

**Examples:**

```powershell
$sshKey = Get-Content ~/.ssh/id_rsa -Raw
    New-TfcSSHKey -Organization "my-org" -Name "GitHub Key" -Value $sshKey
```

---

## New-TfcStack

**Synopsis:** Create a new stack

**Description:** Creates a new Terraform stack for orchestrating multiple workspaces

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **Name** (string): The name of the stack
- **Description** (string): Optional description of the stack
- **VcsRepoIdentifier** (string): VCS repository identifier (e.g., "org/repo")
- **OAuthTokenId** (string): OAuth token ID for VCS integration
- **ProjectId** (string): Optional project ID to associate with the stack

**Examples:**

```powershell
New-TfcStack -OrganizationName "my-org" -Name "production-stack" -Description "Production infrastructure"
```

---

## New-TfcStackDeployment

**Synopsis:** Create a new stack deployment

**Description:** Triggers a new deployment for a stack

**Parameters:**

- **StackId** (string): The ID of the stack
- **Message** (string): Optional message describing the deployment

**Examples:**

```powershell
New-TfcStackDeployment -StackId "stack-123" -Message "Deploy production changes"
```

---

## New-TfcStateVersion

**Synopsis:** Creates a new state version

**Description:** Creates a new state version in a Terraform Cloud workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **StateData** (string): The state JSON data as a string
- **MD5** (string): MD5 hash of the state data
- **Serial** (int): The serial number for the state
- **Lineage** (string): The lineage for the state
- **Force** (switch): Force push even if serial/lineage don't match

**Examples:**

```powershell
$stateJson = Get-Content ./terraform.tfstate -Raw
    New-TfcStateVersion -WorkspaceId "ws-123" -StateData $stateJson -MD5 "abc123..." -Serial 1
```

---

## New-TfcStateVersionJson

**Synopsis:** Creates a new state version with JSON content

**Description:** Creates a new state version by uploading JSON state content

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace
- **StateJson** (object): The JSON state content as a string or hashtable
- **MD5Hash** (string): MD5 hash of the state content (auto-calculated if not provided)
- **Serial** (int): Serial number for the state version (auto-incremented if not provided)
- **Force** (switch): Force creation without confirmation

**Examples:**

```powershell
New-TfcStateVersionJson -WorkspaceId "ws-123" -StateJson $stateContent
```

```powershell
$state = Get-Content terraform.tfstate -Raw | ConvertFrom-Json
    New-TfcStateVersionJson -WorkspaceId "ws-123" -StateJson $state -Force
```

---

## New-TfcTeam

**Synopsis:** Creates a new team

**Description:** Creates a new team in a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The team name
- **Visibility** (string): Team visibility: 'secret' (default), 'organization'
- **OrganizationAccess** (hashtable): Hashtable of organization-level permissions (manage-workspaces, manage-policies, etc.)

**Examples:**

```powershell
New-TfcTeam -Organization "my-org" -Name "developers"
```

```powershell
New-TfcTeam -Organization "my-org" -Name "admins" -OrganizationAccess @{ "manage-workspaces" = $true }
```

---

## New-TfcTeamToken

**Synopsis:** Creates a team token

**Description:** Generates an API token for a team

**Parameters:**

- **TeamId** (string): The team ID
- **ExpiredAt** (string): Optional expiration date (RFC3339 format)

**Examples:**

```powershell
New-TfcTeamToken -TeamId "team-abc123"
```

---

## New-TfcUserImpersonation

**Synopsis:** Impersonate a user

**Description:** Creates an impersonation token to act as another user (requires admin access, audited)

**Parameters:**

- **UserId** (string): The ID of the user to impersonate (format: user-xxxxx)

**Examples:**

```powershell
New-TfcUserImpersonation -UserId user-abc123
```

---

## New-TfcUserToken

**Synopsis:** Creates a user token

**Description:** Generates a new API token for the current user

**Parameters:**

- **Description** (string): Description for the token
- **ExpiredAt** (string): Optional expiration date (RFC3339 format)

**Examples:**

```powershell
New-TfcUserToken -Description "CI/CD Pipeline Token"
```

---

## New-TfcVariableSet

**Synopsis:** Creates a new variable set

**Description:** Creates a new variable set in a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The variable set name
- **Description** (string): Optional description for the variable set
- **Global** (switch): Whether this variable set should be applied to all workspaces
- **Priority** (switch): Whether variable set variables override workspace variables (optional)

**Examples:**

```powershell
New-TfcVariableSet -Organization "my-org" -Name "aws-creds"
```

```powershell
New-TfcVariableSet -Organization "my-org" -Name "global-vars" -Global -Description "Global variables"
```

---

## New-TfcVariableSetVariable

**Synopsis:** Creates a variable in a variable set

**Description:** Creates a new variable within a variable set, supporting both Terraform and environment variable categories

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **Key** (string): The variable name/key
- **Value** (string): The variable value
- **Description** (string): Optional description for the variable
- **Category** (string): The variable category ('terraform' or 'env', default: 'terraform')
- **Sensitive** (bool): Whether the variable is sensitive (default: false)
- **HCL** (bool): Whether the variable should be parsed as HCL (default: false)

**Examples:**

```powershell
New-TfcVariableSetVariable -VariableSetId "varset-abc123" -Key "region" -Value "us-east-1" -Category "terraform"
```

---

## New-TfcWorkspace

**Synopsis:** Creates a new workspace

**Description:** Creates a new workspace in a Terraform Cloud organization

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The workspace name
- **TerraformVersion** (string): The Terraform version to use (default: "latest")
- **WorkingDirectory** (string): The working directory for Terraform operations
- **Description** (string): Optional description for the workspace
- **AutoApply** (switch): Whether to automatically apply successful plans
- **VcsRepo** (hashtable): VCS repository configuration (hashtable with repo-identifier, branch, etc.)

**Examples:**

```powershell
New-TfcWorkspace -Organization "my-org" -Name "new-workspace"
```

```powershell
New-TfcWorkspace -Organization "my-org" -Name "new-workspace" -AutoApply -TerraformVersion "1.5.0"
```

---

## Publish-TfcProviderVersion

**Synopsis:** Publish a provider version binary

**Description:** Uploads a provider binary for a specific platform

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider
- **Version** (string): The version string
- **Os** (string): Operating system
- **Arch** (string): Architecture
- **FilePath** (string): Path to the provider binary (zip file)

**Examples:**

```powershell
Publish-TfcProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64" -FilePath "./terraform-provider-custom_1.0.0_linux_amd64.zip"
```

---

## Publish-TfcRegistryModuleVersion

**Synopsis:** Publish a registry module version

**Description:** Uploads module content for a specific version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name
- **Version** (string): The version string
- **FilePath** (string): Path to the module tarball (.tar.gz)

**Examples:**

```powershell
Publish-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0" -FilePath "./module.tar.gz"
```

---

## Remove-TfcAgent

**Synopsis:** Deletes an agent

**Description:** Removes a specific agent by ID

**Parameters:**

- **AgentId** (string): The agent ID to delete

**Examples:**

```powershell
Remove-TfcAgent -AgentId "agent-abc123"
```

---

## Remove-TfcAgentPool

**Synopsis:** Removes an agent pool

**Description:** Deletes an agent pool from an organization

**Parameters:**

- **AgentPoolId** (string): The agent pool ID to delete

**Examples:**

```powershell
Remove-TfcAgentPool -AgentPoolId "apool-abc123"
```

---

## Remove-TfcAgentToken

**Synopsis:** Removes an agent token

**Description:** Deletes an agent authentication token

**Parameters:**

- **AgentTokenId** (string): The agent token ID to delete

**Examples:**

```powershell
Remove-TfcAgentToken -AgentTokenId "at-abc123"
```

---

## Remove-TfcAuditTrailToken

**Synopsis:** Removes an audit trail token

**Description:** Deletes an audit trail token (admin only)

**Parameters:**

- **TokenId** (string): The ID of the audit trail token to remove

**Examples:**

```powershell
Remove-TfcAuditTrailToken -TokenId "at-123"
```

---

## Remove-TfcGPGKey

**Synopsis:** Deletes a GPG key

**Description:** Removes a GPG key from the specified registry

**Parameters:**

- **RegistryName** (string): The registry name (e.g., "private")
- **Namespace** (string): The namespace (organization name)
- **KeyId** (string): The GPG key ID to delete

**Examples:**

```powershell
Remove-TfcGPGKey -RegistryName "private" -Namespace "my-org" -KeyId "12345"
```

---

## Remove-TfcHYOKConfiguration

**Synopsis:** Deletes a HYOK configuration

**Description:** Removes a Hold Your Own Key (HYOK) configuration

**Parameters:**

- **ConfigurationId** (string): The ID of the HYOK configuration to delete
- **Force** (switch): Skip confirmation prompt

**Examples:**

```powershell
Remove-TfcHYOKConfiguration -ConfigurationId "hyokc-abc123"
```

```powershell
Remove-TfcHYOKConfiguration -ConfigurationId "hyokc-abc123" -Force
```

---

## Remove-TfcNoCodeModule

**Synopsis:** Remove a no-code module

**Description:** Deletes a no-code module from Terraform Cloud

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module to delete (format: ncm-xxxxx)

**Examples:**

```powershell
Remove-TfcNoCodeModule -NoCodeModuleId ncm-abc123
```

---

## Remove-TfcNotificationConfiguration

**Synopsis:** Removes a notification configuration

**Description:** Deletes a notification configuration from a workspace

**Parameters:**

- **NotificationConfigurationId** (string): The notification configuration ID to delete

**Examples:**

```powershell
Remove-TfcNotificationConfiguration -NotificationConfigurationId "nc-abc123"
```

---

## Remove-TfcOAuthClient

**Synopsis:** Removes an OAuth client

**Description:** Deletes an OAuth client from Terraform Cloud. This will disconnect VCS integration for workspaces using this client.

**Parameters:**

- **OAuthClientId** (string): The ID of the OAuth client to remove

**Examples:**

```powershell
Remove-TfcOAuthClient -OAuthClientId "oc-123"
```

---

## Remove-TfcOAuthToken

**Synopsis:** Remove an OAuth token

**Description:** Deletes an OAuth token from Terraform Cloud

**Parameters:**

- **OAuthTokenId** (string): The ID of the OAuth token to delete (format: ot-xxxxx)

**Examples:**

```powershell
Remove-TfcOAuthToken -OAuthTokenId ot-abc123
```

---

## Remove-TfcOrganization

**Synopsis:** Removes an organization

**Description:** Deletes an organization from Terraform Cloud. This is a destructive operation that cannot be undone.

**Parameters:**

- **Organization** (string): The organization name to delete

**Examples:**

```powershell
Remove-TfcOrganization -Organization "my-org"
```

---

## Remove-TfcOrganizationMembership

**Synopsis:** Removes an organization membership

**Description:** Removes a member from an organization by deleting their membership

**Parameters:**

- **MembershipId** (string): The organization membership ID to remove

**Examples:**

```powershell
Remove-TfcOrganizationMembership -MembershipId "ou-abc123"
```

---

## Remove-TfcOrganizationTag

**Synopsis:** Removes a tag from an organization

**Description:** Deletes a specific tag from an organization

**Parameters:**

- **OrganizationName** (string): The organization name
- **TagId** (string): The tag ID to remove

**Examples:**

```powershell
Remove-TfcOrganizationTag -OrganizationName "my-org" -TagId "tag-abc123"
```

---

## Remove-TfcOrganizationTagRelationship

**Synopsis:** Removes workspace relationships from a tag

**Description:** Removes the association between one or more workspaces and a specific tag

**Parameters:**

- **TagId** (string): The tag ID
- **WorkspaceIds** (string[]): Array of workspace IDs to remove from the tag

**Examples:**

```powershell
Remove-TfcOrganizationTagRelationship -TagId "tag-abc123" -WorkspaceIds @("ws-123", "ws-456")
```

---

## Remove-TfcOrganizationToken

**Synopsis:** Removes an organization token

**Description:** Deletes the API token for an organization

**Parameters:**

- **Organization** (string): The organization name

**Examples:**

```powershell
Remove-TfcOrganizationToken -Organization "my-org"
```

---

## Remove-TfcPlanExport

**Synopsis:** Deletes a plan export

**Description:** Removes a specific plan export by ID

**Parameters:**

- **PlanExportId** (string): The plan export ID to delete

**Examples:**

```powershell
Remove-TfcPlanExport -PlanExportId "pe-abc123"
```

---

## Remove-TfcPolicy

**Synopsis:** Removes a policy

**Description:** Deletes a Sentinel or OPA policy from the organization

**Parameters:**

- **PolicyId** (string): The policy ID to remove

**Examples:**

```powershell
Remove-TfcPolicy -PolicyId "pol-123"
```

---

## Remove-TfcPolicySet

**Synopsis:** Removes a policy set

**Description:** Deletes a policy set from the organization

**Parameters:**

- **PolicySetId** (string): The policy set ID to remove

**Examples:**

```powershell
Remove-TfcPolicySet -PolicySetId "polset-123"
```

---

## Remove-TfcPolicySetParameter

**Synopsis:** Removes a policy set parameter

**Description:** Deletes a parameter from a policy set in Terraform Cloud

**Parameters:**

- **ParameterId** (string): The ID of the parameter to remove

**Examples:**

```powershell
Remove-TfcPolicySetParameter -ParameterId "param-123"
```

---

## Remove-TfcPolicySetPolicy

**Synopsis:** Removes a policy from a policy set

**Description:** Detaches/removes a policy from a policy set in Terraform Cloud

**Parameters:**

- **PolicySetId** (string): The ID of the policy set to remove the policy from
- **PolicyId** (string): The ID of the policy to remove from the set

**Examples:**

```powershell
Remove-TfcPolicySetPolicy -PolicySetId "polset-123" -PolicyId "pol-456"
```

---

## Remove-TfcPolicySetProject

**Synopsis:** Removes projects from a policy set

**Description:** Detaches one or more projects from a policy set

**Parameters:**

- **PolicySetId** (string): The policy set ID
- **ProjectIds** (string[]): Array of project IDs to remove

**Examples:**

```powershell
Remove-TfcPolicySetProject -PolicySetId "polset-abc123" -ProjectIds @("prj-abc123")
```

---

## Remove-TfcPolicySetWorkspace

**Synopsis:** Removes workspaces from a policy set

**Description:** Detaches one or more workspaces from a policy set

**Parameters:**

- **PolicySetId** (string): The policy set ID
- **WorkspaceIds** (string[]): Array of workspace IDs to remove

**Examples:**

```powershell
Remove-TfcPolicySetWorkspace -PolicySetId "polset-abc123" -WorkspaceIds @("ws-abc123", "ws-def456")
```

---

## Remove-TfcProject

**Synopsis:** Removes a project

**Description:** Deletes a project from Terraform Cloud

**Parameters:**

- **ProjectId** (string): The project ID
- **Force** (switch): Skip confirmation prompt

**Examples:**

```powershell
Remove-TfcProject -ProjectId "prj-123"
```

---

## Remove-TfcProjectTeamAccess

**Synopsis:** Removes team access from a project

**Description:** Removes a team's access to a project by deleting the team-project relationship

**Parameters:**

- **TeamProjectId** (string): The team project relationship ID to remove

**Examples:**

```powershell
Remove-TfcProjectTeamAccess -TeamProjectId "tprj-abc123"
```

---

## Remove-TfcRegistryModule

**Synopsis:** Removes a registry module

**Description:** Deletes a registry module from Terraform Cloud

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The module name
- **Provider** (string): The provider name
- **Force** (switch): Skip confirmation prompt

**Examples:**

```powershell
Remove-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
```

---

## Remove-TfcRegistryModuleTestVariable

**Synopsis:** Deletes a test variable for a registry module

**Description:** Removes a variable from a private registry module's test configuration

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name
- **VariableId** (string): The variable ID to delete

**Examples:**

```powershell
Remove-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -VariableId "var-abc123"
```

---

## Remove-TfcRegistryModuleVersion

**Synopsis:** Delete a registry module version

**Description:** Removes a specific version of a registry module

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name
- **Version** (string): The version string to delete

**Examples:**

```powershell
Remove-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
```

---

## Remove-TfcRegistryProvider

**Synopsis:** Removes a registry provider

**Description:** Deletes a registry provider from Terraform Cloud

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The provider name
- **Force** (switch): Skip confirmation prompt

**Examples:**

```powershell
Remove-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
```

---

## Remove-TfcRegistryProviderPlatform

**Synopsis:** Delete a registry provider platform

**Description:** Removes a platform from a provider version

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider
- **Version** (string): The version string
- **Os** (string): Operating system
- **Arch** (string): Architecture

**Examples:**

```powershell
Remove-TfcRegistryProviderPlatform -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64"
```

---

## Remove-TfcRegistryProviderVersion

**Synopsis:** Delete a registry provider version

**Description:** Removes a specific version of a registry provider

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **RegistryName** (string): The registry name
- **Namespace** (string): The namespace of the provider
- **Name** (string): The name of the provider
- **Version** (string): The version string to delete

**Examples:**

```powershell
Remove-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0"
```

---

## Remove-TfcRegistryWebhook

**Synopsis:** Delete a registry webhook

**Description:** Removes a registry webhook

**Parameters:**

- **WebhookId** (string): The ID of the webhook to delete

**Examples:**

```powershell
Remove-TfcRegistryWebhook -WebhookId "webhook-123"
```

---

## Remove-TfcReservedTagKey

**Synopsis:** Deletes a reserved tag key

**Description:** Removes a specific reserved tag key

**Parameters:**

- **ReservedTagId** (string): The reserved tag ID to delete

**Examples:**

```powershell
Remove-TfcReservedTagKey -ReservedTagId "rtag-abc123"
```

---

## Remove-TfcRunTask

**Synopsis:** Removes a run task

**Description:** Deletes a run task from an organization

**Parameters:**

- **RunTaskId** (string): The run task ID to delete

**Examples:**

```powershell
Remove-TfcRunTask -RunTaskId "task-abc123"
```

---

## Remove-TfcRunTrigger

**Synopsis:** Removes a run trigger

**Description:** Deletes a run trigger between workspaces

**Parameters:**

- **RunTriggerId** (string): The run trigger ID to delete

**Examples:**

```powershell
Remove-TfcRunTrigger -RunTriggerId "rt-abc123"
```

---

## Remove-TfcSSHKey

**Synopsis:** Removes an SSH key

**Description:** Deletes an SSH key from an organization

**Parameters:**

- **SSHKeyId** (string): The SSH key ID to delete

**Examples:**

```powershell
Remove-TfcSSHKey -SSHKeyId "sshkey-abc123"
```

---

## Remove-TfcStack

**Synopsis:** Delete a stack

**Description:** Removes a stack from the organization

**Parameters:**

- **StackId** (string): The ID of the stack to delete
- **Force** (switch): Skip confirmation prompt

**Examples:**

```powershell
Remove-TfcStack -StackId "stack-123"
```

```powershell
Remove-TfcStack -StackId "stack-123" -Force
```

---

## Remove-TfcTeam

**Synopsis:** Removes a team

**Description:** Deletes a team from Terraform Cloud

**Parameters:**

- **TeamId** (string): The team ID to delete

**Examples:**

```powershell
Remove-TfcTeam -TeamId "team-abc123"
```

---

## Remove-TfcTeamMember

**Synopsis:** Removes members from a team

**Description:** Removes one or more organization members from a team

**Parameters:**

- **TeamId** (string): The team ID
- **OrganizationMembershipIds** (string[]): Array of organization membership IDs to remove from the team

**Examples:**

```powershell
Remove-TfcTeamMember -TeamId "team-abc123" -OrganizationMembershipIds @("ou-123", "ou-456")
```

---

## Remove-TfcTeamToken

**Synopsis:** Removes a team token

**Description:** Deletes the API token for a team

**Parameters:**

- **TeamId** (string): The team ID

**Examples:**

```powershell
Remove-TfcTeamToken -TeamId "team-abc123"
```

---

## Remove-TfcUser

**Synopsis:** Removes a user from the organization

**Description:** Deletes a user account from HCP Terraform (admin only)

**Parameters:**

- **UserId** (string): The ID of the user to remove

**Examples:**

```powershell
Remove-TfcUser -UserId "user-123"
```

---

## Remove-TfcUserToken

**Synopsis:** Removes a user token

**Description:** Deletes a user API token

**Parameters:**

- **TokenId** (string): The token ID to delete

**Examples:**

```powershell
Remove-TfcUserToken -TokenId "at-abc123"
```

---

## Remove-TfcVariableSet

**Synopsis:** Removes a variable set

**Description:** Deletes a variable set from Terraform Cloud

**Parameters:**

- **VariableSetId** (string): The variable set ID to delete

**Examples:**

```powershell
Remove-TfcVariableSet -VariableSetId "varset-abc123"
```

---

## Remove-TfcVariableSetProject

**Synopsis:** Removes a variable set from project(s)

**Description:** Removes a variable set assignment from one or more projects

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **ProjectIds** (string[]): Array of project IDs to remove the variable set from

**Examples:**

```powershell
Remove-TfcVariableSetProject -VariableSetId "varset-abc123" -ProjectIds @("prj-123", "prj-456")
```

---

## Remove-TfcVariableSetStack

**Synopsis:** Removes a variable set from stack(s)

**Description:** Removes a variable set assignment from one or more stacks

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **StackIds** (string[]): Array of stack IDs to remove the variable set from

**Examples:**

```powershell
Remove-TfcVariableSetStack -VariableSetId "varset-abc123" -StackIds @("stack-123", "stack-456")
```

---

## Remove-TfcVariableSetVariable

**Synopsis:** Removes a variable from a variable set

**Description:** Deletes a specific variable from a variable set

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **VariableId** (string): The variable ID to remove

**Examples:**

```powershell
Remove-TfcVariableSetVariable -VariableSetId "varset-abc123" -VariableId "var-xyz789"
```

---

## Remove-TfcVariableSetWorkspace

**Synopsis:** Removes a variable set from workspace(s)

**Description:** Removes a variable set assignment from one or more workspaces

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **WorkspaceIds** (string[]): Array of workspace IDs to remove the variable set from

**Examples:**

```powershell
Remove-TfcVariableSetWorkspace -VariableSetId "varset-abc123" -WorkspaceIds @("ws-123", "ws-456")
```

---

## Remove-TfcWorkspace

**Synopsis:** Removes a workspace

**Description:** Deletes a workspace from Terraform Cloud

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The workspace name
- **Force** (switch): Skip confirmation prompt

**Examples:**

```powershell
Remove-TfcWorkspace -Organization "my-org" -Name "old-workspace"
```

---

## Remove-TfcWorkspaceRunTask

**Synopsis:** Removes a run task from a workspace

**Description:** Detaches a run task from a workspace

**Parameters:**

- **WorkspaceTaskId** (string): The workspace task ID to remove

**Examples:**

```powershell
Remove-TfcWorkspaceRunTask -WorkspaceTaskId "wstask-abc123"
```

---

## Remove-TfcWorkspaceSafely

**Synopsis:** Safely removes a workspace after verifying it has no managed resources

**Description:** Deletes a workspace only after confirming it has no managed resources in state. This prevents accidental deletion of workspaces managing active infrastructure.

**Parameters:**

- **Organization** (string): The name of the organization
- **WorkspaceName** (string): The name of the workspace to delete
- **Force** (switch): Skip resource count check and force deletion

**Examples:**

```powershell
Remove-TfcWorkspaceSafely -Organization "my-org" -WorkspaceName "test-workspace"
```

```powershell
Remove-TfcWorkspaceSafely -Organization "my-org" -WorkspaceName "test-workspace" -Force
```

---

## Remove-TfcWorkspaceTeamAccess

**Synopsis:** Removes team access from a workspace

**Description:** Revokes a team's access to a workspace

**Parameters:**

- **TeamWorkspaceId** (string): The team workspace relationship ID to remove

**Examples:**

```powershell
Remove-TfcWorkspaceTeamAccess -TeamWorkspaceId "tws-abc123"
```

---

## Remove-TfcWorkspaceVariable

**Synopsis:** Removes a variable from a workspace

**Description:** Deletes a variable from a Terraform Cloud workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **Key** (string): The variable name/key to remove

**Examples:**

```powershell
Remove-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "old_variable"
```

---

## Remove-TfcWorkspaceVCS

**Synopsis:** Removes VCS connection from a workspace

**Description:** Disconnects the VCS repository integration from a workspace

**Parameters:**

- **WorkspaceId** (string): The ID of the workspace to remove VCS connection from

**Examples:**

```powershell
Remove-TfcWorkspaceVCS -WorkspaceId "ws-123"
```

---

## Resume-TfcUser

**Synopsis:** Reactivate a suspended user account

**Description:** Reactivates a suspended user account in Terraform Cloud (requires admin access)

**Parameters:**

- **UserId** (string): The ID of the user to reactivate (format: user-xxxxx)

**Examples:**

```powershell
Resume-TfcUser -UserId user-abc123
```

---

## Revoke-TfcAdminPrivilege

**Synopsis:** Revoke admin privileges from a user

**Description:** Revokes site admin privileges from a user (requires admin access)

**Parameters:**

- **UserId** (string): The ID of the user (format: user-xxxxx)

**Examples:**

```powershell
Revoke-TfcAdminPrivilege -UserId user-abc123
```

---

## Revoke-TfcHYOKKeyVersion

**Synopsis:** Revokes a HYOK key version

**Description:** Revokes a specific HYOK customer key version, preventing it from being used for encryption

**Parameters:**

- **KeyVersionId** (string): The HYOK customer key version ID to revoke

**Examples:**

```powershell
Revoke-TfcHYOKKeyVersion -KeyVersionId "hyokkv-abc123"
```

---

## Revoke-TfcSAMLSettings

**Synopsis:** Revoke SAML settings for an organization

**Description:** Disables and removes SAML SSO configuration for an organization (requires admin access)

**Parameters:**

- **OrganizationName** (string): The name of the organization

**Examples:**

```powershell
Revoke-TfcSAMLSettings -OrganizationName my-org
```

---

## Save-TfcConfigurationVersion

**Synopsis:** Downloads a configuration version

**Description:** Downloads the configuration files for a configuration version and saves them to disk

**Parameters:**

- **ConfigurationVersionId** (string): The configuration version ID
- **OutputPath** (string): The path where the configuration tarball will be saved

**Examples:**

```powershell
Save-TfcConfigurationVersion -ConfigurationVersionId "cv-abc123" -OutputPath "./config.tar.gz"
```

---

## Save-TfcPlanExport

**Synopsis:** Downloads a plan export

**Description:** Downloads the exported plan data for a specific plan export

**Parameters:**

- **PlanExportId** (string): The plan export ID
- **OutputPath** (string): The file path to save the downloaded export

**Examples:**

```powershell
Save-TfcPlanExport -PlanExportId "pe-abc123" -OutputPath "./plan-export.tar.gz"
```

---

## Set-TfcPolicyCheckOverride

**Synopsis:** Overrides a policy check

**Description:** Overrides a soft-mandatory or advisory policy check to allow a run to proceed

**Parameters:**

- **PolicyCheckId** (string): The policy check ID to override

**Examples:**

```powershell
Set-TfcPolicyCheckOverride -PolicyCheckId "polchk-123"
```

---

## Set-TfcPolicySetProject

**Synopsis:** Sets project targeting for a policy set

**Description:** Attaches a policy set to specific projects

**Parameters:**

- **PolicySetId** (string): The policy set ID
- **ProjectIds** (string[]): Array of project IDs to target

**Examples:**

```powershell
Set-TfcPolicySetProject -PolicySetId "polset-123" -ProjectIds @("prj-1", "prj-2")
```

---

## Set-TfcPolicySetWorkspace

**Synopsis:** Sets workspace targeting for a policy set

**Description:** Attaches a policy set to specific workspaces

**Parameters:**

- **PolicySetId** (string): The policy set ID
- **WorkspaceIds** (string[]): Array of workspace IDs to target

**Examples:**

```powershell
Set-TfcPolicySetWorkspace -PolicySetId "polset-123" -WorkspaceIds @("ws-1", "ws-2")
```

---

## Set-TfcProjectTagBinding

**Synopsis:** Sets tag bindings for a project

**Description:** Creates or updates tag bindings for a project. Each tag binding is a key-value pair.

**Parameters:**

- **ProjectId** (string): The project ID
- **TagBindings** (hashtable[]): Array of hashtables with 'key' and 'value' properties representing tag bindings

**Examples:**

```powershell
Set-TfcProjectTagBinding -ProjectId "prj-abc123" -TagBindings @(@{key="env"; value="production"}, @{key="team"; value="platform"})
```

---

## Set-TfcVariableSetProject

**Synopsis:** Assigns a variable set to project(s)

**Description:** Adds a variable set to one or more projects

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **ProjectIds** (string[]): Array of project IDs to assign the variable set to

**Examples:**

```powershell
Set-TfcVariableSetProject -VariableSetId "varset-abc123" -ProjectIds @("prj-123", "prj-456")
```

---

## Set-TfcVariableSetStack

**Synopsis:** Assigns a variable set to stack(s)

**Description:** Adds a variable set to one or more stacks

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **StackIds** (string[]): Array of stack IDs to assign the variable set to

**Examples:**

```powershell
Set-TfcVariableSetStack -VariableSetId "varset-abc123" -StackIds @("stack-123", "stack-456")
```

---

## Set-TfcVariableSetWorkspace

**Synopsis:** Assigns a variable set to workspace(s)

**Description:** Adds a variable set to one or more workspaces

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **WorkspaceIds** (string[]): Array of workspace IDs to assign the variable set to

**Examples:**

```powershell
Set-TfcVariableSetWorkspace -VariableSetId "varset-abc123" -WorkspaceIds @("ws-123", "ws-456")
```

---

## Set-TfcWorkspaceSSHKey

**Synopsis:** Assigns an SSH key to a workspace

**Description:** Associates an SSH key with a workspace for VCS repository access

**Parameters:**

- **Organization** (string): The organization name
- **WorkspaceName** (string): The workspace name
- **SSHKeyId** (string): The SSH key ID to assign

**Examples:**

```powershell
Set-TfcWorkspaceSSHKey -Organization "my-org" -WorkspaceName "my-workspace" -SSHKeyId "sshkey-abc123"
```

---

## Set-TfcWorkspaceTag

**Synopsis:** Sets tags on a workspace

**Description:** Adds or replaces tags on a workspace

**Parameters:**

- **Organization** (string): The organization name
- **Workspace** (string): The workspace name
- **Tags** (string[]): Array of tag names to apply
- **Replace** (switch): If specified, replaces all existing tags. Otherwise, adds to existing tags.

**Examples:**

```powershell
Set-TfcWorkspaceTag -Organization "my-org" -Workspace "my-workspace" -Tags @("environment:prod", "team:platform")
```

```powershell
Set-TfcWorkspaceTag -Organization "my-org" -Workspace "my-workspace" -Tags @("new-tag") -Replace
```

---

## Set-TfcWorkspaceVariable

**Synopsis:** Sets a variable in a workspace

**Description:** Creates or updates a variable in a Terraform Cloud workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **Key** (string): The variable name/key
- **Value** (string): The variable value
- **Category** (string): The variable category (terraform or env)
- **HCL** (switch): Whether the variable should be parsed as HCL
- **Sensitive** (switch): Whether the variable is sensitive
- **Description** (string): Optional description for the variable

**Examples:**

```powershell
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-east-1" -Category "terraform"
```

```powershell
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "API_KEY" -Value "secret" -Category "env" -Sensitive
```

---

## Show-TfcPolicySet

**Synopsis:** Shows a policy set with all relationships

**Description:** Retrieves a policy set with included relationships (policies, workspaces, projects, etc.)

**Parameters:**

- **PolicySetId** (string): The ID of the policy set to retrieve
- **Include** (string): Comma-separated list of relationships to include. Options: policies, workspaces, projects, newest-version, current-run, organization

**Examples:**

```powershell
Show-TfcPolicySet -PolicySetId "polset-123"
```

```powershell
Show-TfcPolicySet -PolicySetId "polset-123" -Include "policies,workspaces,projects"
```

---

## Show-TfcRun

**Synopsis:** Shows detailed run information with relationships

**Description:** Retrieves detailed information about a run including optional relationships

**Parameters:**

- **RunId** (string): The ID of the run
- **Include** (string[]): Optional array of relationships to include (plan, apply, workspace, configuration-version, etc.)

**Examples:**

```powershell
Show-TfcRun -RunId "run-123"
```

```powershell
Show-TfcRun -RunId "run-123" -Include @('plan', 'apply', 'workspace')
```

---

## Show-TfcRunTrigger

**Synopsis:** Shows a specific run trigger

**Description:** Retrieves details of a specific run trigger by ID

**Parameters:**

- **RunTriggerId** (string): The run trigger ID

**Examples:**

```powershell
Show-TfcRunTrigger -RunTriggerId "rt-abc123"
```

---

## Show-TfcTeamToken

**Synopsis:** Shows team token with details

**Description:** Retrieves detailed information about a team token

**Parameters:**

- **TeamId** (string): The ID of the team

**Examples:**

```powershell
Show-TfcTeamToken -TeamId "team-123"
```

---

## Show-TfcWorkspace

**Synopsis:** Shows detailed workspace information with relationships

**Description:** Retrieves detailed information about a workspace including optional relationships

**Parameters:**

- **Organization** (string): The name of the organization
- **WorkspaceName** (string): The name of the workspace
- **Include** (string[]): Optional array of relationships to include (current-run, outputs, remote-state-consumers, etc.)

**Examples:**

```powershell
Show-TfcWorkspace -Organization "my-org" -WorkspaceName "my-workspace"
```

```powershell
Show-TfcWorkspace -Organization "my-org" -WorkspaceName "my-workspace" -Include @('current-run', 'outputs')
```

---

## Show-TfcWorkspaceTeamAccess

**Synopsis:** Shows team workspace access details

**Description:** Retrieves detailed information about a team's access to a workspace

**Parameters:**

- **TeamWorkspaceId** (string): The team workspace relationship ID

**Examples:**

```powershell
Show-TfcWorkspaceTeamAccess -TeamWorkspaceId "tws-abc123"
```

---

## Stop-TfcChangeRequest

**Synopsis:** Cancels a change request

**Description:** Cancels a specific change request

**Parameters:**

- **ChangeRequestId** (string): The change request ID to cancel

**Examples:**

```powershell
Stop-TfcChangeRequest -ChangeRequestId "cr-abc123"
```

---

## Stop-TfcRegistryModuleTestRun

**Synopsis:** Cancels a registry module test run

**Description:** Cancels a running test run for a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name
- **TestRunId** (string): The test run ID to cancel

**Examples:**

```powershell
Stop-TfcRegistryModuleTestRun -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -TestRunId "modtestrun-abc123"
```

---

## Stop-TfcRegistryModuleTestRunForce

**Synopsis:** Force cancels a registry module test run

**Description:** Force cancels a running test run for a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name
- **TestRunId** (string): The test run ID to force cancel

**Examples:**

```powershell
Stop-TfcRegistryModuleTestRunForce -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -TestRunId "modtestrun-abc123"
```

---

## Stop-TfcRun

**Synopsis:** Cancels a run

**Description:** Cancels a run that is in progress

**Parameters:**

- **RunId** (string): The run ID to cancel
- **Comment** (string): Optional comment for the cancel action

**Examples:**

```powershell
Stop-TfcRun -RunId "run-123" -Comment "Cancelling due to emergency"
```

---

## Stop-TfcRunForce

**Synopsis:** Force cancels a run

**Description:** Forcefully cancels a run that is stuck or not responding to normal cancel

**Parameters:**

- **RunId** (string): The run ID to force cancel
- **Comment** (string): Optional comment explaining the force cancel

**Examples:**

```powershell
Stop-TfcRunForce -RunId "run-abc123" -Comment "Stuck run requiring force cancel"
```

---

## Stop-TfcRunWithComment

**Synopsis:** Cancels a run with a comment

**Description:** Cancels a run and optionally provides a comment explaining why

**Parameters:**

- **RunId** (string): The ID of the run to cancel
- **Comment** (string): Optional comment explaining the cancellation reason

**Examples:**

```powershell
Stop-TfcRunWithComment -RunId "run-123" -Comment "Cancelling due to incorrect configuration"
```

```powershell
Stop-TfcRunWithComment -RunId "run-123"
```

---

## Stop-TfcStackDeployment

**Synopsis:** Cancel a stack deployment

**Description:** Cancels a running stack deployment

**Parameters:**

- **DeploymentId** (string): The ID of the deployment to cancel

**Examples:**

```powershell
Stop-TfcStackDeployment -DeploymentId "sd-123"
```

---

## Stop-TfcUserImpersonation

**Synopsis:** Stops user impersonation

**Description:** Ends the current admin user impersonation session (Terraform Enterprise only)

**Examples:**

```powershell
Stop-TfcUserImpersonation
```

---

## Suspend-TfcUser

**Synopsis:** Suspend a user account

**Description:** Suspends a user account in Terraform Cloud (requires admin access)

**Parameters:**

- **UserId** (string): The ID of the user to suspend (format: user-xxxxx)

**Examples:**

```powershell
Suspend-TfcUser -UserId user-abc123
```

---

## Test-TfcHYOKConfiguration

**Synopsis:** Tests an existing HYOK configuration

**Description:** Tests connectivity for an existing Hold Your Own Key (HYOK) configuration

**Parameters:**

- **ConfigurationId** (string): The ID of the HYOK configuration to test

**Examples:**

```powershell
Test-TfcHYOKConfiguration -ConfigurationId "hyokc-abc123"
```

---

## Test-TfcHYOKConfigurationNew

**Synopsis:** Tests an unpersisted HYOK configuration

**Description:** Tests connectivity for a Hold Your Own Key (HYOK) configuration before saving it. This allows validating the configuration parameters without creating the resource.

**Parameters:**

- **Organization** (string): The name of the organization
- **KeyProviderId** (string): The ID of the key provider
- **KeyName** (string): The name of the encryption key
- **KeyVersion** (string): The version of the encryption key (optional)

**Examples:**

```powershell
Test-TfcHYOKConfigurationNew -Organization "my-org" -KeyProviderId "kp-abc123" -KeyName "my-key"
```

```powershell
Test-TfcHYOKConfigurationNew -Organization "my-org" -KeyProviderId "kp-abc123" -KeyName "my-key" -KeyVersion "1"
```

---

## Test-TfcNotificationConfiguration

**Synopsis:** Verifies a notification configuration

**Description:** Sends a test notification to verify the configuration

**Parameters:**

- **NotificationConfigurationId** (string): The notification configuration ID to verify

**Examples:**

```powershell
Test-TfcNotificationConfiguration -NotificationConfigurationId "nc-abc123"
```

---

## Test-TfcStack

**Synopsis:** Validate a stack

**Description:** Validates the configuration of a stack

**Parameters:**

- **StackId** (string): The ID of the stack

**Examples:**

```powershell
Test-TfcStack -StackId "stack-123"
```

---

## Test-TfcWorkspaceId

**Synopsis:** Tests if a workspace ID is valid

**Description:** Validates the format of a Terraform Cloud workspace ID

**Parameters:**

- **WorkspaceId** (string): The workspace ID to validate

**Examples:**

```powershell
Test-TfcWorkspaceId -WorkspaceId "ws-1234567890abcdef"
```

---

## Unlock-TfcStateVersion

**Synopsis:** Unlocks a state version

**Description:** Unlocks a state version to allow modifications

**Parameters:**

- **StateVersionId** (string): The ID of the state version to unlock

**Examples:**

```powershell
Unlock-TfcStateVersion -StateVersionId "sv-123"
```

---

## Unlock-TfcWorkspace

**Synopsis:** Unlocks a workspace

**Description:** Unlocks a workspace to allow runs

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The workspace name

**Examples:**

```powershell
Unlock-TfcWorkspace -Organization "my-org" -Name "my-workspace"
```

---

## Update-TfcAccount

**Synopsis:** Updates the current user account

**Description:** Updates account details for the currently authenticated user

**Parameters:**

- **Username** (string): New username
- **Email** (string): New email address

**Examples:**

```powershell
Update-TfcAccount -Username "newusername" -Email "new@example.com"
```

---

## Update-TfcAccountPassword

**Synopsis:** Updates the current user's password

**Description:** Changes the password for the currently authenticated user

**Parameters:**

- **CurrentPassword** (securestring): The current password
- **NewPassword** (securestring): The new password
- **NewPasswordConfirmation** (securestring): Confirmation of the new password

**Examples:**

```powershell
Update-TfcAccountPassword -CurrentPassword (ConvertTo-SecureString "old" -AsPlainText -Force) -NewPassword (ConvertTo-SecureString "new" -AsPlainText -Force) -NewPasswordConfirmation (ConvertTo-SecureString "new" -AsPlainText -Force)
```

---

## Update-TfcAdminSettings

**Synopsis:** Update admin organization settings

**Description:** Updates administrative settings for Terraform Cloud (requires admin access)

**Parameters:**

- **EnablePolicyEnforcement** (bool): Enable or disable policy enforcement globally
- **EnableCostEstimation** (bool): Enable or disable cost estimation globally

**Examples:**

```powershell
Update-TfcAdminSettings -EnablePolicyEnforcement $true
```

---

## Update-TfcAgentPool

**Synopsis:** Updates an agent pool

**Description:** Updates an existing agent pool

**Parameters:**

- **AgentPoolId** (string): The agent pool ID
- **Name** (string): New name for the pool
- **OrganizationScoped** (bool): Whether the pool is available to all workspaces

**Examples:**

```powershell
Update-TfcAgentPool -AgentPoolId "apool-abc123" -Name "new-name"
```

---

## Update-TfcChangeRequest

**Synopsis:** Updates a change request

**Description:** Updates a specific change request

**Parameters:**

- **ChangeRequestId** (string): The change request ID
- **Status** (string): The new status for the change request
- **Message** (string): An optional message for the change request update

**Examples:**

```powershell
Update-TfcChangeRequest -ChangeRequestId "cr-abc123" -Status "approved"
```

---

## Update-TfcGPGKey

**Synopsis:** Updates a GPG key

**Description:** Updates the namespace of an existing GPG key

**Parameters:**

- **RegistryName** (string): The registry name (e.g., "private")
- **Namespace** (string): The current namespace (organization name)
- **KeyId** (string): The GPG key ID
- **NewNamespace** (string): The new namespace to assign to the key

**Examples:**

```powershell
Update-TfcGPGKey -RegistryName "private" -Namespace "my-org" -KeyId "12345" -NewNamespace "new-org"
```

---

## Update-TfcNoCodeModule

**Synopsis:** Update a no-code module

**Description:** Updates a no-code module's configuration

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module (format: ncm-xxxxx)
- **Enabled** (bool): Whether the module is enabled for use
- **VersionPin** (string): Pin to a specific module version

**Examples:**

```powershell
Update-TfcNoCodeModule -NoCodeModuleId ncm-abc123 -Enabled $false
```

---

## Update-TfcNoCodeModuleVariableOptions

**Synopsis:** Update no-code module variable options

**Description:** Upgrades the variable options for a no-code module

**Parameters:**

- **NoCodeModuleId** (string): The ID of the no-code module (format: ncm-xxxxx)

**Examples:**

```powershell
Update-TfcNoCodeModuleVariableOptions -NoCodeModuleId ncm-abc123
```

---

## Update-TfcNotificationConfiguration

**Synopsis:** Updates a notification configuration

**Description:** Updates an existing notification configuration

**Parameters:**

- **NotificationConfigurationId** (string): The notification configuration ID
- **Name** (string): New name
- **Url** (string): New URL
- **Enabled** (bool): Whether enabled
- **Triggers** (string[]): New triggers array

**Examples:**

```powershell
Update-TfcNotificationConfiguration -NotificationConfigurationId "nc-abc123" -Enabled $false
```

---

## Update-TfcOAuthClient

**Synopsis:** Updates an OAuth client

**Description:** Updates an existing OAuth client configuration in Terraform Cloud

**Parameters:**

- **OAuthClientId** (string): The ID of the OAuth client to update
- **Name** (string): New display name for the OAuth client
- **Key** (string): New OAuth application key/client ID
- **Secret** (string): New OAuth application secret

**Examples:**

```powershell
Update-TfcOAuthClient -OAuthClientId "oc-123" -Name "Updated GitHub Connection"
```

```powershell
Update-TfcOAuthClient -OAuthClientId "oc-123" -Key "new-key" -Secret "new-secret"
```

---

## Update-TfcOAuthToken

**Synopsis:** Update an OAuth token

**Description:** Updates an OAuth token's SSH key

**Parameters:**

- **OAuthTokenId** (string): The ID of the OAuth token (format: ot-xxxxx)
- **SSHKeyId** (string): The ID of the SSH key to associate (format: sshkey-xxxxx)

**Examples:**

```powershell
Update-TfcOAuthToken -OAuthTokenId ot-abc123 -SSHKeyId sshkey-xyz789
```

---

## Update-TfcOrganization

**Synopsis:** Updates an existing organization

**Description:** Updates properties of an existing organization

**Parameters:**

- **Organization** (string): The organization name
- **Email** (string): New admin email address (optional)
- **SessionTimeout** (int): New session timeout in minutes (optional)
- **SessionRemember** (int): New session remember duration in minutes (optional)
- **CollaboratorAuthPolicy** (string): New authentication policy (optional)

**Examples:**

```powershell
Update-TfcOrganization -Organization "my-org" -Email "newemail@example.com"
```

---

## Update-TfcOrganizationEntitlement

**Synopsis:** Updates organization entitlements

**Description:** Updates the entitlements/features enabled for an organization (admin only)

**Parameters:**

- **Organization** (string): The name of the organization
- **Entitlements** (hashtable): Hashtable of entitlements to update (cost-estimation, sentinel, state-storage, etc.)

**Examples:**

```powershell
Update-TfcOrganizationEntitlement -Organization "my-org" -Entitlements @{ "cost-estimation" = $true; "sentinel" = $true }
```

---

## Update-TfcPolicy

**Synopsis:** Updates an existing policy

**Description:** Updates a Sentinel or OPA policy's metadata or enforcement level

**Parameters:**

- **PolicyId** (string): The policy ID
- **Name** (string): Optional new policy name
- **Description** (string): Optional new description
- **EnforcementLevel** (string): Optional new enforcement level

**Examples:**

```powershell
Update-TfcPolicy -PolicyId "pol-123" -EnforcementLevel "hard-mandatory"
```

---

## Update-TfcPolicySet

**Synopsis:** Updates an existing policy set

**Description:** Updates a policy set's metadata or targeting

**Parameters:**

- **PolicySetId** (string): The policy set ID
- **Name** (string): Optional new name
- **Description** (string): Optional new description
- **Global** (bool): Optional global setting
- **Overridable** (bool): Optional overridable setting

**Examples:**

```powershell
Update-TfcPolicySet -PolicySetId "polset-123" -Global
```

---

## Update-TfcPolicySetParameter

**Synopsis:** Updates a policy set parameter

**Description:** Updates an existing parameter for a policy set in Terraform Cloud

**Parameters:**

- **ParameterId** (string): The ID of the parameter to update
- **Key** (string): The new parameter key/name
- **Value** (string): The new parameter value
- **Sensitive** (switch): Whether the parameter value is sensitive

**Examples:**

```powershell
Update-TfcPolicySetParameter -ParameterId "param-123" -Value "new-value"
```

```powershell
Update-TfcPolicySetParameter -ParameterId "param-123" -Key "new-key" -Value "new-value" -Sensitive
```

---

## Update-TfcProject

**Synopsis:** Updates a project

**Description:** Updates an existing project in Terraform Cloud

**Parameters:**

- **ProjectId** (string): The project ID
- **Name** (string): New name for the project
- **Description** (string): New description for the project

**Examples:**

```powershell
Update-TfcProject -ProjectId "prj-123" -Name "new-name" -Description "Updated description"
```

---

## Update-TfcProjectTeamAccess

**Synopsis:** Updates team access for a project

**Description:** Updates the access level and custom permissions for a team's access to a project

**Parameters:**

- **TeamProjectId** (string): The team project relationship ID
- **Access** (string): Access level ('read', 'maintain', 'admin', or 'write')
- **RunsAccess** (string): Custom permission for runs ('read', 'write', 'apply', or 'none')
- **VariablesAccess** (string): Custom permission for variables ('read', 'write', or 'none')
- **StateVersionsAccess** (string): Custom permission for state versions ('read', 'write', or 'none')
- **SentinelMocksAccess** (string): Custom permission for sentinel mocks ('read', 'write', or 'none')
- **WorkspaceLockingAccess** (string): Custom permission for workspace locking ('read', 'write', or 'none')

**Examples:**

```powershell
Update-TfcProjectTeamAccess -TeamProjectId "tprj-abc123" -Access "write"
```

---

## Update-TfcRegistryModule

**Synopsis:** Updates a private registry module

**Description:** Updates settings for a private registry module, including VCS repository and test configuration

**Parameters:**

- **Organization** (string): The organization name
- **Namespace** (string): The namespace of the module
- **Name** (string): The name of the module
- **Provider** (string): The provider name
- **VcsRepo** (hashtable): Optional hashtable for VCS repository settings (e.g., @{identifier="org/repo"; branch="main"})
- **TestConfig** (hashtable): Optional hashtable for test configuration (e.g., @{tests-enabled=$true})

**Examples:**

```powershell
Update-TfcRegistryModule -Organization "my-org" -Namespace "my-org" -Name "vpc" -Provider "aws" -VcsRepo @{identifier="my-org/terraform-aws-vpc"; branch="main"}
```

```powershell
Update-TfcRegistryModule -Organization "my-org" -Namespace "my-org" -Name "vpc" -Provider "aws" -TestConfig @{"tests-enabled"=$true}
```

---

## Update-TfcRegistryModuleTestVariable

**Synopsis:** Updates a test variable for a registry module

**Description:** Updates an existing variable for testing a private registry module

**Parameters:**

- **Organization** (string): The organization name
- **ModuleName** (string): The module name
- **ProviderName** (string): The provider name
- **VariableId** (string): The variable ID to update
- **Key** (string): The variable key name
- **Value** (string): The variable value

**Examples:**

```powershell
Update-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -VariableId "var-abc123" -Value "us-west-2"
```

---

## Update-TfcRegistrySettings

**Synopsis:** Update registry settings for an organization

**Description:** Updates private registry settings for an organization

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **ModuleConsumersEnabled** (bool): Allow other organizations to consume modules
- **ProviderConsumersEnabled** (bool): Allow other organizations to consume providers

**Examples:**

```powershell
Update-TfcRegistrySettings -OrganizationName my-org -ModuleConsumersEnabled $true
```

---

## Update-TfcRegistryWebhook

**Synopsis:** Update a registry webhook

**Description:** Updates an existing registry webhook

**Parameters:**

- **WebhookId** (string): The ID of the webhook
- **Url** (string): New webhook URL
- **Events** (string[]): New array of events
- **Enabled** (bool): Whether the webhook is enabled

**Examples:**

```powershell
Update-TfcRegistryWebhook -WebhookId "webhook-123" -Enabled $false
```

---

## Update-TfcReservedTagKey

**Synopsis:** Updates a reserved tag key

**Description:** Updates a specific reserved tag key

**Parameters:**

- **ReservedTagId** (string): The reserved tag ID
- **Key** (string): The new key name

**Examples:**

```powershell
Update-TfcReservedTagKey -ReservedTagId "rtag-abc123" -Key "new-key-name"
```

---

## Update-TfcRunTask

**Synopsis:** Updates a run task

**Description:** Updates an existing run task

**Parameters:**

- **RunTaskId** (string): The run task ID
- **Name** (string): New name for the task
- **Url** (string): New URL for the task
- **HmacKey** (string): New HMAC key
- **Enabled** (bool): Whether the task is enabled
- **Description** (string): New description

**Examples:**

```powershell
Update-TfcRunTask -RunTaskId "task-abc123" -Enabled $false
```

---

## Update-TfcSAMLSettings

**Synopsis:** Update SAML settings for an organization

**Description:** Updates SAML SSO configuration for an organization (requires admin access)

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **SSOEndpoint** (string): The SSO endpoint URL
- **SLOEndpoint** (string): The single logout endpoint URL
- **Certificate** (string): The X.509 certificate for SAML
- **Enabled** (bool): Whether SAML is enabled

**Examples:**

```powershell
Update-TfcSAMLSettings -OrganizationName my-org -Enabled $true -SSOEndpoint "https://idp.example.com/sso"
```

---

## Update-TfcSSHKey

**Synopsis:** Updates an SSH key

**Description:** Updates the name of an existing SSH key

**Parameters:**

- **SSHKeyId** (string): The SSH key ID
- **Name** (string): New name for the key

**Examples:**

```powershell
Update-TfcSSHKey -SSHKeyId "sshkey-abc123" -Name "Updated Key Name"
```

---

## Update-TfcStack

**Synopsis:** Update an existing stack

**Description:** Updates the configuration of an existing stack

**Parameters:**

- **StackId** (string): The ID of the stack
- **Name** (string): New name for the stack
- **Description** (string): New description for the stack

**Examples:**

```powershell
Update-TfcStack -StackId "stack-123" -Description "Updated production stack"
```

---

## Update-TfcStackConfiguration

**Synopsis:** Update stack configuration

**Description:** Updates the configuration for a stack

**Parameters:**

- **StackId** (string): The ID of the stack
- **ConfigurationData** (hashtable): The configuration data as a hashtable

**Examples:**

```powershell
Update-TfcStackConfiguration -StackId "stack-123" -ConfigurationData @{key="value"}
```

---

## Update-TfcTeam

**Synopsis:** Updates an existing team

**Description:** Updates properties of an existing team

**Parameters:**

- **TeamId** (string): The team ID
- **Name** (string): New name for the team (optional)
- **Visibility** (string): New visibility setting (optional): 'secret', 'organization'
- **OrganizationAccess** (hashtable): Updated organization-level permissions (optional)

**Examples:**

```powershell
Update-TfcTeam -TeamId "team-abc123" -Name "new-name"
```

```powershell
Update-TfcTeam -TeamId "team-abc123" -OrganizationAccess @{ "manage-policies" = $true }
```

---

## Update-TfcTwoFactorSettings

**Synopsis:** Update two-factor authentication settings

**Description:** Updates 2FA requirements for an organization

**Parameters:**

- **OrganizationName** (string): The name of the organization
- **Required** (bool): Whether 2FA is required for all members

**Examples:**

```powershell
Update-TfcTwoFactorSettings -OrganizationName my-org -Required $true
```

---

## Update-TfcVariableSet

**Synopsis:** Updates an existing variable set

**Description:** Updates properties of an existing variable set

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **Name** (string): New name for the variable set (optional)
- **Description** (string): New description for the variable set (optional)
- **Global** (bool): Whether this variable set should be applied to all workspaces (optional)
- **Priority** (bool): Whether variable set variables override workspace variables (optional)

**Examples:**

```powershell
Update-TfcVariableSet -VariableSetId "varset-abc123" -Name "new-name"
```

```powershell
Update-TfcVariableSet -VariableSetId "varset-abc123" -Global:$false
```

---

## Update-TfcVariableSetVariable

**Synopsis:** Updates a variable in a variable set

**Description:** Updates an existing variable within a variable set

**Parameters:**

- **VariableSetId** (string): The variable set ID
- **VariableId** (string): The variable ID to update
- **Key** (string): The new variable name/key
- **Value** (string): The new variable value
- **Description** (string): The new description
- **Category** (string): The variable category ('terraform' or 'env')
- **Sensitive** (bool): Whether the variable is sensitive
- **HCL** (bool): Whether the variable should be parsed as HCL

**Examples:**

```powershell
Update-TfcVariableSetVariable -VariableSetId "varset-abc123" -VariableId "var-xyz789" -Value "new-value"
```

---

## Update-TfcWorkspace

**Synopsis:** Updates a workspace

**Description:** Updates an existing workspace in Terraform Cloud

**Parameters:**

- **Organization** (string): The organization name
- **Name** (string): The workspace name
- **NewName** (string): New name for the workspace (optional)
- **TerraformVersion** (string): The Terraform version to use
- **WorkingDirectory** (string): The working directory for Terraform operations
- **Description** (string): Description for the workspace
- **AutoApply** (bool): Whether to automatically apply successful plans

**Examples:**

```powershell
Update-TfcWorkspace -Organization "my-org" -Name "my-workspace" -TerraformVersion "1.5.0"
```

---

## Update-TfcWorkspaceRunTask

**Synopsis:** Updates a workspace run task

**Description:** Updates the enforcement level or stage of a workspace run task

**Parameters:**

- **WorkspaceTaskId** (string): The workspace task ID
- **EnforcementLevel** (string): New enforcement level: 'advisory' or 'mandatory'
- **Stage** (string): New stage: 'pre_plan', 'post_plan', 'pre_apply', or 'post_apply'

**Examples:**

```powershell
Update-TfcWorkspaceRunTask -WorkspaceTaskId "wstask-abc123" -EnforcementLevel "advisory"
```

---

## Update-TfcWorkspaceTeamAccess

**Synopsis:** Updates team access to a workspace

**Description:** Updates permissions for a team's access to a workspace

**Parameters:**

- **TeamWorkspaceId** (string): The team workspace relationship ID
- **Access** (string): New access level
- **Runs** (string): Custom permission for runs
- **Variables** (string): Custom permission for variables
- **StateVersions** (string): Custom permission for state
- **SentinelMocks** (string): Custom permission for sentinel mocks
- **WorkspaceLocking** (bool): Custom permission for locking
- **RunTasks** (bool): Custom permission for run tasks

**Examples:**

```powershell
Update-TfcWorkspaceTeamAccess -TeamWorkspaceId "tws-abc123" -Access "plan"
```

---

## Update-TfcWorkspaceVariable

**Synopsis:** Updates a variable in a workspace

**Description:** Updates an existing variable in a Terraform Cloud workspace

**Parameters:**

- **WorkspaceId** (string): The workspace ID
- **Key** (string): The variable name/key to update
- **Value** (string): The new variable value
- **Category** (string): The variable category (terraform or env)
- **HCL** (switch): Whether the variable should be parsed as HCL
- **Sensitive** (switch): Whether the variable is sensitive
- **Description** (string): Optional description for the variable

**Examples:**

```powershell
Update-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-west-2" -Category "terraform"
```

---
