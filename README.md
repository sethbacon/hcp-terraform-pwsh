# HCP Terraform PowerShell Module

[![PSGallery Version](https://img.shields.io/powershellgallery/v/TerraformCloud)](https://www.powershellgallery.com/packages/TerraformCloud)
[![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/TerraformCloud)](https://www.powershellgallery.com/packages/TerraformCloud)
[![CI](https://github.com/sethbacon/hcp-terraform-pwsh/actions/workflows/ci.yml/badge.svg)](https://github.com/sethbacon/hcp-terraform-pwsh/actions/workflows/ci.yml)

A comprehensive PowerShell module for the [Terraform Cloud / HCP Terraform API v2](https://developer.hashicorp.com/terraform/cloud-docs/api-docs). Provides **358 exported functions** covering ~95% of documented API endpoints with full CRUD support for organizations, workspaces, variables, runs, state management, policies, teams, registry, stacks, and more.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Authentication](#authentication)
- [Available Functions](#available-functions)
- [Examples](#examples)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Installation

### From PowerShell Gallery

```powershell
Install-Module -Name TerraformCloud -Scope CurrentUser
```

### Manual Installation

1. Clone this repository
2. Build the module:

```powershell
./Build-Module.ps1 -SkipTests
```

3. Import the module:

```powershell
Import-Module ./Output/TerraformCloud/TerraformCloud.psd1
```

Or copy `Output/TerraformCloud/` to your PowerShell modules directory:

- Windows: `$env:USERPROFILE\Documents\PowerShell\Modules\TerraformCloud\`
- Linux/macOS: `~/.local/share/powershell/Modules/TerraformCloud/`

## Quick Start

```powershell
Import-Module TerraformCloud

# Set your Terraform Cloud token
$env:TFE_TOKEN = "your-terraform-cloud-token-here"

# Get your organizations
Get-TfcOrganization

# Get workspaces from an organization
Get-TfcWorkspace -Organization "my-org"

# Find a specific workspace
Find-TfcWorkspace -WorkspaceName "my-workspace" -Organization "my-org"
```

## Authentication

The module supports two authentication methods, checked in order:

### Environment Variable (Recommended)

```powershell
$env:TFE_TOKEN = "your-terraform-cloud-token-here"
```

### Terraform CLI Credentials File

The module automatically reads tokens from `~/.terraform.d/credentials.tfrc.json`:

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "your-terraform-cloud-token-here"
    }
  }
}
```

## Available Functions

**358 exported functions** organized across 30+ categories. Use `Get-Help <FunctionName> -Full` for detailed documentation on any function.

### Account & User Management (19)

`Get-TfcAccount`, `Get-TfcCurrentUser`, `Update-TfcAccount`, `Update-TfcAccountPassword`, `Get-TfcAdminUser`, `Suspend-TfcUser`, `Resume-TfcUser`, `Grant-TfcAdminPrivilege`, `Revoke-TfcAdminPrivilege`, `Disable-TfcUserTwoFactor`, `New-TfcUserImpersonation`, `Stop-TfcUserImpersonation`, `Get-TfcUserToken`, `New-TfcUserToken`, `Remove-TfcUserToken`, `Remove-TfcUser`, `Get-TfcUserMembership`, `Get-TfcSubscription`, `Get-TfcIPRange`

### Organizations (22)

`Get-TfcOrganization`, `New-TfcOrganization`, `Update-TfcOrganization`, `Remove-TfcOrganization`, `Get-TfcOrganizationEntitlements`, `Update-TfcOrganizationEntitlement`, `Get-TfcOrganizationMembership`, `Get-TfcOrganizationMembershipDetails`, `Invoke-TfcOrganizationMembershipInvite`, `Remove-TfcOrganizationMembership`, `New-TfcOrganizationToken`, `Remove-TfcOrganizationToken`, `Get-TfcOrganizationTag`, `New-TfcOrganizationTag`, `Remove-TfcOrganizationTag`, `Add-TfcOrganizationTagRelationship`, `Remove-TfcOrganizationTagRelationship`, `Add-TfcTagWorkspace`, `Get-TfcOrganizationTeamToken`, `Get-TfcOrganizationModuleProducer`, `Get-TfcReservedTagKey`, `New-TfcReservedTagKey`, `Remove-TfcReservedTagKey`, `Update-TfcReservedTagKey`

### Workspaces (19)

`Get-TfcWorkspace`, `Show-TfcWorkspace`, `New-TfcWorkspace`, `Update-TfcWorkspace`, `Remove-TfcWorkspace`, `Remove-TfcWorkspaceSafely`, `Lock-TfcWorkspace`, `Unlock-TfcWorkspace`, `Invoke-TfcWorkspaceForceUnlock`, `Find-TfcWorkspace`, `Test-TfcWorkspaceId`, `Get-TfcWorkspaceTag`, `Set-TfcWorkspaceTag`, `Get-TfcWorkspaceResource`, `Get-TfcWorkspaceResourceDetails`, `Get-TfcWorkspaceReadme`, `Remove-TfcWorkspaceVCS`, `Set-TfcWorkspaceSSHKey`, `Move-TfcWorkspaceToProject`

### Projects (7)

`Get-TfcProject`, `New-TfcProject`, `Update-TfcProject`, `Remove-TfcProject`, `Get-TfcProjectTagBinding`, `Get-TfcProjectEffectiveTagBinding`, `Set-TfcProjectTagBinding`

### Variables & Variable Sets (22)

`Get-TfcWorkspaceVariable`, `Set-TfcWorkspaceVariable`, `Update-TfcWorkspaceVariable`, `Remove-TfcWorkspaceVariable`, `Get-TfcVariableSet`, `Get-TfcVariableSetDetails`, `New-TfcVariableSet`, `Update-TfcVariableSet`, `Remove-TfcVariableSet`, `Get-TfcVariableSetVariable`, `New-TfcVariableSetVariable`, `Update-TfcVariableSetVariable`, `Remove-TfcVariableSetVariable`, `Set-TfcVariableSetWorkspace`, `Remove-TfcVariableSetWorkspace`, `Set-TfcVariableSetProject`, `Remove-TfcVariableSetProject`, `Set-TfcVariableSetStack`, `Remove-TfcVariableSetStack`, `Get-TfcWorkspaceVariableSet`, `Get-TfcProjectVariableSet`, `Update-TfcNoCodeModuleVariableOptions`

### Runs (18)

`Get-TfcRun`, `Get-TfcRunDetails`, `Show-TfcRun`, `New-TfcRun`, `Confirm-TfcRun`, `Deny-TfcRun`, `Stop-TfcRun`, `Stop-TfcRunForce`, `Stop-TfcRunWithComment`, `Invoke-TfcRunForceExecute`, `Get-TfcRunEvent`, `Get-TfcRunPermission`, `Get-TfcRunTaskStage`, `Get-TfcOrganizationRun`, `Get-TfcRunTrigger`, `New-TfcRunTrigger`, `Remove-TfcRunTrigger`, `Show-TfcRunTrigger`

### Plans & Applies (10)

`Get-TfcPlan`, `Get-TfcPlanJson`, `Get-TfcPlanLog`, `Get-TfcPlanExport`, `New-TfcPlanExport`, `Remove-TfcPlanExport`, `Save-TfcPlanExport`, `Get-TfcApply`, `Get-TfcApplyLog`, `Get-TfcApplyErroredState`

### Configuration Versions (7)

`Get-TfcConfigurationVersionList`, `Get-TfcConfigurationVersion`, `Get-TfcConfigurationVersionIngressAttributes`, `New-TfcConfigurationVersion`, `Invoke-TfcConfigurationUpload`, `Invoke-TfcConfigurationVersionArchive`, `Save-TfcConfigurationVersion`

### State Management (10)

`Get-TfcCurrentStateVersion`, `Get-TfcStateVersion`, `New-TfcStateVersion`, `New-TfcStateVersionJson`, `Get-TfcStateVersionOutput`, `Get-TfcStateVersionOutputDetails`, `Get-TfcStateFile`, `Invoke-TfcStateRollback`, `Lock-TfcStateVersion`, `Unlock-TfcStateVersion`

### Teams & Access Control (22)

`Get-TfcTeam`, `Get-TfcTeamDetails`, `New-TfcTeam`, `Update-TfcTeam`, `Remove-TfcTeam`, `Get-TfcTeamAccess`, `Get-TfcTeamMember`, `Get-TfcTeamMemberDetails`, `Add-TfcTeamMember`, `Remove-TfcTeamMember`, `New-TfcTeamToken`, `Remove-TfcTeamToken`, `Show-TfcTeamToken`, `Add-TfcWorkspaceTeamAccess`, `Update-TfcWorkspaceTeamAccess`, `Remove-TfcWorkspaceTeamAccess`, `Show-TfcWorkspaceTeamAccess`, `Get-TfcProjectTeamAccess`, `Get-TfcProjectTeamAccessDetails`, `Add-TfcProjectTeamAccess`, `Update-TfcProjectTeamAccess`, `Remove-TfcProjectTeamAccess`

### Policy Management (27)

`Get-TfcPolicy`, `New-TfcPolicy`, `Update-TfcPolicy`, `Remove-TfcPolicy`, `Get-TfcPolicyContent`, `Invoke-TfcPolicyUpload`, `Get-TfcPolicySet`, `Show-TfcPolicySet`, `New-TfcPolicySet`, `Update-TfcPolicySet`, `Remove-TfcPolicySet`, `Add-TfcPolicySetPolicy`, `Remove-TfcPolicySetPolicy`, `Get-TfcPolicySetParameter`, `New-TfcPolicySetParameter`, `Update-TfcPolicySetParameter`, `Remove-TfcPolicySetParameter`, `Set-TfcPolicySetWorkspace`, `Remove-TfcPolicySetWorkspace`, `Set-TfcPolicySetProject`, `Remove-TfcPolicySetProject`, `Get-TfcPolicyCheck`, `Set-TfcPolicyCheckOverride`, `Get-TfcPolicyEvaluation`, `Get-TfcPolicyEvaluationDetails`, `Get-TfcPolicyEvaluationTask`, `Get-TfcPolicyEvaluationTaskDetails`, `Get-TfcPolicySetOutcome`, `Get-TfcPolicySetOutcomeDetails`

### Registry Modules (19)

`Get-TfcRegistryModule`, `New-TfcRegistryModule`, `Update-TfcRegistryModule`, `Remove-TfcRegistryModule`, `Find-TfcRegistryModule`, `Get-TfcRegistryModuleVersion`, `Get-TfcRegistryModuleVersionDetails`, `New-TfcRegistryModuleVersion`, `Remove-TfcRegistryModuleVersion`, `Invoke-TfcRegistryModuleVersionUpload`, `Publish-TfcRegistryModuleVersion`, `Get-TfcRegistryModuleDownloadUrl`, `Get-TfcRegistryModuleDependencies`, `Get-TfcRegistryModuleStats`, `Get-TfcRegistrySettings`, `Update-TfcRegistrySettings`, `Get-TfcRegistryWebhook`, `New-TfcRegistryWebhook`, `Update-TfcRegistryWebhook`, `Remove-TfcRegistryWebhook`

### Registry Providers (12)

`Get-TfcRegistryProvider`, `New-TfcRegistryProvider`, `Remove-TfcRegistryProvider`, `Find-TfcRegistryProvider`, `Get-TfcRegistryProviderVersion`, `Get-TfcRegistryProviderVersionDetails`, `New-TfcRegistryProviderVersion`, `Remove-TfcRegistryProviderVersion`, `Invoke-TfcRegistryProviderVersionUpload`, `Get-TfcRegistryProviderPlatform`, `New-TfcRegistryProviderPlatform`, `Remove-TfcRegistryProviderPlatform`, `Publish-TfcProviderVersion`

### Registry Module Tests (11)

`Get-TfcRegistryModuleTestRun`, `Get-TfcRegistryModuleTestRunDetails`, `New-TfcRegistryModuleTestRun`, `Stop-TfcRegistryModuleTestRun`, `Stop-TfcRegistryModuleTestRunForce`, `New-TfcRegistryModuleTestConfigVersion`, `Invoke-TfcRegistryModuleTestConfigUpload`, `Get-TfcRegistryModuleTestVariable`, `New-TfcRegistryModuleTestVariable`, `Update-TfcRegistryModuleTestVariable`, `Remove-TfcRegistryModuleTestVariable`

### Run Tasks (11)

`Get-TfcRunTask`, `Get-TfcRunTaskDetails`, `New-TfcRunTask`, `Update-TfcRunTask`, `Remove-TfcRunTask`, `Get-TfcWorkspaceRunTask`, `Add-TfcWorkspaceRunTask`, `Update-TfcWorkspaceRunTask`, `Remove-TfcWorkspaceRunTask`, `Get-TfcRunTaskResult`, `Get-TfcRunTaskResultDetails`

### Notification Configurations (5)

`Get-TfcNotificationConfiguration`, `New-TfcNotificationConfiguration`, `Update-TfcNotificationConfiguration`, `Remove-TfcNotificationConfiguration`, `Test-TfcNotificationConfiguration`

### Agent Pools & Agents (12)

`Get-TfcAgentPool`, `Get-TfcAgentPoolDetails`, `New-TfcAgentPool`, `Update-TfcAgentPool`, `Remove-TfcAgentPool`, `Get-TfcAgent`, `Get-TfcAgentDetails`, `Remove-TfcAgent`, `Get-TfcAgentToken`, `Get-TfcAgentTokenDetails`, `New-TfcAgentToken`, `Remove-TfcAgentToken`

### SSH Keys (5)

`Get-TfcSSHKey`, `New-TfcSSHKey`, `Update-TfcSSHKey`, `Remove-TfcSSHKey`, `Set-TfcWorkspaceSSHKey`

### OAuth & VCS (10)

`Get-TfcOAuthClient`, `Get-TfcOAuthClientDetails`, `Get-TfcOAuthClientOrganization`, `New-TfcOAuthClient`, `Update-TfcOAuthClient`, `Remove-TfcOAuthClient`, `Get-TfcOAuthToken`, `Get-TfcOAuthTokenDetails`, `Update-TfcOAuthToken`, `Remove-TfcOAuthToken`

### Stacks & Deployments (19)

`Get-TfcStack`, `Get-TfcStackDetails`, `New-TfcStack`, `Update-TfcStack`, `Remove-TfcStack`, `Test-TfcStack`, `Get-TfcStackConfiguration`, `Update-TfcStackConfiguration`, `Get-TfcStackDeployment`, `Get-TfcStackDeploymentDetails`, `Get-TfcStackDeploymentLog`, `New-TfcStackDeployment`, `Stop-TfcStackDeployment`, `Get-TfcStackOutput`, `Get-TfcStackResource`, `Get-TfcDriftDetection`, `Get-TfcDriftStatus`, `Enable-TfcDriftDetection`, `Disable-TfcDriftDetection`

### HYOK (Host Your Own Key) (11)

`Get-TfcHYOKConfiguration`, `Get-TfcHYOKConfigurationDetails`, `New-TfcHYOKConfiguration`, `Remove-TfcHYOKConfiguration`, `Test-TfcHYOKConfiguration`, `Test-TfcHYOKConfigurationNew`, `Get-TfcHYOKKeyVersion`, `Get-TfcHYOKKeyVersionDetails`, `Get-TfcHYOKKeyVersionRefresh`, `Revoke-TfcHYOKKeyVersion`, `Get-TfcHYOKEncryptedDataKey`

### Assessments & Drift Detection (5)

`Get-TfcAssessmentResult`, `Get-TfcAssessmentResultDetails`, `Get-TfcAssessmentResultJsonOutput`, `Get-TfcAssessmentResultJsonSchema`, `Get-TfcAssessmentResultLog`

### Change Requests (8)

`Get-TfcChangeRequest`, `Get-TfcChangeRequestDetails`, `Get-TfcChangeRequestComment`, `New-TfcChangeRequest`, `Approve-TfcChangeRequest`, `Deny-TfcChangeRequest`, `Stop-TfcChangeRequest`, `Update-TfcChangeRequest`

### No-Code Provisioning (8)

`Get-TfcNoCodeModule`, `New-TfcNoCodeModule`, `Update-TfcNoCodeModule`, `Remove-TfcNoCodeModule`, `New-TfcNoCodeWorkspace`, `Get-TfcNoCodeWorkspaceUpgrade`, `Invoke-TfcNoCodeWorkspaceUpgrade`, `Confirm-TfcNoCodeWorkspaceUpgrade`

### Cost Estimates (2)

`Get-TfcCostEstimate`, `Get-TfcCostEstimateLog`

### Comments (2)

`Get-TfcComment`, `New-TfcComment`

### Audit Trail (4)

`Get-TfcAuditTrail`, `Get-TfcAuditTrailToken`, `New-TfcAuditTrailToken`, `Remove-TfcAuditTrailToken`

### GPG Keys (5)

`Get-TfcGPGKey`, `Get-TfcGPGKeyDetails`, `New-TfcGPGKey`, `Update-TfcGPGKey`, `Remove-TfcGPGKey`

### Enterprise Admin (13)

`Get-TfcAdminSettings`, `Update-TfcAdminSettings`, `Get-TfcSAMLSettings`, `Update-TfcSAMLSettings`, `Revoke-TfcSAMLSettings`, `Get-TfcTwoFactorSettings`, `Update-TfcTwoFactorSettings`, `Get-TfcInvoice`, `Get-TfcInvoiceDetails`, `Get-TfcNextInvoice`, `Get-TfcOrganizationSubscription`, `Get-TfcFeatureSet`, `Get-TfcFeatureSetDetails`

### Additional (7)

`Get-TfcVCSEvent`, `Get-TfcVCSEventDetails`, `Get-TfcGitHubAppInstallation`, `Get-TfcGitHubAppInstallationDetails`, `Get-TfcGroupMemberRole`, `Get-TfcGroupMemberRoleDetails`, `Invoke-TfcExplorerQuery`

## Examples

### Working with Organizations

```powershell
# List all organizations
Get-TfcOrganization

# Get a specific organization
Get-TfcOrganization -Name "my-org"

# Get organization entitlements
Get-TfcOrganizationEntitlements -Organization "my-org"
```

### Working with Workspaces

```powershell
# Get all workspaces in an organization
Get-TfcWorkspace -Organization "my-org"

# Get all workspaces (all pages)
Get-TfcWorkspace -Organization "my-org" -AllPages

# Find workspaces across organizations
Find-TfcWorkspace -WorkspaceName "prod" -Organization "my-org"

# Create a new workspace
New-TfcWorkspace -Organization "my-org" -Name "new-workspace" -TerraformVersion "1.5.0"

# Create workspace with auto-apply
New-TfcWorkspace -Organization "my-org" -Name "auto-workspace" -AutoApply -Description "Automated deployment"

# Lock / unlock a workspace
Lock-TfcWorkspace -Organization "my-org" -Name "my-workspace" -Reason "Maintenance"
Unlock-TfcWorkspace -Organization "my-org" -Name "my-workspace"

# Delete a workspace
Remove-TfcWorkspace -Organization "my-org" -Name "old-workspace"
```

### Managing Runs

```powershell
# Get runs for a workspace
Get-TfcRun -WorkspaceId "ws-123"

# Create a new run
New-TfcRun -WorkspaceId "ws-123" -Message "Deploy infrastructure changes"

# Create a destroy run
New-TfcRun -WorkspaceId "ws-123" -IsDestroy -Message "Teardown test environment"

# Approve and apply a run
Confirm-TfcRun -RunId "run-abc123" -Comment "Approved by ops team"

# Discard a run
Deny-TfcRun -RunId "run-abc123" -Comment "Changes not approved"

# Cancel a running run
Stop-TfcRun -RunId "run-abc123" -Comment "Emergency cancellation"
```

### Managing Variables

```powershell
# Get all variables in a workspace
Get-TfcWorkspaceVariable -WorkspaceId "ws-1234567890abcdef"

# Set a Terraform variable
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-east-1" -Category "terraform"

# Set a sensitive environment variable
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "API_KEY" -Value "secret" -Category "env" -Sensitive

# Update a variable
Update-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-west-2" -Category "terraform"

# Remove a variable
Remove-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "old_variable"
```

### Working with State

```powershell
# Get current state version
Get-TfcCurrentStateVersion -WorkspaceId "ws-123"

# Download current state file
Get-TfcCurrentStateVersion -WorkspaceId "ws-123" -OutputPath "./terraform.tfstate"

# Get outputs from a state version
Get-TfcStateVersionOutput -StateVersionId "sv-abc123"

# Rollback to previous state
Invoke-TfcStateRollback -WorkspaceId "ws-123" -StateVersionId "sv-previous"
```

### Policy Management

```powershell
# List policies in an organization
Get-TfcPolicy -Organization "my-org"

# Create a Sentinel policy
New-TfcPolicy -Organization "my-org" -Name "restrict-regions" -EnforcementLevel "soft-mandatory"

# Upload policy code
Invoke-TfcPolicyUpload -PolicyId "pol-123" -Content $sentinelCode

# Create a policy set and attach to workspaces
New-TfcPolicySet -Organization "my-org" -Name "security-policies"
Set-TfcPolicySetWorkspace -PolicySetId "polset-123" -WorkspaceIds @("ws-456")
```

### Run Tasks

```powershell
# Create a run task
New-TfcRunTask -Organization "my-org" -Name "security-scan" -Url "https://scanner.example.com" -HmacKey "secret-key"

# Attach run task to workspace
Add-TfcWorkspaceRunTask -WorkspaceId "ws-123" -RunTaskId "task-123" -Stage "post_plan" -EnforcementLevel "advisory"

# Get run task results
Get-TfcRunTaskResult -RunId "run-abc123"
```

### Notifications

```powershell
# Create Slack notification
New-TfcNotificationConfiguration -WorkspaceId "ws-123" -Name "slack-alerts" `
    -DestinationType "slack" -Url "https://hooks.slack.com/services/XXX" `
    -Triggers @("run:completed", "run:errored")

# Create Microsoft Teams notification
New-TfcNotificationConfiguration -WorkspaceId "ws-123" -Name "teams-alerts" `
    -DestinationType "microsoft-teams" -Url "https://outlook.office.com/webhook/XXX" `
    -Triggers @("run:completed", "run:errored")

# Test notification
Test-TfcNotificationConfiguration -NotificationConfigurationId "nc-123"
```

### Stacks & Drift Detection

```powershell
# List stacks
Get-TfcStack -Organization "my-org"

# Create a stack
New-TfcStack -Organization "my-org" -Name "production-stack"

# Enable drift detection
Enable-TfcDriftDetection -WorkspaceId "ws-123"

# Check drift status
Get-TfcDriftStatus -WorkspaceId "ws-123"
```

### Using the Generic API Function

```powershell
# Make any API call directly
$result = Invoke-TfcApi -Uri "/organizations" -Method GET

# GraphQL explorer query
Invoke-TfcExplorerQuery -Query "{ organizations { nodes { name } } }"
```

### Pagination

```powershell
# Automatic pagination
Get-TfcWorkspace -Organization "my-org" -AllPages

# Manual pagination
Get-TfcWorkspace -Organization "my-org" -PageNumber 2 -PageSize 50
```

### Verbose Output

```powershell
Get-TfcWorkspace -Organization "my-org" -Verbose
```

## Error Handling

```powershell
try {
    Get-TfcWorkspace -Organization "nonexistent-org"
}
catch {
    Write-Error "Failed: $($_.Exception.Message)"
}
```

Common error scenarios handled: authentication failures (401), authorization failures (403), resource not found (404), invalid ID formats, and network connectivity issues.

## Testing

The module includes a comprehensive test suite with three modes. See [TESTING.md](TESTING.md) for full details.

```powershell
# Run unit tests with mock mode (no API calls)
./Tests/Invoke-AllTests.ps1 -TestType Unit -Coverage

# Run against a test organization
./Test-TerraformCloudModule.ps1 -UseTestOrganization -TestOrganizationName "test-org"
```

## Function Reference

For detailed help on any function:

```powershell
Get-Help Get-TfcWorkspace -Full
Get-Help Set-TfcWorkspaceVariable -Examples
Get-Command -Module TerraformCloud
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full development guide including commit conventions, local build workflow, and the automated release process.

## License

This project is licensed under the Apache 2.0 License. See [LICENSE](LICENSE) for details.

## Author

Seth T. Bacon - Copyright (c) 2025-2026
