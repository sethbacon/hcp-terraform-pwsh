# TerraformCloud PowerShell Module

A comprehensive PowerShell module for interacting with the Terraform Cloud API. This module provides **110 functions** covering ~44% of the Terraform Cloud API, including complete support for organizations, workspaces, variables, runs, state management, run triggers, run tasks, notifications, agent pools, and more.

## Version 1.0.0 Highlights

- **110 Total Functions** (49 new functions in Phase 1 & 2)
- **~44% API Coverage** - Focus on workflow automation and enterprise features
- **Run Triggers** - Automate workspace dependencies
- **Run Tasks** - Integrate external validation and security scanning
- **Notifications** - Slack, email, Microsoft Teams, and webhook integrations
- **Agent Pools** - Self-hosted agent management
- **Enhanced Plans & Applies** - JSON output, logs, and plan exports
- **Token Management** - Team, organization, and user token lifecycle
- **SSH Keys** - Git repository access management

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Authentication](#authentication)
- [Available Functions](#available-functions)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Installation

### Install from PowerShell Gallery (when published)

```powershell
Install-Module -Name TerraformCloud -Scope CurrentUser
```

### Manual Installation

1. Clone or download this repository
2. Copy the module files to your PowerShell modules directory:
   - Windows: `$env:USERPROFILE\Documents\PowerShell\Modules\TerraformCloud\`
   - Linux/macOS: `~/.local/share/powershell/Modules/TerraformCloud/`
3. Import the module:

```powershell
Import-Module TerraformCloud
```

## Quick Start

```powershell
# Import the module
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

The module supports multiple authentication methods:

### Environment Variable (Recommended)

Set the `TFE_TOKEN` environment variable:

```powershell
$env:TFE_TOKEN = "your-terraform-cloud-token-here"
```

### Terraform CLI Credentials File

The module automatically detects and uses tokens from `~/.terraform.d/credentials.tfrc.json`:

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

### Core API

- `Invoke-TfcApi` - Generic API call function for any Terraform Cloud endpoint

### Account Management

- `Get-TfcAccount` - Get current user account information

### Organizations

- `Get-TfcOrganization` - Get organizations accessible to the current user
- `Get-TfcOrganizationEntitlements` - Get feature entitlements for an organization
- `New-TfcOrganization` - Create a new organization
- `Update-TfcOrganization` - Update organization settings
- `Remove-TfcOrganization` - Delete an organization

### Workspaces

- `Get-TfcWorkspace` - Get workspaces from an organization
- `New-TfcWorkspace` - Create a new workspace
- `Update-TfcWorkspace` - Update an existing workspace
- `Remove-TfcWorkspace` - Delete a workspace
- `Lock-TfcWorkspace` - Lock a workspace to prevent runs
- `Unlock-TfcWorkspace` - Unlock a workspace
- `Find-TfcWorkspace` - Find workspaces by name across organizations
- `Test-TfcWorkspaceId` - Validate workspace ID format
- `Get-TfcWorkspaceTag` - Get tags assigned to a workspace
- `Set-TfcWorkspaceTag` - Add or replace tags on a workspace

### Variables

- `Get-TfcWorkspaceVariable` - Get variables from a workspace
- `Set-TfcWorkspaceVariable` - Create a new variable in a workspace
- `Update-TfcWorkspaceVariable` - Update an existing variable in a workspace
- `Remove-TfcWorkspaceVariable` - Remove a variable from a workspace

### Variable Sets

- `Get-TfcVariableSet` - Get variable sets from an organization
- `New-TfcVariableSet` - Create a new variable set
- `Update-TfcVariableSet` - Update an existing variable set
- `Remove-TfcVariableSet` - Delete a variable set
- `Set-TfcVariableSetWorkspace` - Assign a variable set to workspaces
- `Remove-TfcVariableSetWorkspace` - Remove variable set assignment from workspaces

### Configuration Versions

- `Get-TfcConfigurationVersionList` - List configuration versions for a workspace
- `Get-TfcConfigurationVersion` - Get specific configuration version details
- `New-TfcConfigurationVersion` - Create new configuration version (prepare for code upload)
- `Invoke-TfcConfigurationUpload` - Upload Terraform code tarball to configuration version

### Runs, Plans & Applies

- `Get-TfcRun` - Get runs from a workspace
- `New-TfcRun` - Create a new run
- `Get-TfcPlan` - Get plan information for a run
- `Get-TfcApply` - Get apply information for a run
- `Get-TfcPlanJson` - Get structured JSON output from plan (NEW v1.0.0)
- `Get-TfcPlanLog` - Get raw plan logs for debugging (NEW v1.0.0)
- `Get-TfcApplyLog` - Get raw apply logs for audit trail (NEW v1.0.0)
- `New-TfcPlanExport` - Create plan export in JSON format (NEW v1.0.0)
- `Get-TfcPlanExport` - Download plan export data (NEW v1.0.0)
- `Confirm-TfcRun` - Apply a run (approve and execute)
- `Deny-TfcRun` - Discard a run (reject)
- `Stop-TfcRun` - Cancel a run in progress
- `Stop-TfcRunForce` - Force cancel a stuck run
- `Invoke-TfcRunForceExecute` - Force execute a run bypassing queue rules

### State Management

- `Get-TfcCurrentStateVersion` - Get current state version and optionally download state file
- `Get-TfcStateVersion` - Get state versions from a workspace or specific state version
- `New-TfcStateVersion` - Create a new state version (state push)
- `Get-TfcStateVersionOutput` - Get outputs from a specific state version

### Projects

- `Get-TfcProject` - Get projects from an organization
- `New-TfcProject` - Create a new project
- `Update-TfcProject` - Update an existing project
- `Remove-TfcProject` - Delete a project

### Registry Modules

- `Get-TfcRegistryModule` - Get registry modules from an organization
- `New-TfcRegistryModule` - Create a registry module from VCS
- `Remove-TfcRegistryModule` - Delete a registry module

### Registry Providers

- `Get-TfcRegistryProvider` - Get registry providers from an organization
- `New-TfcRegistryProvider` - Create a registry provider
- `Remove-TfcRegistryProvider` - Delete a registry provider

### Teams

- `Get-TfcTeam` - Get teams for an organization
- `Get-TfcTeamAccess` - Get team access for a workspace
- `New-TfcTeam` - Create a new team
- `Update-TfcTeam` - Update team properties
- `Remove-TfcTeam` - Delete a team
- `Add-TfcWorkspaceTeamAccess` - Grant team access to workspace with permissions (NEW v1.0.0)
- `Update-TfcWorkspaceTeamAccess` - Modify team access levels (NEW v1.0.0)
- `Remove-TfcWorkspaceTeamAccess` - Revoke team access from workspace (NEW v1.0.0)
- `Show-TfcWorkspaceTeamAccess` - Get specific team access details (NEW v1.0.0)

### Run Triggers (NEW v1.0.0)

- `Get-TfcRunTrigger` - List run triggers for workspace
- `New-TfcRunTrigger` - Create run trigger to link workspaces
- `Remove-TfcRunTrigger` - Delete run trigger
- `Show-TfcRunTrigger` - Get specific run trigger details

### Run Tasks (NEW v1.0.0)

- `Get-TfcRunTask` - List organization run tasks
- `New-TfcRunTask` - Create new run task integration
- `Update-TfcRunTask` - Update run task URL and HMAC key
- `Remove-TfcRunTask` - Delete run task
- `Get-TfcWorkspaceRunTask` - List run tasks attached to workspace
- `Add-TfcWorkspaceRunTask` - Attach run task to workspace
- `Update-TfcWorkspaceRunTask` - Update workspace run task configuration
- `Remove-TfcWorkspaceRunTask` - Remove run task from workspace

### Notification Configurations (NEW v1.0.0)

- `Get-TfcNotificationConfiguration` - List workspace notifications
- `New-TfcNotificationConfiguration` - Create notification (Slack, email, webhook, Teams)
- `Update-TfcNotificationConfiguration` - Update notification settings
- `Remove-TfcNotificationConfiguration` - Delete notification
- `Test-TfcNotificationConfiguration` - Send test notification

### Agent Pools & Agents (NEW v1.0.0)

- `Get-TfcAgentPool` - List agent pools or get specific pool
- `New-TfcAgentPool` - Create new agent pool
- `Update-TfcAgentPool` - Update agent pool name
- `Remove-TfcAgentPool` - Delete agent pool
- `Get-TfcAgent` - List agents in agent pool

### Agent Tokens (NEW v1.0.0)

- `Get-TfcAgentToken` - List tokens for agent pool
- `New-TfcAgentToken` - Create agent token
- `Remove-TfcAgentToken` - Delete agent token

### SSH Keys (NEW v1.0.0)

- `Get-TfcSSHKey` - List SSH keys or get specific key
- `New-TfcSSHKey` - Create SSH key for Git access
- `Update-TfcSSHKey` - Update SSH key name
- `Remove-TfcSSHKey` - Delete SSH key
- `Set-TfcWorkspaceSSHKey` - Assign or unassign SSH key to workspace

### Token Management (NEW v1.0.0)

- `New-TfcTeamToken` - Generate team authentication token
- `Remove-TfcTeamToken` - Delete team token
- `New-TfcOrganizationToken` - Generate organization token
- `Remove-TfcOrganizationToken` - Delete organization token
- `Get-TfcUserToken` - List user tokens
- `New-TfcUserToken` - Generate user token
- `Remove-TfcUserToken` - Delete user token

### Additional Features (NEW v1.0.0)

- `Get-TfcWorkspaceResource` - List resources managed by workspace
- `Get-TfcCostEstimate` - Get cost estimate for run
- `Get-TfcVCSEvent` - List VCS events for workspace

### OAuth & VCS

- `Get-TfcOAuthClient` - Get OAuth clients (VCS providers) for an organization

### Users

- `Get-TfcCurrentUser` - Get current user information

## Examples

### Working with Organizations

```powershell
# List all organizations you have access to
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

# Get a specific workspace
Get-TfcWorkspace -Organization "my-org" -Name "my-workspace"

# Find workspaces across organizations
Find-TfcWorkspace -ListOrganizations
Find-TfcWorkspace -WorkspaceName "prod" -Organization "my-org"

# Create a new workspace
New-TfcWorkspace -Organization "my-org" -Name "new-workspace" -TerraformVersion "1.5.0"

# Create workspace with auto-apply enabled
New-TfcWorkspace -Organization "my-org" -Name "auto-workspace" -AutoApply -Description "Automated deployment"

# Update a workspace
Update-TfcWorkspace -Organization "my-org" -Name "my-workspace" -TerraformVersion "1.6.0"

# Lock a workspace
Lock-TfcWorkspace -Organization "my-org" -Name "my-workspace" -Reason "Maintenance in progress"

# Unlock a workspace
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

# Get plan details for a run
Get-TfcPlan -RunId "run-abc123"

# Get apply details for a run
Get-TfcApply -RunId "run-abc123"

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

### Managing Projects

```powershell
# List all projects in an organization
Get-TfcProject -Organization "my-org"

# Get a specific project
Get-TfcProject -Organization "my-org" -Name "production"

# Create a new project
New-TfcProject -Organization "my-org" -Name "production" -Description "Production workspaces"

# Update a project
Update-TfcProject -ProjectId "prj-123" -Name "prod-updated" -Description "Updated production project"

# Delete a project
Remove-TfcProject -ProjectId "prj-123"
```

### Working with State

```powershell
# Get current state version info
Get-TfcCurrentStateVersion -WorkspaceId "ws-123"

# Download current state file
Get-TfcCurrentStateVersion -WorkspaceId "ws-123" -OutputPath "./terraform.tfstate"

# Get state versions for a workspace
Get-TfcStateVersion -WorkspaceId "ws-123"

# Get a specific state version
Get-TfcStateVersion -StateVersionId "sv-abc123"

# Get outputs from a state version
Get-TfcStateVersionOutput -StateVersionId "sv-abc123"

# Create a new state version (state push)
$stateJson = Get-Content ./terraform.tfstate -Raw
$md5Hash = (Get-FileHash -Path ./terraform.tfstate -Algorithm MD5).Hash
New-TfcStateVersion -WorkspaceId "ws-123" -StateData $stateJson -MD5 $md5Hash -Serial 1
```

### Managing Registry Modules

```powershell
# List registry modules
Get-TfcRegistryModule -Organization "my-org"

# Get a specific module
Get-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"

# Create a registry module from VCS
New-TfcRegistryModule -Organization "my-org" -VcsRepoIdentifier "myorg/terraform-aws-vpc" -OAuthTokenId "ot-abc123"

# Delete a registry module
Remove-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
```

### Managing Registry Providers

```powershell
# List registry providers
Get-TfcRegistryProvider -Organization "my-org"

# Get a specific provider
Get-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"

# Create a registry provider
New-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"

# Delete a registry provider
Remove-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
```

### Working with Teams

```powershell
# Get all teams in an organization
Get-TfcTeam -Organization "my-org"

# Get team access for a workspace
Get-TfcTeamAccess -WorkspaceId "ws-123"
```

### Managing Run Triggers (NEW v1.0.0)

```powershell
# List run triggers for a workspace
Get-TfcRunTrigger -WorkspaceId "ws-target"

# Create run trigger (link source workspace to target workspace)
New-TfcRunTrigger -WorkspaceId "ws-target" -SourceWorkspaceId "ws-source"

# Get specific run trigger
Show-TfcRunTrigger -RunTriggerId "rt-abc123"

# Remove run trigger
Remove-TfcRunTrigger -RunTriggerId "rt-abc123"
```

### Managing Run Tasks (NEW v1.0.0)

```powershell
# List organization run tasks
Get-TfcRunTask -Organization "my-org"

# Create a run task
New-TfcRunTask -Organization "my-org" -Name "security-scan" -Url "https://scanner.example.com" -HmacKey "secret-key"

# Update run task
Update-TfcRunTask -RunTaskId "task-123" -Url "https://new-scanner.example.com"

# List run tasks attached to workspace
Get-TfcWorkspaceRunTask -WorkspaceId "ws-123"

# Attach run task to workspace
Add-TfcWorkspaceRunTask -WorkspaceId "ws-123" -RunTaskId "task-123" -Stage "post_plan" -EnforcementLevel "advisory"

# Update workspace run task configuration
Update-TfcWorkspaceRunTask -WorkspaceRunTaskId "wsrt-456" -EnforcementLevel "mandatory"

# Remove run task from workspace
Remove-TfcWorkspaceRunTask -WorkspaceRunTaskId "wsrt-456"

# Delete run task
Remove-TfcRunTask -RunTaskId "task-123"
```

### Managing Notifications (NEW v1.0.0)

```powershell
# List notification configurations for workspace
Get-TfcNotificationConfiguration -WorkspaceId "ws-123"

# Create Slack notification
New-TfcNotificationConfiguration -WorkspaceId "ws-123" -Name "slack-alerts" `
    -DestinationType "slack" -Url "https://hooks.slack.com/services/XXX" `
    -Triggers @("run:completed", "run:errored")

# Create email notification
New-TfcNotificationConfiguration -WorkspaceId "ws-123" -Name "email-alerts" `
    -DestinationType "email" -EmailAddresses @("team@example.com") `
    -Triggers @("run:needs_attention")

# Create Microsoft Teams notification
New-TfcNotificationConfiguration -WorkspaceId "ws-123" -Name "teams-alerts" `
    -DestinationType "microsoft-teams" -Url "https://outlook.office.com/webhook/XXX" `
    -Triggers @("run:completed", "run:errored")

# Update notification configuration
Update-TfcNotificationConfiguration -NotificationConfigurationId "nc-123" `
    -Enabled $true -Triggers @("run:completed")

# Test notification
Test-TfcNotificationConfiguration -NotificationConfigurationId "nc-123"

# Remove notification
Remove-TfcNotificationConfiguration -NotificationConfigurationId "nc-123"
```

### Managing Enhanced Plans & Applies (NEW v1.0.0)

```powershell
# Get plan JSON output for structured parsing
$planJson = Get-TfcPlanJson -PlanId "plan-123"

# Get plan logs for debugging
Get-TfcPlanLog -PlanId "plan-123"

# Get apply logs for audit trail
Get-TfcApplyLog -ApplyId "apply-456"

# Create plan export (JSON format)
New-TfcPlanExport -PlanId "plan-123"

# Get plan export data
Get-TfcPlanExport -PlanExportId "pe-789"
```

### Managing Workspace Team Access (NEW v1.0.0)

```powershell
# Add team access to workspace with read permission
Add-TfcWorkspaceTeamAccess -WorkspaceId "ws-123" -TeamId "team-456" -Access "read"

# Add team with custom permissions
Add-TfcWorkspaceTeamAccess -WorkspaceId "ws-123" -TeamId "team-789" `
    -Access "custom" -RunsPermission "plan" -VariablesPermission "write" `
    -StateVersionsPermission "read" -SentinelMocksPermission "read" `
    -WorkspaceLockingPermission $false

# Update team access level
Update-TfcWorkspaceTeamAccess -TeamAccessId "tws-123" -Access "write"

# Show specific team access details
Show-TfcWorkspaceTeamAccess -TeamAccessId "tws-123"

# Remove team access from workspace
Remove-TfcWorkspaceTeamAccess -TeamAccessId "tws-123"
```

### Managing Agent Pools (NEW v1.0.0)

```powershell
# List agent pools
Get-TfcAgentPool -Organization "my-org"

# Create agent pool
New-TfcAgentPool -Organization "my-org" -Name "on-prem-agents"

# Update agent pool
Update-TfcAgentPool -AgentPoolId "apool-123" -Name "updated-agents"

# List agents in pool
Get-TfcAgent -AgentPoolId "apool-123"

# Delete agent pool
Remove-TfcAgentPool -AgentPoolId "apool-123"
```

### Managing Agent Tokens (NEW v1.0.0)

```powershell
# List agent tokens
Get-TfcAgentToken -AgentPoolId "apool-123"

# Create agent token
$token = New-TfcAgentToken -AgentPoolId "apool-123" -Description "Production agent"
Write-Host "Save this token: $($token.attributes.token)"

# Remove agent token
Remove-TfcAgentToken -AgentTokenId "at-456"
```

### Managing SSH Keys (NEW v1.0.0)

```powershell
# List SSH keys
Get-TfcSSHKey -Organization "my-org"

# Create SSH key
$privateKey = Get-Content -Path "~/.ssh/id_rsa" -Raw
New-TfcSSHKey -Organization "my-org" -Name "git-access" -Value $privateKey

# Update SSH key name
Update-TfcSSHKey -SSHKeyId "sshkey-123" -Name "updated-git-access"

# Assign SSH key to workspace
Set-TfcWorkspaceSSHKey -WorkspaceId "ws-123" -SSHKeyId "sshkey-123"

# Unassign SSH key from workspace
Set-TfcWorkspaceSSHKey -WorkspaceId "ws-123"

# Remove SSH key
Remove-TfcSSHKey -SSHKeyId "sshkey-123"
```

### Managing Tokens (NEW v1.0.0)

```powershell
# Create team token
$teamToken = New-TfcTeamToken -TeamId "team-123"
Write-Host "Team token: $($teamToken.attributes.token)"

# Remove team token
Remove-TfcTeamToken -TeamId "team-123"

# Create organization token
$orgToken = New-TfcOrganizationToken -Organization "my-org"
Write-Host "Org token: $($orgToken.attributes.token)"

# Remove organization token
Remove-TfcOrganizationToken -Organization "my-org"

# List user tokens
Get-TfcUserToken

# Create user token
$userToken = New-TfcUserToken -Description "CLI access"
Write-Host "User token: $($userToken.attributes.token)"

# Remove user token
Remove-TfcUserToken -TokenId "at-789"
```

### Additional Workspace Features (NEW v1.0.0)

```powershell
# List resources managed by workspace
Get-TfcWorkspaceResource -WorkspaceId "ws-123"

# Get cost estimate for a run
Get-TfcCostEstimate -RunId "run-456"

# List VCS events for workspace
Get-TfcVCSEvent -WorkspaceId "ws-123"
```

### Using the Generic API Function

```powershell
# Make any API call
$result = Invoke-TfcApi -Uri "/organizations" -Method GET

# Create a new workspace (example)
$body = @{
    data = @{
        type = "workspaces"
        attributes = @{
            name = "new-workspace"
            "terraform-version" = "latest"
        }
        relationships = @{
            organization = @{
                data = @{
                    type = "organizations"
                    id = "my-org"
                }
            }
        }
    }
} | ConvertTo-Json -Depth 10

Invoke-TfcApi -Uri "/organizations/my-org/workspaces" -Method POST -Body $body
```

## Error Handling

The module includes comprehensive error handling:

```powershell
try {
    Get-TfcWorkspace -Organization "nonexistent-org"
}
catch {
    Write-Error "Failed to get workspaces: $($_.Exception.Message)"
}
```

Common error scenarios handled:

- Authentication failures (401)
- Authorization failures (403)
- Resource not found (404)
- Invalid workspace ID formats
- Network connectivity issues

## Advanced Usage

### Pagination

Many functions support pagination:

```powershell
# Get all workspaces (handles pagination automatically)
Get-TfcWorkspace -Organization "my-org" -AllPages

# Get specific page
Get-TfcWorkspace -Organization "my-org" -PageNumber 2 -PageSize 50
```

### Verbose Output

Enable verbose output for debugging:

```powershell
Get-TfcWorkspace -Organization "my-org" -Verbose
```

## Function Reference

For detailed help on any function:

```powershell
Get-Help Get-TfcWorkspace -Full
Get-Help Set-TfcWorkspaceVariable -Examples
```

## Migration from Individual Scripts

This module consolidates and replaces individual PowerShell scripts with a unified, well-structured module. Here's how the old scripts map to new functions:

| Old Script | New Function |
|------------|--------------|
| `Get-TFCCurrentState.ps1` | `Get-TfcCurrentStateVersion` |
| `Get-TFCEntitlementSet.ps1` | `Get-TfcOrganizationEntitlements` |
| `Get-TFCTeamAccess.ps1` | `Get-TfcTeamAccess` |
| `Get-TFCTeams.ps1` | `Get-TfcTeam` |
| `Get-TFCUserFromToken.ps1` | `Get-TfcCurrentUser` |
| `Get-TFCWorkspaces.ps1` | `Get-TfcWorkspace` |
| `Get-TFCWorkspaceVariables.ps1` | `Get-TfcWorkspaceVariable` |
| `Set-TFCWorkspaceVariable.ps1` | `Set-TfcWorkspaceVariable` |
| `Update-TFCWorkspaceVariable.ps1` | `Update-TfcWorkspaceVariable` |
| `Remove-TFCWorkspaceVariable.ps1` | `Remove-TfcWorkspaceVariable` |
| `Find-TFCWorkspace.ps1` | `Find-TfcWorkspace` |
| `Test-TFCWorkspaceId.ps1` | `Test-TfcWorkspaceId` |

**New Functions Added:**

- Workspace lifecycle: `New-TfcWorkspace`, `Update-TfcWorkspace`, `Remove-TfcWorkspace`, `Lock-TfcWorkspace`, `Unlock-TfcWorkspace`
- Run management: `Get-TfcRun`, `New-TfcRun`, `Confirm-TfcRun`, `Deny-TfcRun`, `Stop-TfcRun`
- Plans and applies: `Get-TfcPlan`, `Get-TfcApply`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Changelog

### Version 1.0.0

- Initial release of the TerraformCloud PowerShell module
- Comprehensive coverage of Terraform Cloud API endpoints
- Support for all major resource types including workspaces, variables, runs, teams, and more
- Industry-standard documentation and help system
- Error handling and input validation
- Pagination support for list operations

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- Create an issue on GitHub for bug reports or feature requests
- Check the [Terraform Cloud API Documentation](https://developer.hashicorp.com/terraform/cloud-docs/api-docs) for API reference

## Author

Seth T. Bacon - Copyright (c) 2025
