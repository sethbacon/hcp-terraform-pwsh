# TerraformCloud PowerShell Module - AI Coding Agent Instructions

## Development Workflow

All changes follow this workflow. Do not deviate from it.

### Branches

- `main` — production-ready, tagged releases only. **Must always exist — never delete.**
- `development` — integration branch; all feature/fix branches merge here first. **Must always exist — never delete.**
- Feature/fix branches are created from `development`, never from `main`. Delete them from remote after their PR is merged; clean up locally with `git branch -d`.

```bash
# After a feature/fix PR is merged:
git push origin --delete fix/short-description   # remove remote branch
git branch -d fix/short-description              # remove local branch
git remote prune origin                          # prune stale remote-tracking refs
```

### Step-by-step

1. **Open a GitHub issue** describing the bug or feature before writing any code.

2. **Create a branch from `development`**:

   ```bash
   git fetch origin
   git checkout -b fix/short-description origin/development
   # or: feature/short-description
   ```

3. **Implement the change**, updating `CHANGELOG.md` under `[Unreleased]` as you go.

4. **Commit — no co-author attribution**:

   ```bash
   git add <specific files>
   git commit -m "fix: short description of what was fixed

   Closes #<issue-number>"
   ```

5. **Push to origin**:

   ```bash
   git push -u origin fix/short-description
   ```

6. **Open a PR from the feature branch → `development`**:

   ```bash
   gh pr create --base development --title "fix: short description" --body "Closes #<issue>"
   ```

   - Update `CHANGELOG.md` and any affected docs in this PR if not already done.
   - Squash-merge into `development` when approved.

7. **Open a PR from `development` → `main`** when the integration branch is ready to ship:

   ```bash
   gh pr create --base main --title "chore: release vX.Y.Z" --body "..."
   ```

### Releasing a version

When a release is called for:

1. Promote `[Unreleased]` in `CHANGELOG.md` to the new version with today's date:

   ```markdown
   ## [X.Y.Z] - YYYY-MM-DD
   ```

2. Bump `ModuleVersion` in `Build-Module.ps1` to match the new version.

3. Commit directly on `development`:

   ```bash
   git commit -m "chore: release vX.Y.Z"
   git push origin development
   ```

4. Merge `development` → `main` via PR (step 7 above).

5. **After the PR is merged**, tag on `main` and create the GitHub release:

   ```bash
   git checkout main
   git pull origin main
   git tag vX.Y.Z
   git push origin --tags
   gh release create vX.Y.Z --title "vX.Y.Z" --notes "See CHANGELOG.md for details"
   ```

   > **Important**: The tag must be on `main` so the CI publish job checks out the
   > exact code that is in production. Tagging before the merge would point the
   > release at a `development` commit that may differ from `main` after merge.


## Module Architecture

This is a **comprehensive PowerShell module wrapper** for the Terraform Cloud/Enterprise API v2, providing standardized PowerShell cmdlets for infrastructure automation. The module follows PowerShell best practices with proper manifest structure, help documentation, and cross-platform compatibility (PowerShell 5.1+ and 7.x).

**Core Components**:
- **TerraformCloud.psm1**: Single consolidated module containing all 147 functions (~6,600 lines)
- **TerraformCloud.psd1**: Module manifest defining exports, metadata, and PowerShell Gallery integration
- **Test-TerraformCloudModule.ps1**: Comprehensive test suite with 130 tests and mock mode support

**Key Design Pattern**: All functions use consistent `Verb-TfcNoun` naming (`Get-TfcWorkspace`, `New-TfcWorkspace`, `Lock-TfcWorkspace`) where `Tfc` prefix identifies the module and avoids naming conflicts.

**Module Coverage**:
- **v1.0.0**: 147 functions covering ~59% of Terraform Cloud API
- Comprehensive coverage of core operations, policy management, and enterprise features

**Documentation Philosophy**:
- **DO NOT** create summary documents, implementation summaries, release notes, or migration guides
- **DO** maintain: README.md, CHANGELOG.md, API-COVERAGE-ANALYSIS.md, TESTING.md, and inline function help
- **All markdown documentation MUST be free from linting errors** - verify with markdownlint before completion
- Keep documentation concise and focused on technical reference

## Authentication & API Connection

Authentication uses a **dual-source token resolution** strategy in this order:

1. **Environment variable** (preferred): `$env:TFE_TOKEN`
2. **Terraform CLI credentials file**: `~/.terraform.d/credentials.tfrc.json`

```powershell
# Token initialization happens automatically on first API call via Initialize-TfcConnection
# Module-level script variables manage connection state:
$script:TfcApiBaseUri = 'https://app.terraform.io/api/v2'
$script:TfcToken = $null  # Stored as SecureString
$script:TfcHeaders = @{'Content-Type' = 'application/vnd.api+json'}
```

**Critical**: All API calls use `-Authentication Bearer -Token $script:TfcToken` with PowerShell's built-in REST authentication.

## Function Categories & Patterns

### All Functions in Single Module (TerraformCloud.psm1)

The module contains **147 functions organized by category**:

**Core Operations**:
- Account/User: `Get-TfcAccount`, `Get-TfcCurrentUser`
- Organizations: `Get-TfcOrganization`, `Get-TfcOrganizationEntitlements`, `New-TfcOrganization`, `Update-TfcOrganization`, `Remove-TfcOrganization`
- Projects: `Get-TfcProject`, `New-TfcProject`, `Update-TfcProject`, `Remove-TfcProject`
- Workspaces: `Get-TfcWorkspace`, `Find-TfcWorkspace`, `Test-TfcWorkspaceId`, `Get-TfcWorkspaceTag`, `Set-TfcWorkspaceTag`, `New-TfcWorkspace`, `Update-TfcWorkspace`, `Remove-TfcWorkspace`, `Lock-TfcWorkspace`, `Unlock-TfcWorkspace`
- Variables: `Get-TfcWorkspaceVariable`, `Set-TfcWorkspaceVariable`, `Update-TfcWorkspaceVariable`, `Remove-TfcWorkspaceVariable`
- Variable Sets: `Get-TfcVariableSet`, `New-TfcVariableSet`, `Update-TfcVariableSet`, `Remove-TfcVariableSet`, `Set-TfcVariableSetWorkspace`, `Remove-TfcVariableSetWorkspace`
- State: `Get-TfcCurrentStateVersion`, `Get-TfcStateVersion`, `New-TfcStateVersion`, `Get-TfcStateVersionOutput`
- Runs: `Get-TfcRun`, `New-TfcRun`, `Confirm-TfcRun`, `Deny-TfcRun`, `Stop-TfcRun`, `Stop-TfcRunForce`, `Invoke-TfcRunForceExecute`
- Plans/Applies: `Get-TfcPlan`, `Get-TfcApply`
- Teams: `Get-TfcTeam`, `Get-TfcTeamAccess`, `New-TfcTeam`, `Update-TfcTeam`, `Remove-TfcTeam`
- OAuth: `Get-TfcOAuthClient`
- Configuration: `Get-TfcConfigurationVersionList`, `Get-TfcConfigurationVersion`, `New-TfcConfigurationVersion`, `Invoke-TfcConfigurationUpload`
- Registry: `Get-TfcRegistryModule`, `New-TfcRegistryModule`, `Remove-TfcRegistryModule`, `Get-TfcRegistryProvider`, `New-TfcRegistryProvider`, `Remove-TfcRegistryProvider`
- Core API: `Invoke-TfcApi`

**Workflow Automation**:
- Run Triggers: `Get-TfcRunTrigger`, `New-TfcRunTrigger`, `Remove-TfcRunTrigger`, `Show-TfcRunTrigger`
- Run Tasks: `Get-TfcRunTask`, `New-TfcRunTask`, `Update-TfcRunTask`, `Remove-TfcRunTask`, `Get-TfcWorkspaceRunTask`, `Add-TfcWorkspaceRunTask`, `Update-TfcWorkspaceRunTask`, `Remove-TfcWorkspaceRunTask`
- Notifications: `Get-TfcNotificationConfiguration`, `New-TfcNotificationConfiguration`, `Update-TfcNotificationConfiguration`, `Remove-TfcNotificationConfiguration`, `Test-TfcNotificationConfiguration`
- Enhanced Plans/Applies: `Get-TfcPlanJson`, `Get-TfcPlanLog`, `Get-TfcApplyLog`, `New-TfcPlanExport`, `Get-TfcPlanExport`
- Workspace Team Access: `Add-TfcWorkspaceTeamAccess`, `Update-TfcWorkspaceTeamAccess`, `Remove-TfcWorkspaceTeamAccess`, `Show-TfcWorkspaceTeamAccess`

**Enterprise Features**:
- Agent Pools: `Get-TfcAgentPool`, `New-TfcAgentPool`, `Update-TfcAgentPool`, `Remove-TfcAgentPool`, `Get-TfcAgent`
- Agent Tokens: `Get-TfcAgentToken`, `New-TfcAgentToken`, `Remove-TfcAgentToken`
- SSH Keys: `Get-TfcSSHKey`, `New-TfcSSHKey`, `Update-TfcSSHKey`, `Remove-TfcSSHKey`, `Set-TfcWorkspaceSSHKey`
- Token Management: `New-TfcTeamToken`, `Remove-TfcTeamToken`, `New-TfcOrganizationToken`, `Remove-TfcOrganizationToken`, `Get-TfcUserToken`, `New-TfcUserToken`, `Remove-TfcUserToken`
- Additional: `Get-TfcWorkspaceResource`, `Get-TfcCostEstimate`, `Get-TfcVCSEvent`

**Policy & Compliance**:
- Policies: `Get-TfcPolicy`, `New-TfcPolicy`, `Update-TfcPolicy`, `Remove-TfcPolicy`, `Invoke-TfcPolicyUpload`
- Policy Sets: `Get-TfcPolicySet`, `New-TfcPolicySet`, `Update-TfcPolicySet`, `Remove-TfcPolicySet`, `Add-TfcPolicySetPolicy`, `Set-TfcPolicySetWorkspace`, `Set-TfcPolicySetProject`
- Policy Checks: `Get-TfcPolicyCheck`, `Set-TfcPolicyCheckOverride`
- Audit Trails: `Get-TfcAuditTrail`
- Comments: `Get-TfcComment`, `New-TfcComment`

**Enhanced RBAC & Variables**:
- Variable Set Variables: `Get-TfcVariableSetVariable`, `New-TfcVariableSetVariable`, `Update-TfcVariableSetVariable`, `Remove-TfcVariableSetVariable`
- Team Membership: `Get-TfcTeamMember`, `Add-TfcTeamMember`, `Get-TfcTeamMemberDetails`, `Remove-TfcTeamMember`
- Project Team Access: `Add-TfcProjectTeamAccess`, `Get-TfcProjectTeamAccess`, `Get-TfcProjectTeamAccessDetails`, `Update-TfcProjectTeamAccess`, `Remove-TfcProjectTeamAccess`
- Organization Memberships: `Get-TfcOrganizationMembership`, `Remove-TfcOrganizationMembership`
- Organization Tags: `Get-TfcOrganizationTag`, `New-TfcOrganizationTag`, `Remove-TfcOrganizationTag`, `Add-TfcOrganizationTagRelationship`, `Remove-TfcOrganizationTagRelationship`

Functions return **JSON:API formatted responses** with `data`, `meta`, and `links` properties:

```powershell
# Standard pattern for list operations
function Get-TfcWorkspace {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,
        [int]$PageSize = 20,
        [int]$PageNumber = 1,
        [switch]$AllPages  # Automatic pagination via Get-AllPages helper
    )
    # Returns: @{ data = @(...), meta = @{ pagination = @{...} }, links = @{...} }
}
```

**Pagination Pattern**: The `Get-AllPages` private function handles `links.next` traversal when `-AllPages` is specified.

### Project Management (NEW in v1.2.0)
Projects provide workspace organization in Terraform Cloud:

```powershell
# List all projects
Get-TfcProject -Organization "my-org"

# Get specific project
Get-TfcProject -Organization "my-org" -Name "production"

# Create/Update/Delete
New-TfcProject -Organization "my-org" -Name "staging" -Description "Staging environments"
Update-TfcProject -ProjectId "prj-123" -Name "staging-v2"
Remove-TfcProject -ProjectId "prj-123" -Force  # -Force skips confirmation
```

### Workspace Variable Management
Variable operations require **workspace ID** (format: `ws-[a-zA-Z0-9]+`) validated by `Test-WorkspaceIdFormat`:

```powershell
# Creating variables requires explicit category specification
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-east-1" -Category "terraform"
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "API_KEY" -Value "secret" -Category "env" -Sensitive
```

**Categories**: `terraform` (Terraform variables) or `env` (environment variables)
**Boolean flags**: `-Sensitive`, `-HCL` (for HCL-formatted values)

### State Management (EXPANDED in v1.2.0)
State operations provide **download, list, and push capabilities**:

```powershell
# Get current state metadata and download file
Get-TfcCurrentStateVersion -WorkspaceId "ws-123"
Get-TfcCurrentStateVersion -WorkspaceId "ws-123" -OutputPath "./terraform.tfstate"

# List all state versions
Get-TfcStateVersion -WorkspaceId "ws-123"

# Get specific state version and outputs
Get-TfcStateVersion -StateVersionId "sv-abc123"
Get-TfcStateVersionOutput -StateVersionId "sv-abc123"

# Push new state version
$stateJson = Get-Content ./terraform.tfstate -Raw
$md5Hash = (Get-FileHash -Path ./terraform.tfstate -Algorithm MD5).Hash
New-TfcStateVersion -WorkspaceId "ws-123" -StateData $stateJson -MD5 $md5Hash -Serial 1
```

**State Push Requirements**: Base64-encoded state data, MD5 hash, serial number, optional lineage

### Registry Management (NEW in v1.2.0)
Manage private registry modules and providers:

```powershell
# Registry Modules
Get-TfcRegistryModule -Organization "my-org"
Get-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
New-TfcRegistryModule -Organization "my-org" -VcsRepoIdentifier "myorg/terraform-aws-vpc" -OAuthTokenId "ot-123"
Remove-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"

# Registry Providers
Get-TfcRegistryProvider -Organization "my-org"
New-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
Remove-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
```

**Registry Module Creation**: Requires VCS repository identifier and OAuth token for GitHub/GitLab/Bitbucket integration

### Policy & Compliance Management

Policy management for Sentinel and OPA policy enforcement:

```powershell
# Policies
$policy = New-TfcPolicy -Organization "my-org" -Name "require-tags" -Description "Enforce resource tagging" -Enforcement "hard-mandatory"
Invoke-TfcPolicyUpload -PolicyId $policy.data.id -FilePath "./require-tags.sentinel"
Update-TfcPolicy -PolicyId $policy.data.id -Enforcement "soft-mandatory"
Get-TfcPolicy -Organization "my-org"
Remove-TfcPolicy -PolicyId $policy.data.id

# Policy Sets
$policySet = New-TfcPolicySet -Organization "my-org" -Name "production-policies" -Description "Production environment policies"
Add-TfcPolicySetPolicy -PolicySetId $policySet.data.id -PolicyId $policy.data.id
Set-TfcPolicySetWorkspace -PolicySetId $policySet.data.id -WorkspaceId "ws-123"
Set-TfcPolicySetProject -PolicySetId $policySet.data.id -ProjectId "prj-123"
Get-TfcPolicySet -Organization "my-org"
Remove-TfcPolicySet -PolicySetId $policySet.data.id

# Policy Checks
$checks = Get-TfcPolicyCheck -RunId "run-123"
Set-TfcPolicyCheckOverride -PolicyCheckId "polchk-123"

# Audit Trails
Get-TfcAuditTrail -OrganizationName "my-org" -Since "2025-01-01" -Until "2025-01-31"

# Comments
New-TfcComment -RunId "run-123" -Body "Approved for production deployment"
Get-TfcComment -RunId "run-123"
```

**Policy Enforcement Levels**: `advisory` (warning only), `soft-mandatory` (overrideable), `hard-mandatory` (blocking)

### Enhanced RBAC & Organization Management

Advanced team management and organization tagging:

```powershell
# Variable Set Variables
New-TfcVariableSetVariable -VariableSetId "varset-123" -Key "AWS_REGION" -Value "us-east-1" -Category "env"
Update-TfcVariableSetVariable -VariableSetId "varset-123" -VariableId "var-456" -Value "us-west-2"
Get-TfcVariableSetVariable -VariableSetId "varset-123"
Remove-TfcVariableSetVariable -VariableSetId "varset-123" -VariableId "var-456"

# Team Membership
Get-TfcTeamMember -TeamId "team-123"
Add-TfcTeamMember -TeamId "team-123" -OrganizationMembershipIds @("ou-456", "ou-789")
Get-TfcTeamMemberDetails -TeamId "team-123" -OrganizationMembershipId "ou-456"
Remove-TfcTeamMember -TeamId "team-123" -OrganizationMembershipIds @("ou-456")

# Project Team Access
Add-TfcProjectTeamAccess -ProjectId "prj-123" -TeamId "team-456" -Access "write" -RunsAccess "apply" -VariablesAccess "write"
Get-TfcProjectTeamAccess -ProjectId "prj-123"
Update-TfcProjectTeamAccess -TeamProjectId "tprj-789" -Access "admin"
Remove-TfcProjectTeamAccess -TeamProjectId "tprj-789"

# Organization Memberships
Get-TfcOrganizationMembership -OrganizationName "my-org"
Get-TfcOrganizationMembership -OrganizationName "my-org" -MembershipId "ou-123"
Remove-TfcOrganizationMembership -MembershipId "ou-123"

# Organization Tags
$tag = New-TfcOrganizationTag -OrganizationName "my-org" -Name "production"
Add-TfcOrganizationTagRelationship -TagId $tag.data.id -WorkspaceIds @("ws-123", "ws-456")
Get-TfcOrganizationTag -OrganizationName "my-org"
Remove-TfcOrganizationTagRelationship -TagId $tag.data.id -WorkspaceIds @("ws-123")
Remove-TfcOrganizationTag -OrganizationName "my-org" -TagId $tag.data.id
```

**Project Team Access Levels**: `read` (view only), `write` (modify), `maintain` (manage settings), `admin` (full control)
**Granular Permissions**: `runs-access`, `variables-access`, `state-versions-access`, `sentinel-mocks-access`, `workspace-locking-access`

## Testing Framework

The module uses a **comprehensive three-mode testing strategy** in `Test-TerraformCloudModule.ps1`:

### Test Modes
1. **Mock Mode** (`-MockMode`): Completely safe simulation with `$script:MockData` hashtable (no API calls, no credentials required)
2. **Test Organization** (`-UseTestOrganization -TestOrganizationName "test-org"`): Real API in dedicated test environment
3. **Production-Safe** (default): Live API reads only, skips create/update/delete operations

### Test Coverage (v1.0.0)
**130 comprehensive tests** covering all 147 functions:
- **Core Tests** (34 tests): Module import, authentication, organizations, workspaces, teams, variables, state, runs, projects, registry, configuration
- **Workflow Tests** (34 tests): Run Triggers (4), Run Tasks (10), Notifications (5), Enhanced Plans/Applies (7), Workspace Team Access (4)
- **Enterprise Tests** (27 tests): Agent Pools (5), Agent Tokens (3), SSH Keys (6), Token Management (10), Additional Features (3)
- **Policy Tests** (17 tests): Policies (5), Policy Sets (7), Policy Checks (2), Audit Trails (1), Comments (2)
- **RBAC Tests** (20 tests): Variable Set Variables (4), Team Membership (4), Project Team Access (5), Organization Memberships (2), Organization Tags (5)
- **Cleanup Test** (1 test): Workspace cleanup after destructive operations

### Mock Data Infrastructure
The test suite includes comprehensive mock data for all API endpoints:
- 27 mock data collections covering all function categories
- 74 mock function handlers in `Invoke-MockTfcFunction`
- Full CRUD operation simulation for safe testing

**Test execution**:
```powershell
# Test execution pattern
./Test-TerraformCloudModule.ps1 -MockMode                    # Development/CI (100% safe)
./Test-TerraformCloudModule.ps1                              # Production validation (read-only)
./Test-TerraformCloudModule.ps1 -UseTestOrganization -TestOrganizationName "my-test-org"  # Full testing
./Test-TerraformCloudModule.ps1 -UseTestOrganization -RunDestructiveTests  # Complete integration test
```

**Test Result Tracking**: `Add-TestResult` function tracks all tests with status (PASS/FAIL/SKIP/MOCK), timestamp, and mode indicators. Test summary shows success rate, categorized results, and execution guidance.

## Build & Distribution Workflow

The `Build-Module.ps1` script handles packaging and validation:

```powershell
# Standard build workflow
./Build-Module.ps1 -Clean              # Clean build artifacts
./Build-Module.ps1 -Test               # Run test suite
./Build-Module.ps1 -Package            # Create dist/ package
./Build-Module.ps1 -Publish -ApiKey "xxx"  # Publish to PowerShell Gallery
```

**Build outputs**:
- `build/` - Temporary build directory
- `dist/` - Distribution package (used by CI/CD for artifacts)

## CI/CD Integration

GitHub Actions workflow (`.github/workflows/ci-cd.yml`) tests cross-platform compatibility:

**Test Matrix**:
- **OS**: windows-latest, ubuntu-latest, macos-latest
- **PowerShell**: 7.x (all platforms), 5.1 (Windows-only)

**Pipeline stages**:
1. **Test Job**: Module import, manifest validation, PSScriptAnalyzer (PSGallery severity rules)
2. **Build Job**: Package creation, artifact upload, release asset preparation

## Common Development Patterns

### Adding New Functions

1. **Add to main module file** (`TerraformCloud.psm1`):
   - Place in appropriate `#region` section (Private or Public Functions)
   - Maintain alphabetical ordering within function categories

2. **Update manifest exports** in `TerraformCloud.psd1`:
   ```powershell
   FunctionsToExport = @(
       'Invoke-TfcApi',
       'Get-TfcAccount',
       'Get-TfcNewResource',  # Add new function here
       # ... existing functions in alphabetical order
   )
   ```

3. **Add comprehensive comment-based help**:
   ```powershell
   <#
   .SYNOPSIS
       Brief description
   .DESCRIPTION
       Detailed description
   .PARAMETER ParameterName
       Parameter description
   .EXAMPLE
       Get-TfcNewResource -Param "value"
   .OUTPUTS
       PSCustomObject representing the API response
   #>
   ```

4. **Follow error handling pattern**:
   ```powershell
   try {
       Initialize-TfcConnection  # Always call first
       # API operations
   }
   catch {
       throw "Descriptive error: $($_.Exception.Message)"
   }
   ```

### Working with JSON:API Format

Terraform Cloud API follows JSON:API spec - all requests/responses use this structure:

```powershell
# Request body structure
$body = @{
    data = @{
        type = "workspaces"           # Resource type
        attributes = @{ name = "..." } # Resource properties
        relationships = @{             # Related resources (optional)
            organization = @{ data = @{ type = "organizations", id = "org-id" } }
        }
    }
} | ConvertTo-Json -Depth 10  # CRITICAL: Use sufficient depth for nested objects
```

### Generic API Access

For endpoints without dedicated functions, use `Invoke-TfcApi`:

```powershell
# GET request
$result = Invoke-TfcApi -Uri "/organizations" -Method GET

# POST with body
$body = @{ data = @{ ... } } | ConvertTo-Json -Depth 10
Invoke-TfcApi -Uri "/workspaces/ws-123/actions/lock" -Method POST -Body $body

# Automatic pagination
Invoke-TfcApi -Uri "/workspaces" -Method GET -AllPages
```

## File Organization Conventions

- **Core functions**: 50-100 lines with comprehensive help blocks
- **Private functions**: Prefixed with script scope, placed in `#region Private Functions`
- **Public functions**: Exported in manifest, placed in `#region Public Functions`
- **Copyright headers**: All files include MIT License copyright (Seth T. Bacon, 2025)

## Integration Points

**Get-Started.ps1**: Interactive demonstration script showing module capabilities:
1. Authentication verification
2. Organization enumeration
3. Workspace listing (first 5 per org)
4. Variable set discovery

**Usage Pattern**: Run `./Get-Started.ps1` to validate module installation and API connectivity before integration.

## Security & Credentials

- **NEVER** hardcode tokens in scripts
- Use `SecureString` for token storage: `ConvertTo-SecureString $token -AsPlainText -Force`
- Validate workspace IDs with regex: `^ws-[a-zA-Z0-9]+$`
- Support `-WhatIf` and `-Confirm` parameters for destructive operations (in Extended module)

## Module Versioning

Version follows Semantic Versioning (Major.Minor.Patch) in manifest:

- **Major**: Breaking API changes, parameter renames
- **Minor**: New functions, backward-compatible features
- **Patch**: Bug fixes, documentation updates

**Version History**:
- **1.0.0** (October 17, 2025): Phase 1 & 2 complete (108 functions, 92 tests, ~43% API coverage)
- **0.5.0** (August 2025): Initial release with 61 core functions

## Phase 1 & 2 Implementation Patterns (NEW)

### Run Triggers & Run Tasks
Enable workspace orchestration and custom integrations:

```powershell
# Run Triggers - Workspace dependencies
Get-TfcRunTrigger -WorkspaceId "ws-123"
New-TfcRunTrigger -WorkspaceId "ws-123" -SourceableId "ws-source-456"
Remove-TfcRunTrigger -RunTriggerId "rt-abc123"

# Run Tasks - Custom validation/integrations
Get-TfcRunTask -OrganizationName "my-org"
New-TfcRunTask -OrganizationName "my-org" -Name "security-scan" -Url "https://scanner.example.com" -Category "task"
Add-TfcWorkspaceRunTask -WorkspaceId "ws-123" -RunTaskId "task-abc" -EnforcementLevel "advisory" -Stage "post_plan"
```

**Key Patterns**:
- Run Triggers create workspace dependencies (source workspace → target workspace)
- Run Tasks integrate external systems with enforcement levels: `advisory`, `mandatory`
- Workspace Run Tasks attach tasks to specific workspaces with stage control

### Notification Configurations
Enable alerting and monitoring integrations:

```powershell
# Create Slack notification
New-TfcNotificationConfiguration -WorkspaceId "ws-123" `
    -Name "slack-alerts" `
    -DestinationType "slack" `
    -Url "https://hooks.slack.com/services/XXX/YYY/ZZZ" `
    -Triggers @("run:created", "run:completed", "run:errored")

# Test notification delivery
Test-TfcNotificationConfiguration -NotificationConfigurationId "nc-123"
```

**Supported Destination Types**: `email`, `generic`, `microsoft-teams`, `slack`
**Common Triggers**: `run:created`, `run:planning`, `run:needs_attention`, `run:applying`, `run:completed`, `run:errored`

### Enhanced Plans & Applies
Access detailed plan/apply data for analysis:

```powershell
# Get plan JSON for programmatic analysis
$planJson = Get-TfcPlanJson -PlanId "plan-abc123"
$planJson.resource_changes | Where-Object { $_.change.actions -contains "create" }

# Get plan/apply logs
Get-TfcPlanLog -PlanId "plan-abc123" -OutputPath "./plan.log"
Get-TfcApplyLog -ApplyId "apply-abc123" -OutputPath "./apply.log"

# Export plan for compliance
New-TfcPlanExport -PlanId "plan-abc123" -DataType "sentinel-mock-bundle-v0"
$export = Get-TfcPlanExport -PlanExportId "planexp-abc123"
Invoke-WebRequest -Uri $export.data.attributes.'download-url' -OutFile "./plan-export.tar.gz"
```

**Plan Export Types**: `sentinel-mock-bundle-v0` (Sentinel testing), `plan-json-v1` (JSON format)

### Workspace Team Access (RBAC)
Manage team permissions at workspace level:

```powershell
# Grant team access
Add-TfcWorkspaceTeamAccess -TeamId "team-123" -WorkspaceId "ws-456" -Access "write"

# Access levels: read, plan, write, admin
# Or use custom permissions
Add-TfcWorkspaceTeamAccess -TeamId "team-123" -WorkspaceId "ws-456" `
    -Runs "apply" -Variables "write" -StateVersions "read" -SentinelMocks "read"

# Update permissions
Update-TfcWorkspaceTeamAccess -TeamAccessId "tws-abc123" -Access "admin"

# Remove access
Remove-TfcWorkspaceTeamAccess -TeamAccessId "tws-abc123"
```

**Built-in Access Levels**: `read`, `plan`, `write`, `admin`, `custom`
**Custom Permission Categories**: `runs`, `variables`, `state-versions`, `sentinel-mocks`, `workspace-locking`, `run-tasks`

### Agent Pools & Tokens
Manage self-hosted Terraform agents:

```powershell
# Agent Pool lifecycle
Get-TfcAgentPool -OrganizationName "my-org"
$pool = New-TfcAgentPool -OrganizationName "my-org" -Name "production-agents"
Update-TfcAgentPool -AgentPoolId $pool.data.id -Name "prod-agents-v2"

# List agents in pool
Get-TfcAgent -AgentPoolId $pool.data.id

# Generate agent token
$token = New-TfcAgentToken -AgentPoolId $pool.data.id -Description "k8s-agent-1"
# Save token.data.attributes.token securely - shown only once!
```

### SSH Keys
Manage SSH keys for private module repositories:

```powershell
# Add SSH key
$sshKey = New-TfcSSHKey -OrganizationName "my-org" `
    -Name "github-deploy-key" `
    -Value (Get-Content ~/.ssh/id_rsa -Raw)

# Assign to workspace
Set-TfcWorkspaceSSHKey -WorkspaceId "ws-123" -SshKeyId $sshKey.data.id

# Update/Remove
Update-TfcSSHKey -SshKeyId $sshKey.data.id -Name "github-deploy-key-v2"
Remove-TfcSSHKey -SshKeyId $sshKey.data.id
```

### Token Management
Create API tokens for automation:

```powershell
# Team token (shared by team members)
$teamToken = New-TfcTeamToken -TeamId "team-123"
# Token in: $teamToken.data.attributes.token

# Organization token (org-wide automation)
$orgToken = New-TfcOrganizationToken -OrganizationName "my-org"

# User token (individual automation)
$userToken = New-TfcUserToken -Description "CI/CD pipeline"

# List user tokens
Get-TfcUserToken

# Remove tokens
Remove-TfcTeamToken -TeamId "team-123"
Remove-TfcOrganizationToken -OrganizationName "my-org"
Remove-TfcUserToken -UserTokenId "ut-123"
```

**Token Hierarchy**: User tokens < Team tokens < Organization tokens (increasing privilege scope)

### Workspace Resources & Cost Estimates
Track resources and costs:

```powershell
# List all resources in workspace
$resources = Get-TfcWorkspaceResource -WorkspaceId "ws-123"
$resources.data | Select-Object -ExpandProperty attributes |
    Select-Object name, 'resource-type', provider

# Get cost estimate for run
$costEstimate = Get-TfcCostEstimate -CostEstimateId "ce-abc123"
$costEstimate.data.attributes.'proposed-monthly-cost'  # Cost in USD
```

## API Coverage Status

**Current Coverage** (v1.0.0): ~59% function coverage (147/250 functions)

**Implemented Categories**:
- **Core**: Account, Organizations, Projects, Workspaces, Variables, Variable Sets, Configuration, State, Runs, Plans, Applies, Teams, OAuth, Registry
- **Workflow**: Run Triggers, Run Tasks, Notifications, Plan Exports, Workspace Team Access
- **Enterprise**: Agent Pools, Agent Tokens, SSH Keys, Token Management, Resources/Cost/VCS
- **Policy**: Policies, Policy Sets, Policy Checks, Audit Trails, Comments
- **RBAC**: Variable Set Variables, Team Membership, Project Team Access, Organization Memberships, Organization Tags

**Future Enhancements**:
- Advanced State Management (~25 functions)
- Admin & Operations (~25 functions)
- Integrations & Webhooks (~18 functions)

See **API-COVERAGE-ANALYSIS-UPDATED.md** for complete roadmap.
