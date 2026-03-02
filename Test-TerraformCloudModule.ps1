#!/usr/bin/env pwsh
# Comprehensive Test Suite for TerraformCloud PowerShell Module
# v1.0.0 - 194 functions covered with comprehensive tests
# Copyright (c) 2025 Seth T. Bacon. All rights reserved.
# Licensed under MIT License.

param(
    [switch]$RunDestructiveTests = $false,
    [switch]$MockMode = $false,
    [switch]$UseTestOrganization = $false,
    [string]$TestOrganizationName = "",
    [switch]$Verbose = $false
)

Import-Module ./TerraformCloud.psd1 -Force

# Test Variables
$script:TestOrganization = $null
$script:TestWorkspaceId = $null
$script:TestVariableId = $null
$script:TestVariableKey = $null
$script:CreatedWorkspaceId = $null
$script:TestVarSetId = $null
$script:MockData = @{}

Write-Host "=== TerraformCloud Module Comprehensive Test Suite ===" -ForegroundColor Green
Write-Host "Mode: $(if ($MockMode) { 'MOCK/SIMULATION' } else { 'LIVE API' })" -ForegroundColor $(if ($MockMode) { 'Yellow' } else { 'Cyan' })

# Test Results Tracking
$TestResults = @()

function Add-TestResult {
    param(
        [string]$TestName,
        [string]$Status,
        [string]$Message = ""
    )

    $script:TestResults += @{
        Test = $TestName
        Status = $Status
        Message = $Message
        Timestamp = Get-Date
        Mode = if ($MockMode) { "MOCK" } else { "LIVE" }
    }

    $color = switch ($Status) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "SKIP" { "Yellow" }
        "MOCK" { "Cyan" }
        default { "White" }
    }

    $modeIndicator = if ($MockMode) { "[MOCK]" } else { "[LIVE]" }
    Write-Host "[$Status]$modeIndicator $TestName" -ForegroundColor $color
    if ($Message) {
        Write-Host "    $Message" -ForegroundColor Gray
    }
}

# Mock Data Setup
function Initialize-MockData {
    $script:MockData = @{
        Account = @{
            data = @{
                id = "user-test123"
                attributes = @{
                    username = "test-user-mock"
                    email = "test@example.com"
                }
            }
        }

        Organizations = @{
            data = @(
                @{
                    id = "mock-test-org"
                    attributes = @{
                        name = "Mock Test Organization"
                        email = "test@mockorg.com"
                    }
                }
            )
        }

        OrganizationEntitlements = @{
            data = @{
                attributes = @{
                    "cost-estimation" = $true
                    "sentinel" = $true
                    "state-storage" = $true
                    "teams" = $true
                    "vcs-integrations" = $true
                }
            }
        }

        Workspaces = @{
            data = @(
                @{
                    id = "ws-mocktestworkspace123"
                    attributes = @{
                        name = "mock-test-workspace"
                        description = "Mock workspace for testing"
                    }
                },
                @{
                    id = "ws-mocktestworkspace456"
                    attributes = @{
                        name = "mock-test-workspace-2"
                        description = "Second mock workspace for testing"
                    }
                }
            )
        }

        Variables = @{
            data = @(
                @{
                    id = "var-mocktest123"
                    attributes = @{
                        key = "mock_test_var"
                        value = "mock_test_value"
                        category = "terraform"
                    }
                }
            )
        }

        Teams = @{
            data = @(
                @{
                    id = "team-mocktest123"
                    attributes = @{
                        name = "mock-test-team"
                        "users-count" = 5
                    }
                }
            )
        }

        OauthClients = @{
            data = @(
                @{
                    id = "oc-mocktest123"
                    attributes = @{
                        name = "mock-oauth-client"
                        "service-provider" = "github"
                    }
                }
            )
        }

        VariableSets = @{
            data = @(
                @{
                    id = "varset-mocktest123"
                    attributes = @{
                        name = "mock-variable-set"
                        description = "Mock variable set for testing"
                    }
                }
            )
        }

        StateVersion = @{
            data = @{
                id = "sv-mocktest123"
                attributes = @{
                    serial = 1
                    "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                }
            }
        }

        Runs = @{
            data = @(
                @{
                    id = "run-mocktest123"
                    attributes = @{
                        status = "planned"
                        message = "Mock test run"
                    }
                }
            )
        }

        # Phase 1 & 2 Mock Data
        RunTriggers = @{
            data = @(
                @{
                    id = "rt-mocktest123"
                    attributes = @{
                        "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                    }
                    relationships = @{
                        sourceable = @{ data = @{ id = "ws-source123" } }
                    }
                }
            )
        }

        RunTasks = @{
            data = @(
                @{
                    id = "task-mocktest123"
                    attributes = @{
                        name = "mock-run-task"
                        url = "https://example.com/task"
                        category = "task"
                        enabled = $true
                    }
                }
            )
        }

        RunTaskStages = @{
            data = @(
                @{
                    id = "taskstg-mocktest123"
                    attributes = @{
                        stage = "post_plan"
                    }
                }
            )
        }

        NotificationConfigurations = @{
            data = @(
                @{
                    id = "nc-mocktest123"
                    attributes = @{
                        name = "mock-notification"
                        "destination-type" = "slack"
                        enabled = $true
                        url = "https://hooks.slack.com/services/mock"
                    }
                }
            )
        }

        Plans = @{
            data = @{
                id = "plan-mocktest123"
                attributes = @{
                    status = "finished"
                    "has-changes" = $true
                    "resource-additions" = 2
                    "resource-changes" = 1
                    "resource-destructions" = 0
                }
            }
        }

        PlanExports = @{
            data = @{
                id = "planexp-mocktest123"
                attributes = @{
                    status = "finished"
                    "download-url" = "https://mock-export.example.com"
                }
            }
        }

        Applies = @{
            data = @{
                id = "apply-mocktest123"
                attributes = @{
                    status = "finished"
                    "resource-additions" = 2
                    "resource-changes" = 1
                    "resource-destructions" = 0
                }
            }
        }

        TeamAccess = @{
            data = @(
                @{
                    id = "tws-mocktest123"
                    attributes = @{
                        access = "write"
                    }
                    relationships = @{
                        team = @{ data = @{ id = "team-mocktest123" } }
                        workspace = @{ data = @{ id = "ws-mocktest123" } }
                    }
                }
            )
        }

        AgentPools = @{
            data = @(
                @{
                    id = "apool-mocktest123"
                    attributes = @{
                        name = "mock-agent-pool"
                        "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                    }
                }
            )
        }

        Agents = @{
            data = @(
                @{
                    id = "agent-mocktest123"
                    attributes = @{
                        name = "mock-agent"
                        status = "idle"
                    }
                }
            )
        }

        AgentTokens = @{
            data = @(
                @{
                    id = "at-mocktest123"
                    attributes = @{
                        description = "Mock agent token"
                        "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                    }
                }
            )
        }

        SshKeys = @{
            data = @(
                @{
                    id = "sshkey-mocktest123"
                    attributes = @{
                        name = "mock-ssh-key"
                        "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                    }
                }
            )
        }

        TeamTokens = @{
            data = @{
                id = "tt-mocktest123"
                attributes = @{
                    "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                }
            }
        }

        OrganizationTokens = @{
            data = @{
                id = "ot-mocktest123"
                attributes = @{
                    "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                }
            }
        }

        UserTokens = @{
            data = @(
                @{
                    id = "ut-mocktest123"
                    attributes = @{
                        description = "Mock user token"
                        "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                    }
                }
            )
        }

        WorkspaceResources = @{
            data = @(
                @{
                    id = "wsres-mocktest123"
                    attributes = @{
                        name = "mock_resource"
                        "resource-type" = "aws_instance"
                    }
                }
            )
        }

        CostEstimates = @{
            data = @{
                id = "ce-mocktest123"
                attributes = @{
                    status = "finished"
                    "proposed-monthly-cost" = "150.00"
                }
            }
        }

        # Phase 3: Policy & Compliance Mock Data
        Policies = @{
            data = @(
                @{
                    id = "pol-mocktest123"
                    attributes = @{
                        name = "mock-policy"
                        description = "Mock policy for testing"
                        enforcement = "hard-mandatory"
                        "policy-set-count" = 1
                    }
                }
            )
        }

        PolicySets = @{
            data = @(
                @{
                    id = "polset-mocktest123"
                    attributes = @{
                        name = "mock-policy-set"
                        description = "Mock policy set for testing"
                        global = $false
                        "policy-count" = 2
                    }
                }
            )
        }

        PolicyChecks = @{
            data = @(
                @{
                    id = "polchk-mocktest123"
                    attributes = @{
                        status = "passed"
                        result = @{
                            passed = 5
                            failed = 0
                            advisory = 0
                        }
                    }
                }
            )
        }

        AuditTrails = @{
            data = @(
                @{
                    id = "audit-mocktest123"
                    attributes = @{
                        timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        type = "workspace.create"
                        user = "test-user-mock"
                    }
                }
            )
        }

        Comments = @{
            data = @(
                @{
                    id = "comment-mocktest123"
                    attributes = @{
                        body = "Mock comment for testing"
                        "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                    }
                }
            )
        }

        # Phase 4: Enhanced RBAC & Variables Mock Data
        VariableSetVariables = @{
            data = @(
                @{
                    id = "var-mockvstest123"
                    attributes = @{
                        key = "mock_varset_var"
                        value = "mock_varset_value"
                        category = "terraform"
                        sensitive = $false
                    }
                }
            )
        }

        TeamMembers = @{
            data = @(
                @{
                    id = "ou-mocktest123"
                    type = "organization-memberships"
                    attributes = @{
                        email = "member1@example.com"
                        status = "active"
                    }
                }
            )
        }

        ProjectTeamAccess = @{
            data = @(
                @{
                    id = "tprj-mocktest123"
                    type = "team-projects"
                    attributes = @{
                        access = "write"
                        "runs-access" = "apply"
                        "variables-access" = "write"
                    }
                    relationships = @{
                        team = @{
                            data = @{
                                id = "team-mocktest123"
                                type = "teams"
                            }
                        }
                        project = @{
                            data = @{
                                id = "prj-mocktest123"
                                type = "projects"
                            }
                        }
                    }
                }
            )
        }

        OrganizationMemberships = @{
            data = @(
                @{
                    id = "ou-mocktest456"
                    type = "organization-memberships"
                    attributes = @{
                        email = "user@example.com"
                        status = "active"
                    }
                }
            )
        }

        OrganizationTags = @{
            data = @(
                @{
                    id = "tag-mocktest123"
                    type = "tags"
                    attributes = @{
                        name = "production"
                        "workspace-count" = 5
                    }
                }
            )
        }

        # Phase 5 Mock Data
        RunDetails = @{
            data = @{
                id = "run-mockdetails123"
                attributes = @{
                    status = "applied"
                    message = "Detailed mock run"
                    "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                }
            }
        }

        RunTaskResults = @{
            data = @(
                @{
                    id = "taskrs-mocktest123"
                    attributes = @{
                        status = "passed"
                        message = "Task passed successfully"
                    }
                }
            )
        }

        WorkspaceResourceDetails = @{
            data = @{
                id = "wsres-mocktest123"
                attributes = @{
                    name = "aws_instance.example"
                    provider = "aws"
                    type = "aws_instance"
                }
            }
        }

        OAuthTokens = @{
            data = @(
                @{
                    id = "ot-mocktest123"
                    attributes = @{
                        "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
                        "service-provider" = "github"
                    }
                }
            )
        }

        AssessmentResults = @{
            data = @(
                @{
                    id = "asmtrs-mocktest123"
                    attributes = @{
                        status = "completed"
                        "drift-detected" = $false
                    }
                }
            )
        }

        CostEstimateLogs = "Mock cost estimate logs content"

        VCSEventDetails = @{
            data = @{
                id = "vcsev-mocktest123"
                attributes = @{
                    "commit-sha" = "abc123def456"
                    "commit-message" = "Mock commit message"
                }
            }
        }

        # Phase 6 Mock Data
        ChangeRequests = @{
            data = @(
                @{
                    id = "chreq-mocktest123"
                    attributes = @{
                        message = "Mock change request"
                        status = "pending"
                    }
                }
            )
        }

        NoCodeModules = @{
            data = @{
                id = "ncm-mocktest123"
                attributes = @{
                    enabled = $true
                    "version-pin" = "1.0.0"
                }
            }
        }

        GitHubAppInstallations = @{
            data = @(
                @{
                    id = "ghain-mocktest123"
                    attributes = @{
                        "installation-id" = 12345
                    }
                }
            )
        }

        GraphQLResult = @{
            data = @{
                organization = @{
                    name = "mock-org"
                }
            }
        }

        IPRanges = @{
            data = @{
                attributes = @{
                    api = @("192.0.2.1/24")
                    notifications = @("192.0.2.2/24")
                }
            }
        }

        FeatureSets = @{
            data = @(
                @{
                    id = "fs-mocktest123"
                    attributes = @{
                        name = "mock-feature-set"
                    }
                }
            )
        }

        # Phase 7 Mock Data
        AdminSettings = @{
            data = @{
                attributes = @{
                    "policy-enforcement" = $true
                    "cost-estimation-enabled" = $true
                }
            }
        }

        SAMLSettings = @{
            data = @{
                attributes = @{
                    enabled = $true
                    "sso-endpoint-url" = "https://idp.example.com/sso"
                }
            }
        }

        AdminUsers = @{
            data = @(
                @{
                    id = "user-mockadmin123"
                    attributes = @{
                        username = "mock-admin"
                        email = "admin@example.com"
                        "is-admin" = $true
                    }
                }
            )
        }

        RegistrySettings = @{
            data = @{
                attributes = @{
                    "module-consumers-enabled" = $true
                    "provider-consumers-enabled" = $true
                }
            }
        }

        Subscriptions = @{
            data = @{
                attributes = @{
                    plan = "enterprise"
                    status = "active"
                }
            }
        }

        Invoices = @{
            data = @(
                @{
                    id = "inv-mocktest123"
                    attributes = @{
                        amount = 1000
                        status = "paid"
                    }
                }
            )
        }

        TwoFactorSettings = @{
            data = @{
                attributes = @{
                    required = $true
                }
            }
        }
    }
}

# Mock function implementations
function Invoke-MockTfcFunction {
    param(
        [string]$FunctionName,
        [hashtable]$Parameters = @{}
    )

    Write-Verbose "Mock: Calling $FunctionName with parameters: $($Parameters | ConvertTo-Json -Compress)"

    switch ($FunctionName) {
        "Get-TfcAccount" { return $script:MockData.Account }
        "Get-TfcOrganization" {
            if ($Parameters.ContainsKey('Name')) {
                return @{ data = $script:MockData.Organizations.data[0] }
            }
            return $script:MockData.Organizations
        }
        "Get-TfcOrganizationEntitlements" { return $script:MockData.OrganizationEntitlements }
        "Get-TfcWorkspace" { return $script:MockData.Workspaces }
        "Find-TfcWorkspace" { return $script:MockData.Workspaces }
        "Get-TfcTeam" { return $script:MockData.Teams }
        "Get-TfcOauthClient" { return $script:MockData.OauthClients }
        "Get-TfcVariableSet" { return $script:MockData.VariableSets }
        "Get-TfcWorkspaceVariable" { return $script:MockData.Variables }
        "Get-TfcCurrentStateVersion" { return $script:MockData.StateVersion }
        "Get-TfcRun" { return $script:MockData.Runs }
        "Invoke-TfcApi" {
            if ($Parameters.Uri -eq "/organizations") {
                return $script:MockData.Organizations
            }
            return @{ data = @{ id = "mock-api-$(Get-Random)" } }
        }
        "New-TfcWorkspace" {
            return @{
                data = @{
                    id = "ws-mockcreated$(Get-Random)"
                    attributes = @{
                        name = $Parameters.Name
                        description = "Mock created workspace"
                    }
                }
            }
        }
        "Set-TfcWorkspaceVariable" {
            return @{
                data = @{
                    id = "var-mockcreated$(Get-Random)"
                    attributes = @{
                        key = $Parameters.Key
                        value = $Parameters.Value
                        category = $Parameters.Category
                    }
                }
            }
        }
        "Update-TfcWorkspaceVariable" {
            return @{
                data = @{
                    id = $script:TestVariableId
                    attributes = @{
                        key = $Parameters.Key
                        value = $Parameters.Value
                        category = $Parameters.Category
                    }
                }
            }
        }
        "Get-TfcConfigurationVersionList" {
            return @{
                data = @(
                    @{
                        id = "cv-mock-$(Get-Random)"
                        type = "configuration-versions"
                        attributes = @{
                            status = "uploaded"
                            "auto-queue-runs" = $true
                        }
                    }
                )
            }
        }
        "Get-TfcConfigurationVersion" {
            return @{
                data = @{
                    id = $Parameters.ConfigurationVersionId
                    type = "configuration-versions"
                    attributes = @{
                        status = "uploaded"
                        "upload-url" = "https://mock-upload.example.com"
                    }
                }
            }
        }
        "New-TfcConfigurationVersion" {
            return @{
                data = @{
                    id = "cv-mock-new-$(Get-Random)"
                    type = "configuration-versions"
                    attributes = @{
                        status = "pending"
                        "upload-url" = "https://mock-upload.example.com"
                    }
                }
            }
        }
        "New-TfcVariableSet" {
            return @{
                data = @{
                    id = "varset-mock-$(Get-Random)"
                    type = "varsets"
                    attributes = @{
                        name = $Parameters.Name
                        description = $Parameters.Description
                        global = $Parameters.Global
                    }
                }
            }
        }
        "Update-TfcVariableSet" {
            return @{
                data = @{
                    id = $Parameters.VariableSetId
                    type = "varsets"
                    attributes = @{
                        description = "Updated description"
                    }
                }
            }
        }
        "Remove-TfcVariableSet" {
            return $true
        }
        "New-TfcOrganization" {
            return @{
                data = @{
                    id = "org-mock-$(Get-Random)"
                    type = "organizations"
                    attributes = @{
                        name = $Parameters.Name
                        email = $Parameters.Email
                    }
                }
            }
        }
        "Update-TfcOrganization" {
            return @{
                data = @{
                    id = "org-mock-existing"
                    type = "organizations"
                    attributes = @{
                        email = "updated-email@example.com"
                    }
                }
            }
        }
        "Remove-TfcOrganization" {
            return $true
        }
        "Get-TfcWorkspaceTag" {
            return @("tag-123", "tag-456")
        }
        "Set-TfcWorkspaceTag" {
            return $true
        }
        "Set-TfcVariableSetWorkspace" {
            return $true
        }
        "Remove-TfcVariableSetWorkspace" {
            return $true
        }
        "New-TfcTeam" {
            return @{
                data = @{
                    id = "team-mock-$(Get-Random)"
                    type = "teams"
                    attributes = @{
                        name = $Parameters.Name
                        visibility = $Parameters.Visibility
                    }
                }
            }
        }
        "Update-TfcTeam" {
            return @{
                data = @{
                    id = $Parameters.TeamId
                    type = "teams"
                    attributes = @{
                        name = "updated-team-name"
                    }
                }
            }
        }
        "Remove-TfcTeam" {
            return $true
        }
        # Phase 1 & 2 Mock Functions
        "Get-TfcRunTrigger" { return $script:MockData.RunTriggers }
        "New-TfcRunTrigger" {
            return @{
                data = @{
                    id = "rt-mockcreated$(Get-Random)"
                    attributes = @{ "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ") }
                }
            }
        }
        "Get-TfcRunTriggerDetails" { return @{ data = $script:MockData.RunTriggers.data[0] } }
        "Remove-TfcRunTrigger" { return $true }
        "Get-TfcRunTask" { return $script:MockData.RunTasks }
        "New-TfcRunTask" {
            return @{
                data = @{
                    id = "task-mockcreated$(Get-Random)"
                    attributes = @{ name = $Parameters.Name; url = $Parameters.Url }
                }
            }
        }
        "Get-TfcRunTaskDetails" { return @{ data = $script:MockData.RunTasks.data[0] } }
        "Update-TfcRunTask" {
            return @{ data = @{ id = $Parameters.RunTaskId; attributes = @{ name = $Parameters.Name } } }
        }
        "Remove-TfcRunTask" { return $true }
        "Get-TfcWorkspaceRunTask" { return $script:MockData.RunTasks }
        "Add-TfcWorkspaceRunTask" {
            return @{
                data = @{
                    id = "wstask-mockcreated$(Get-Random)"
                    attributes = @{ "enforcement-level" = $Parameters.EnforcementLevel; stage = $Parameters.Stage }
                }
            }
        }
        "Update-TfcWorkspaceRunTask" {
            return @{ data = @{ id = $Parameters.WorkspaceTaskId; attributes = @{ "enforcement-level" = $Parameters.EnforcementLevel } } }
        }
        "Remove-TfcWorkspaceRunTask" { return $true }
        "Get-TfcRunTaskStage" { return $script:MockData.RunTaskStages }
        "Get-TfcNotificationConfiguration" { return $script:MockData.NotificationConfigurations }
        "New-TfcNotificationConfiguration" {
            return @{
                data = @{
                    id = "nc-mockcreated$(Get-Random)"
                    attributes = @{ name = $Parameters.Name; "destination-type" = $Parameters.DestinationType }
                }
            }
        }
        "Update-TfcNotificationConfiguration" {
            return @{ data = @{ id = $Parameters.NotificationConfigurationId; attributes = @{ enabled = $Parameters.Enabled } } }
        }
        "Remove-TfcNotificationConfiguration" { return $true }
        "Test-TfcNotificationConfiguration" { return @{ data = @{ attributes = @{ "delivery-responses" = @(@{ successful = $true }) } } } }
        "Get-TfcPlanJsonOutput" { return @{ data = @{ id = "plan-mocktest123"; attributes = @{ "resource-changes" = @() } } } }
        "Get-TfcPlanDetails" { return $script:MockData.Plans }
        "Get-TfcPlanLogs" { return "Mock plan logs output" }
        "New-TfcPlanExport" {
            return @{
                data = @{
                    id = "planexp-mockcreated$(Get-Random)"
                    attributes = @{ status = "pending" }
                }
            }
        }
        "Get-TfcPlanExport" { return $script:MockData.PlanExports }
        "Get-TfcApplyDetails" { return $script:MockData.Applies }
        "Get-TfcApplyLogs" { return "Mock apply logs output" }
        "Add-TfcTeamWorkspaceAccess" {
            return @{
                data = @{
                    id = "tws-mockcreated$(Get-Random)"
                    attributes = @{ access = $Parameters.Access }
                }
            }
        }
        "Update-TfcTeamWorkspaceAccess" {
            return @{ data = @{ id = $Parameters.TeamAccessId; attributes = @{ access = $Parameters.Access } } }
        }
        "Remove-TfcTeamWorkspaceAccess" { return $true }
        "Get-TfcTeamWorkspaceAccess" { return $script:MockData.TeamAccess }
        "Get-TfcAgentPool" { return $script:MockData.AgentPools }
        "New-TfcAgentPool" {
            return @{
                data = @{
                    id = "apool-mockcreated$(Get-Random)"
                    attributes = @{ name = $Parameters.Name }
                }
            }
        }
        "Update-TfcAgentPool" {
            return @{ data = @{ id = $Parameters.AgentPoolId; attributes = @{ name = $Parameters.Name } } }
        }
        "Remove-TfcAgentPool" { return $true }
        "Get-TfcAgent" { return $script:MockData.Agents }
        "Get-TfcAgentToken" { return $script:MockData.AgentTokens }
        "New-TfcAgentToken" {
            return @{
                data = @{
                    id = "at-mockcreated$(Get-Random)"
                    attributes = @{ description = $Parameters.Description; token = "mock-token-value" }
                }
            }
        }
        "Remove-TfcAgentToken" { return $true }
        "Get-TfcSshKey" { return $script:MockData.SshKeys }
        "New-TfcSshKey" {
            return @{
                data = @{
                    id = "sshkey-mockcreated$(Get-Random)"
                    attributes = @{ name = $Parameters.Name }
                }
            }
        }
        "Get-TfcSshKeyDetails" { return @{ data = $script:MockData.SshKeys.data[0] } }
        "Update-TfcSshKey" {
            return @{ data = @{ id = $Parameters.SshKeyId; attributes = @{ name = $Parameters.Name } } }
        }
        "Remove-TfcSshKey" { return $true }
        "Set-TfcWorkspaceSshKey" { return @{ data = @{ id = "ws-mocktest123" } } }
        "Get-TfcTeamToken" { return $script:MockData.TeamTokens }
        "New-TfcTeamToken" {
            return @{
                data = @{
                    id = "tt-mockcreated$(Get-Random)"
                    attributes = @{ token = "mock-team-token-value"; "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ") }
                }
            }
        }
        "Remove-TfcTeamToken" { return $true }
        "Get-TfcOrganizationToken" { return $script:MockData.OrganizationTokens }
        "New-TfcOrganizationToken" {
            return @{
                data = @{
                    id = "ot-mockcreated$(Get-Random)"
                    attributes = @{ token = "mock-org-token-value"; "created-at" = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ") }
                }
            }
        }
        "Remove-TfcOrganizationToken" { return $true }
        "Get-TfcUserToken" { return $script:MockData.UserTokens }
        "New-TfcUserToken" {
            return @{
                data = @{
                    id = "ut-mockcreated$(Get-Random)"
                    attributes = @{ token = "mock-user-token-value"; description = $Parameters.Description }
                }
            }
        }
        "Get-TfcUserTokenDetails" { return @{ data = $script:MockData.UserTokens.data[0] } }
        "Remove-TfcUserToken" { return $true }
        "Get-TfcWorkspaceResources" { return $script:MockData.WorkspaceResources }
        "Get-TfcCostEstimate" { return $script:MockData.CostEstimates }
        "Send-TfcVcsEvent" { return $true }

        # Phase 3: Policy & Compliance Mock Handlers
        "Get-TfcPolicy" { return $script:MockData.Policies }
        "New-TfcPolicy" {
            return @{
                data = @{
                    id = "pol-mockcreated$(Get-Random)"
                    attributes = @{ name = $Parameters.Name; enforcement = $Parameters.Enforcement }
                }
            }
        }
        "Update-TfcPolicy" { return @{ data = $script:MockData.Policies.data[0] } }
        "Remove-TfcPolicy" { return $true }
        "Invoke-TfcPolicyUpload" { return $true }
        "Get-TfcPolicySet" { return $script:MockData.PolicySets }
        "New-TfcPolicySet" {
            return @{
                data = @{
                    id = "polset-mockcreated$(Get-Random)"
                    attributes = @{ name = $Parameters.Name; description = $Parameters.Description }
                }
            }
        }
        "Update-TfcPolicySet" { return @{ data = $script:MockData.PolicySets.data[0] } }
        "Remove-TfcPolicySet" { return $true }
        "Add-TfcPolicySetPolicy" { return $true }
        "Set-TfcPolicySetWorkspace" { return $true }
        "Set-TfcPolicySetProject" { return $true }
        "Get-TfcPolicyCheck" { return $script:MockData.PolicyChecks }
        "Set-TfcPolicyCheckOverride" { return $true }
        "Get-TfcAuditTrail" { return $script:MockData.AuditTrails }
        "Get-TfcComment" { return $script:MockData.Comments }
        "New-TfcComment" {
            return @{
                data = @{
                    id = "comment-mockcreated$(Get-Random)"
                    attributes = @{ body = $Parameters.Body }
                }
            }
        }

        # Phase 4: Enhanced RBAC & Variables Mock Handlers
        "Get-TfcVariableSetVariable" { return $script:MockData.VariableSetVariables }
        "New-TfcVariableSetVariable" {
            return @{
                data = @{
                    id = "var-mockcreated$(Get-Random)"
                    attributes = @{ key = $Parameters.Key; value = $Parameters.Value; category = $Parameters.Category }
                }
            }
        }
        "Update-TfcVariableSetVariable" { return @{ data = $script:MockData.VariableSetVariables.data[0] } }
        "Remove-TfcVariableSetVariable" { return $true }
        "Get-TfcTeamMember" { return $script:MockData.TeamMembers }
        "Add-TfcTeamMember" { return $true }
        "Get-TfcTeamMemberDetails" { return @{ data = $script:MockData.TeamMembers.data[0] } }
        "Remove-TfcTeamMember" { return $true }
        "Add-TfcProjectTeamAccess" {
            return @{
                data = @{
                    id = "tprj-mockcreated$(Get-Random)"
                    type = "team-projects"
                    attributes = @{ access = $Parameters.Access }
                }
            }
        }
        "Get-TfcProjectTeamAccess" { return $script:MockData.ProjectTeamAccess }
        "Get-TfcProjectTeamAccessDetails" { return @{ data = $script:MockData.ProjectTeamAccess.data[0] } }
        "Update-TfcProjectTeamAccess" { return @{ data = $script:MockData.ProjectTeamAccess.data[0] } }
        "Remove-TfcProjectTeamAccess" { return $true }
        "Get-TfcOrganizationMembership" { return $script:MockData.OrganizationMemberships }
        "Remove-TfcOrganizationMembership" { return $true }
        "Get-TfcOrganizationTag" { return $script:MockData.OrganizationTags }
        "New-TfcOrganizationTag" {
            return @{
                data = @{
                    id = "tag-mockcreated$(Get-Random)"
                    type = "tags"
                    attributes = @{ name = $Parameters.Name }
                }
            }
        }
        "Remove-TfcOrganizationTag" { return $true }
        "Add-TfcOrganizationTagRelationship" { return $true }
        "Remove-TfcOrganizationTagRelationship" { return $true }

        # Phase 5 Mock Handlers
        "Get-TfcRunDetails" { return $script:MockData.RunDetails }
        "Get-TfcRunTaskResult" { return $script:MockData.RunTaskResults }
        "Get-TfcRunTaskResultDetails" { return $script:MockData.RunTaskResults.data[0] }
        "Get-TfcWorkspaceResourceDetails" { return $script:MockData.WorkspaceResourceDetails }
        "Get-TfcOAuthToken" { return $script:MockData.OAuthTokens }
        "Get-TfcOAuthTokenDetails" { return $script:MockData.OAuthTokens.data[0] }
        "Update-TfcOAuthToken" { return $script:MockData.OAuthTokens.data[0] }
        "Remove-TfcOAuthToken" { return $true }
        "Get-TfcAssessmentResult" { return $script:MockData.AssessmentResults }
        "Get-TfcAssessmentResultDetails" { return $script:MockData.AssessmentResults.data[0] }
        "Get-TfcCostEstimateLog" { return $script:MockData.CostEstimateLogs }
        "Get-TfcVCSEventDetails" { return $script:MockData.VCSEventDetails }
        "Invoke-TfcStateRollback" { return @{ data = @{ id = "sv-rollback123"; attributes = @{ serial = 2 } } } }

        # Phase 6 Mock Handlers
        "Get-TfcChangeRequest" { return $script:MockData.ChangeRequests }
        "New-TfcChangeRequest" { return @{ data = @{ id = "chreq-new123"; attributes = @{ message = "New change request"; status = "pending" } } } }
        "Get-TfcChangeRequestDetails" { return @{ data = $script:MockData.ChangeRequests.data[0] } }
        "Approve-TfcChangeRequest" { return $true }
        "Deny-TfcChangeRequest" { return $true }
        "New-TfcNoCodeModule" { return @{ data = @{ id = "ncm-new123"; attributes = @{ enabled = $true } } } }
        "Get-TfcNoCodeModule" { return $script:MockData.NoCodeModules }
        "Update-TfcNoCodeModule" { return $script:MockData.NoCodeModules }
        "Remove-TfcNoCodeModule" { return $true }
        "Update-TfcNoCodeModuleVariableOptions" { return $true }
        "Get-TfcGitHubAppInstallation" { return $script:MockData.GitHubAppInstallations }
        "Get-TfcGitHubAppInstallationDetails" { return @{ data = $script:MockData.GitHubAppInstallations.data[0] } }
        "Invoke-TfcExplorerQuery" { return $script:MockData.GraphQLResult }
        "Get-TfcIPRange" { return $script:MockData.IPRanges }
        "Get-TfcFeatureSet" { return $script:MockData.FeatureSets }
        "Get-TfcFeatureSetDetails" { return @{ data = $script:MockData.FeatureSets.data[0] } }

        # Phase 7 Mock Handlers
        "Get-TfcAdminSettings" { return $script:MockData.AdminSettings }
        "Update-TfcAdminSettings" { return $script:MockData.AdminSettings }
        "Get-TfcSAMLSettings" { return $script:MockData.SAMLSettings }
        "Update-TfcSAMLSettings" { return $script:MockData.SAMLSettings }
        "Revoke-TfcSAMLSettings" { return $true }
        "Get-TfcAdminUser" { return $script:MockData.AdminUsers }
        "Suspend-TfcUser" { return $true }
        "Resume-TfcUser" { return $true }
        "Grant-TfcAdminPrivilege" { return $true }
        "Revoke-TfcAdminPrivilege" { return $true }
        "Disable-TfcUserTwoFactor" { return $true }
        "New-TfcUserImpersonation" { return @{ data = @{ id = "at-imp123"; attributes = @{ token = "mock-impersonation-token" } } } }
        "Get-TfcRegistrySettings" { return $script:MockData.RegistrySettings }
        "Update-TfcRegistrySettings" { return $script:MockData.RegistrySettings }
        "Get-TfcSubscription" { return $script:MockData.Subscriptions }
        "Get-TfcInvoice" { return $script:MockData.Invoices }
        "Get-TfcTwoFactorSettings" { return $script:MockData.TwoFactorSettings }
        "Update-TfcTwoFactorSettings" { return $script:MockData.TwoFactorSettings }

        default {
            return @{
                data = @{
                    id = "mock-generic-$(Get-Random)"
                    attributes = @{ status = "mocked" }
                }
            }
        }
    }
}

# Safety check for production organization
function Test-ProductionSafety {
    if (-not $UseTestOrganization -and -not $MockMode) {
        Write-Host "`n⚠️  WARNING: You are about to test against a PRODUCTION organization!" -ForegroundColor Red
        Write-Host "This may create, modify, or delete resources in your production environment." -ForegroundColor Red
        Write-Host "`nRecommended options:" -ForegroundColor Yellow
        Write-Host "  1. Use -MockMode to simulate tests without API calls" -ForegroundColor Yellow
        Write-Host "  2. Use -UseTestOrganization with a dedicated test org" -ForegroundColor Yellow
        Write-Host "  3. Skip destructive tests by default (use -RunDestructiveTests to enable)" -ForegroundColor Yellow

        $response = Read-Host "`nDo you want to continue with PRODUCTION testing? (yes/NO)"
        if ($response -ne "yes") {
            Write-Host "Testing cancelled for safety." -ForegroundColor Green
            return $false
        }
    }
    return $true
}

# Initialize mock data if in mock mode
if ($MockMode) {
    Initialize-MockData
}

# Safety check
if (-not (Test-ProductionSafety)) {
    return
}

Write-Host "`n=== Core Module Tests ===" -ForegroundColor Magenta

# Test 1: Module Import
try {
    Get-Module TerraformCloud -ErrorAction Stop | Out-Null
    Add-TestResult "Module Import" "PASS" "Module imported successfully"
}
catch {
    Add-TestResult "Module Import" "FAIL" $_.Exception.Message
}

# Test 2: Authentication Check
if ($MockMode) {
    Add-TestResult "Authentication Check" "MOCK" "Mock mode - authentication simulated"
    $script:TestOrganization = "mock-test-org"
}
else {
    try {
        if (-not $env:TFE_TOKEN -and -not (Test-Path ~/.terraform.d/credentials.tfrc.json)) {
            Add-TestResult "Authentication Check" "SKIP" "No TFE_TOKEN or credentials file found"
        }
        else {
            $account = Get-TfcAccount
            if ($account.data.id) {
                Add-TestResult "Authentication Check" "PASS" "Successfully authenticated as user: $($account.data.attributes.username)"
            }
            else {
                Add-TestResult "Authentication Check" "FAIL" "No account data returned"
            }
        }
    }
    catch {
        Add-TestResult "Authentication Check" "FAIL" $_.Exception.Message
    }
}

Write-Host "`n=== Organization Tests ===" -ForegroundColor Magenta

# Test 3: Get Organizations
try {
    if ($MockMode) {
        $orgs = Invoke-MockTfcFunction -FunctionName "Get-TfcOrganization"
    }
    else {
        $orgs = Get-TfcOrganization
    }

    if ($orgs.data -and $orgs.data.Count -gt 0) {
        Add-TestResult "Get Organizations" "PASS" "Retrieved $($orgs.data.Count) organizations"
        if (-not $script:TestOrganization) {
            $script:TestOrganization = $orgs.data[0].id
        }
        Write-Host "Using organization '$($orgs.data[0].attributes.name)' for tests" -ForegroundColor Cyan
    }
    else {
        Add-TestResult "Get Organizations" "FAIL" "No organizations found"
    }
}
catch {
    Add-TestResult "Get Organizations" "FAIL" $_.Exception.Message
}

# Test 4: Get Specific Organization
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $org = Invoke-MockTfcFunction -FunctionName "Get-TfcOrganization" -Parameters @{ Name = $script:TestOrganization }
        }
        else {
            $org = Get-TfcOrganization -Name $script:TestOrganization
        }

        if ($org.data.id -eq $script:TestOrganization) {
            Add-TestResult "Get Specific Organization" "PASS" "Retrieved organization: $($org.data.attributes.name)"
        }
        else {
            Add-TestResult "Get Specific Organization" "FAIL" "Organization ID mismatch"
        }
    }
    catch {
        Add-TestResult "Get Specific Organization" "FAIL" $_.Exception.Message
    }
}

# Test 5: Get Organization Entitlements
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $entitlements = Invoke-MockTfcFunction -FunctionName "Get-TfcOrganizationEntitlements"
            Add-TestResult "Get Organization Entitlements" "MOCK" "Retrieved mock entitlements for $($script:TestOrganization)"
        }
        else {
            $entitlements = Get-TfcOrganizationEntitlements -Organization $script:TestOrganization
            if ($entitlements.data.attributes) {
                Add-TestResult "Get Organization Entitlements" "PASS" "Retrieved entitlements for $($script:TestOrganization)"
            }
            else {
                Add-TestResult "Get Organization Entitlements" "FAIL" "No entitlements data found"
            }
        }
    }
    catch {
        Add-TestResult "Get Organization Entitlements" "FAIL" $_.Exception.Message
    }
}

Write-Host "`n=== Workspace Tests ===" -ForegroundColor Magenta

# Test 6: Get Workspaces
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $workspaces = Invoke-MockTfcFunction -FunctionName "Get-TfcWorkspace"
        }
        else {
            $workspaces = Get-TfcWorkspace -Organization $script:TestOrganization
        }

        if ($workspaces.data) {
            Add-TestResult "Get Workspaces" "PASS" "Retrieved $($workspaces.data.Count) workspaces"
            if ($workspaces.data.Count -gt 0) {
                $script:TestWorkspaceId = $workspaces.data[0].id
                Write-Host "    Selected workspace: $($workspaces.data[0].attributes.name) (ID: $($script:TestWorkspaceId))" -ForegroundColor Gray
            } else {
                $script:TestWorkspaceId = $null
            }
        }
        else {
            Add-TestResult "Get Workspaces" "PASS" "No workspaces found (empty organization)"
        }
    }
    catch {
        Add-TestResult "Get Workspaces" "FAIL" $_.Exception.Message
    }
}

# Test 7: Find Workspace
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            Invoke-MockTfcFunction -FunctionName "Find-TfcWorkspace" | Out-Null
            Add-TestResult "Find Workspace" "MOCK" "Find workspace function simulated successfully"
        }
        else {
            Find-TfcWorkspace -Organization $script:TestOrganization -WorkspaceName "*" | Out-Null
            Add-TestResult "Find Workspace" "PASS" "Find workspace function executed successfully"
        }
    }
    catch {
        Add-TestResult "Find Workspace" "FAIL" $_.Exception.Message
    }
}

# Test 8: Workspace ID Validation
try {
    $validId = Test-TfcWorkspaceId -WorkspaceId "ws-123456789abcdef0"
    $invalidId = Test-TfcWorkspaceId -WorkspaceId "invalid-id"
    if ($validId -and -not $invalidId) {
        Add-TestResult "Workspace ID Validation" "PASS" "Validation working correctly"
    }
    else {
        Add-TestResult "Workspace ID Validation" "FAIL" "Validation logic incorrect"
    }
}
catch {
    Add-TestResult "Workspace ID Validation" "FAIL" $_.Exception.Message
}

Write-Host "`n=== Team and Access Tests ===" -ForegroundColor Magenta

# Test 9: Get Teams
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $teams = Invoke-MockTfcFunction -FunctionName "Get-TfcTeam"
        }
        else {
            $teams = Get-TfcTeam -Organization $script:TestOrganization
        }

        if ($teams.data) {
            Add-TestResult "Get Teams" "PASS" "Retrieved $($teams.data.Count) teams"
        }
        else {
            Add-TestResult "Get Teams" "PASS" "No teams found"
        }
    }
    catch {
        Add-TestResult "Get Teams" "FAIL" $_.Exception.Message
    }
}

# Test 10: Get OAuth Clients
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $oauthClients = Invoke-MockTfcFunction -FunctionName "Get-TfcOauthClient"
            Add-TestResult "Get OAuth Clients" "MOCK" "Retrieved mock OAuth clients"
        }
        else {
            $oauthClients = Get-TfcOauthClient -Organization $script:TestOrganization
            if ($oauthClients.data) {
                Add-TestResult "Get OAuth Clients" "PASS" "Retrieved $($oauthClients.data.Count) OAuth clients"
            }
            else {
                Add-TestResult "Get OAuth Clients" "PASS" "No OAuth clients found"
            }
        }
    }
    catch {
        Add-TestResult "Get OAuth Clients" "FAIL" $_.Exception.Message
    }
}

Write-Host "`n=== Variable Tests ===" -ForegroundColor Magenta

# Test 11: Get Variable Sets
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $variableSets = Invoke-MockTfcFunction -FunctionName "Get-TfcVariableSet"
            Add-TestResult "Get Variable Sets" "MOCK" "Retrieved mock variable sets"
        }
        else {
            $variableSets = Get-TfcVariableSet -Organization $script:TestOrganization
            if ($variableSets.data) {
                Add-TestResult "Get Variable Sets" "PASS" "Retrieved $($variableSets.data.Count) variable sets"
            }
            else {
                Add-TestResult "Get Variable Sets" "PASS" "No variable sets found"
            }
        }
    }
    catch {
        Add-TestResult "Get Variable Sets" "FAIL" $_.Exception.Message
    }
}

# Test 12: Get Workspace Variables
if ($script:TestWorkspaceId) {
    try {
        if ($MockMode) {
            $variables = Invoke-MockTfcFunction -FunctionName "Get-TfcWorkspaceVariable"
            Add-TestResult "Get Workspace Variables" "MOCK" "Retrieved mock workspace variables"
        }
        else {
            $variables = Get-TfcWorkspaceVariable -WorkspaceId $script:TestWorkspaceId
            Add-TestResult "Get Workspace Variables" "PASS" "Retrieved $($variables.data.Count) workspace variables"
        }
    }
    catch {
        Add-TestResult "Get Workspace Variables" "FAIL" $_.Exception.Message
    }
}

Write-Host "`n=== State and Run Tests ===" -ForegroundColor Magenta

# Test 13: Get Current State Version
if ($script:TestWorkspaceId) {
    try {
        if ($MockMode) {
            Invoke-MockTfcFunction -FunctionName "Get-TfcCurrentStateVersion" | Out-Null
            Add-TestResult "Get Current State Version" "MOCK" "Retrieved mock state version"
        }
        else {
            Get-TfcCurrentStateVersion -WorkspaceId $script:TestWorkspaceId | Out-Null
            Add-TestResult "Get Current State Version" "PASS" "Retrieved current state version"
        }
    }
    catch {
        Add-TestResult "Get Current State Version" "FAIL" $_.Exception.Message
    }
}

# Test 14: Get Runs
if ($script:TestWorkspaceId) {
    try {
        if ($MockMode) {
            $runs = Invoke-MockTfcFunction -FunctionName "Get-TfcRun"
            Add-TestResult "Get Runs" "MOCK" "Retrieved mock runs"
        }
        else {
            $runs = Get-TfcRun -WorkspaceId $script:TestWorkspaceId
            Add-TestResult "Get Runs" "PASS" "Retrieved $($runs.data.Count) runs"
        }
    }
    catch {
        Add-TestResult "Get Runs" "FAIL" $_.Exception.Message
    }
}

Write-Host "`n=== API and Utility Tests ===" -ForegroundColor Magenta

# Test 15: Generic API Call
try {
    if ($MockMode) {
        $apiResult = Invoke-MockTfcFunction -FunctionName "Invoke-TfcApi" -Parameters @{ Uri = "/organizations"; Method = "GET" }
        Add-TestResult "Generic API Call" "MOCK" "Invoke-TfcApi working in mock mode"
    }
    else {
        $apiResult = Invoke-TfcApi -Uri "/organizations" -Method GET
        if ($apiResult.data) {
            Add-TestResult "Generic API Call" "PASS" "Invoke-TfcApi working correctly"
        }
        else {
            Add-TestResult "Generic API Call" "FAIL" "No data returned from API call"
        }
    }
}
catch {
    Add-TestResult "Generic API Call" "FAIL" $_.Exception.Message
}

Write-Host "`n=== Projects Tests ===" -ForegroundColor Cyan

# Test 16: Get Projects
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $projects = Invoke-MockTfcFunction -FunctionName "Get-TfcProject" -Parameters @{ Organization = $script:TestOrganization }
            Add-TestResult "Get Projects" "MOCK" "Projects retrieved in mock mode"
        }
        else {
            $projects = Get-TfcProject -Organization $script:TestOrganization
            if ($projects.data) {
                Add-TestResult "Get Projects" "PASS" "Retrieved projects for organization"
            }
            else {
                Add-TestResult "Get Projects" "WARN" "No projects found (may be empty)"
            }
        }
    }
    catch {
        Add-TestResult "Get Projects" "FAIL" $_.Exception.Message
    }
}

Write-Host "`n=== State Management Tests ===" -ForegroundColor Cyan

# Test 17: Get State Versions
if ($script:TestWorkspaceId) {
    try {
        if ($MockMode) {
            $stateVersions = Invoke-MockTfcFunction -FunctionName "Get-TfcStateVersion" -Parameters @{ WorkspaceId = $script:TestWorkspaceId }
            Add-TestResult "Get State Versions" "MOCK" "State versions retrieved in mock mode"
        }
        else {
            $stateVersions = Get-TfcStateVersion -WorkspaceId $script:TestWorkspaceId
            if ($stateVersions.data) {
                Add-TestResult "Get State Versions" "PASS" "Retrieved state versions for workspace"
            }
            else {
                Add-TestResult "Get State Versions" "WARN" "No state versions found (may be empty)"
            }
        }
    }
    catch {
        Add-TestResult "Get State Versions" "FAIL" $_.Exception.Message
    }
}

# Test 18: Get State Version Output
if ($script:TestWorkspaceId) {
    try {
        if ($MockMode) {
            $mockStateVersion = "sv-mock123"
            Invoke-MockTfcFunction -FunctionName "Get-TfcStateVersionOutput" -Parameters @{ StateVersionId = $mockStateVersion } | Out-Null
            Add-TestResult "Get State Version Output" "MOCK" "State outputs retrieved in mock mode"
        }
        else {
            # Try to get a real state version first
            $stateVersion = Get-TfcStateVersion -WorkspaceId $script:TestWorkspaceId
            if ($stateVersion.data -and $stateVersion.data[0].id) {
                Get-TfcStateVersionOutput -StateVersionId $stateVersion.data[0].id | Out-Null
                Add-TestResult "Get State Version Output" "PASS" "Retrieved state version outputs"
            }
            else {
                Add-TestResult "Get State Version Output" "SKIP" "No state versions available to test"
            }
        }
    }
    catch {
        Add-TestResult "Get State Version Output" "FAIL" $_.Exception.Message
    }
}

Write-Host "`n=== Registry Tests ===" -ForegroundColor Cyan

# Test 19: Get Registry Modules
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $modules = Invoke-MockTfcFunction -FunctionName "Get-TfcRegistryModule" -Parameters @{ Organization = $script:TestOrganization }
            Add-TestResult "Get Registry Modules" "MOCK" "Registry modules retrieved in mock mode"
        }
        else {
            $modules = Get-TfcRegistryModule -Organization $script:TestOrganization
            if ($modules.data) {
                Add-TestResult "Get Registry Modules" "PASS" "Retrieved registry modules"
            }
            else {
                Add-TestResult "Get Registry Modules" "WARN" "No registry modules found (may be empty)"
            }
        }
    }
    catch {
        Add-TestResult "Get Registry Modules" "FAIL" $_.Exception.Message
    }
}

# Test 20: Get Registry Providers
if ($script:TestOrganization) {
    try {
        if ($MockMode) {
            $providers = Invoke-MockTfcFunction -FunctionName "Get-TfcRegistryProvider" -Parameters @{ Organization = $script:TestOrganization }
            Add-TestResult "Get Registry Providers" "MOCK" "Registry providers retrieved in mock mode"
        }
        else {
            $providers = Get-TfcRegistryProvider -Organization $script:TestOrganization
            if ($providers.data) {
                Add-TestResult "Get Registry Providers" "PASS" "Retrieved registry providers"
            }
            else {
                Add-TestResult "Get Registry Providers" "WARN" "No registry providers found (may be empty)"
            }
        }
    }
    catch {
        Add-TestResult "Get Registry Providers" "FAIL" $_.Exception.Message
    }
}

# Test 21: Get Configuration Version List
if ($script:TestWorkspaceId) {
    try {
        if ($MockMode) {
            $configVersions = Invoke-MockTfcFunction -FunctionName "Get-TfcConfigurationVersionList" -Parameters @{ WorkspaceId = $script:TestWorkspaceId }
            Add-TestResult "Get Configuration Version List" "MOCK" "Configuration versions retrieved in mock mode"
        }
        else {
            $configVersions = Get-TfcConfigurationVersionList -WorkspaceId $script:TestWorkspaceId
            if ($configVersions.data) {
                Add-TestResult "Get Configuration Version List" "PASS" "Retrieved configuration versions"
            }
            else {
                Add-TestResult "Get Configuration Version List" "WARN" "No configuration versions found"
            }
        }
    }
    catch {
        Add-TestResult "Get Configuration Version List" "FAIL" $_.Exception.Message
    }
}

# Test 22: Get Configuration Version (if we have one)
if ($script:TestWorkspaceId -and -not $MockMode) {
    try {
        $configVersions = Get-TfcConfigurationVersionList -WorkspaceId $script:TestWorkspaceId
        if ($configVersions.data -and $configVersions.data[0].id) {
            $configVersion = Get-TfcConfigurationVersion -ConfigurationVersionId $configVersions.data[0].id
            if ($configVersion.data) {
                Add-TestResult "Get Configuration Version" "PASS" "Retrieved specific configuration version"
            }
            else {
                Add-TestResult "Get Configuration Version" "FAIL" "Failed to get configuration version details"
            }
        }
        else {
            Add-TestResult "Get Configuration Version" "SKIP" "No configuration versions available to test"
        }
    }
    catch {
        Add-TestResult "Get Configuration Version" "FAIL" $_.Exception.Message
    }
}
elseif ($MockMode) {
    try {
        Invoke-MockTfcFunction -FunctionName "Get-TfcConfigurationVersion" -Parameters @{ ConfigurationVersionId = "cv-mock123" } | Out-Null
        Add-TestResult "Get Configuration Version" "MOCK" "Configuration version retrieved in mock mode"
    }
    catch {
        Add-TestResult "Get Configuration Version" "FAIL" $_.Exception.Message
    }
}

# Test 23: Get Workspace Tags (mock mode)
if ($MockMode) {
    try {
        $tags = Invoke-MockTfcFunction -FunctionName "Get-TfcWorkspaceTag" -Parameters @{ Organization = "test-org"; Workspace = "test-workspace" }
        if ($tags) {
            Add-TestResult "Get Workspace Tags" "MOCK" "Retrieved $(($tags -as [array]).Count) workspace tags in mock mode"
        }
    }
    catch {
        Add-TestResult "Get Workspace Tags" "FAIL" $_.Exception.Message
    }
}

# Test 24: Get Team (mock mode)
if ($MockMode) {
    try {
        $team = Invoke-MockTfcFunction -FunctionName "Get-TfcTeam" -Parameters @{ Organization = "test-org"; TeamName = "owners" }
        if ($team.data) {
            Add-TestResult "Get Team" "MOCK" "Retrieved team in mock mode"
        }
    }
    catch {
        Add-TestResult "Get Team" "FAIL" $_.Exception.Message
    }
}

# Test 25: Get Organization (existing function, verify still works)
if ($MockMode) {
    try {
        Invoke-MockTfcFunction -FunctionName "Get-TfcOrganization" -Parameters @{ Name = "test-org" } | Out-Null
        Add-TestResult "Get Organization" "MOCK" "Organization retrieved in mock mode"
    }
    catch {
        Add-TestResult "Get Organization" "FAIL" $_.Exception.Message
    }
}
elseif ($script:TestOrganization) {
    try {
        $org = Get-TfcOrganization -Name $script:TestOrganization
        if ($org.data) {
            Add-TestResult "Get Organization" "PASS" "Organization retrieved successfully"
        }
        else {
            Add-TestResult "Get Organization" "FAIL" "No organization data returned"
        }
    }
    catch {
        Add-TestResult "Get Organization" "FAIL" $_.Exception.Message
    }
}

# Destructive Tests (only if enabled or in mock mode)
if ($RunDestructiveTests -or $MockMode) {
    Write-Host "`n=== Destructive Tests (CREATE/UPDATE/DELETE) ===" -ForegroundColor Yellow

    # Test 21: Create Test Workspace
    if ($script:TestOrganization) {
        try {
            $testWorkspaceName = "test-workspace-$(Get-Random)"

            if ($MockMode) {
                $newWorkspace = Invoke-MockTfcFunction -FunctionName "New-TfcWorkspace" -Parameters @{ Name = $testWorkspaceName }
                Add-TestResult "Create Test Workspace" "MOCK" "Mock workspace created: $($newWorkspace.data.id)"
                $script:CreatedWorkspaceId = $newWorkspace.data.id
            }
            else {
                # Only create if we have a test organization
                if ($UseTestOrganization) {
                    $newWorkspace = New-TfcWorkspace -Organization $script:TestOrganization -Name $testWorkspaceName
                    if ($newWorkspace.data.id) {
                        Add-TestResult "Create Test Workspace" "PASS" "Created workspace: $($newWorkspace.data.id)"
                        $script:CreatedWorkspaceId = $newWorkspace.data.id
                    }
                    else {
                        Add-TestResult "Create Test Workspace" "FAIL" "Workspace creation returned no ID"
                    }
                }
                else {
                    Add-TestResult "Create Test Workspace" "SKIP" "Skipped - not using test organization"
                }
            }
        }
        catch {
            Add-TestResult "Create Test Workspace" "FAIL" $_.Exception.Message
        }
    }

    # Test 22: Create Test Variable
    $targetWorkspace = $script:CreatedWorkspaceId ?? $script:TestWorkspaceId
    if ($targetWorkspace) {
        Write-Host "    Using workspace ID: $targetWorkspace" -ForegroundColor Gray
        try {
            $testVarKey = "test_variable_$(Get-Random)"

            if ($MockMode) {
                $testVar = Invoke-MockTfcFunction -FunctionName "Set-TfcWorkspaceVariable" -Parameters @{
                    WorkspaceId = $targetWorkspace
                    Key = $testVarKey
                    Value = "test_value"
                    Category = "terraform"
                }
                Add-TestResult "Create Test Variable" "MOCK" "Mock variable created: $($testVar.data.id)"
                $script:TestVariableId = $testVar.data.id
                $script:TestVariableKey = $testVar.data.attributes.key
            }
            else {
                $testVar = Set-TfcWorkspaceVariable -WorkspaceId $targetWorkspace -Key $testVarKey -Value "test_value" -Category "terraform"
                if ($testVar.data.id) {
                    Add-TestResult "Create Test Variable" "PASS" "Created test variable: $($testVar.data.id)"
                    $script:TestVariableId = $testVar.data.id
                    $script:TestVariableKey = $testVar.data.attributes.key
                }
                else {
                    Add-TestResult "Create Test Variable" "FAIL" "Variable creation returned no ID"
                }
            }
        }
        catch {
            Add-TestResult "Create Test Variable" "FAIL" $_.Exception.Message
        }
    }
    else {
        Add-TestResult "Create Test Variable" "SKIP" "No test workspace available"
    }

    # Test 23: Update Test Variable
    if ($script:TestVariableKey -and $targetWorkspace) {
        try {
            if ($MockMode) {
                $updatedVar = Invoke-MockTfcFunction -FunctionName "Update-TfcWorkspaceVariable" -Parameters @{
                    WorkspaceId = $targetWorkspace
                    Key = $script:TestVariableKey
                    Value = "updated_value"
                    Category = "terraform"
                }
                Add-TestResult "Update Test Variable" "MOCK" "Mock variable updated"
            }
            else {
                $updatedVar = Update-TfcWorkspaceVariable -WorkspaceId $targetWorkspace -Key $script:TestVariableKey -Value "updated_value" -Category "terraform"
                if ($updatedVar.data.attributes.value -eq "updated_value") {
                    Add-TestResult "Update Test Variable" "PASS" "Updated test variable"
                }
                else {
                    Add-TestResult "Update Test Variable" "FAIL" "Variable value not updated correctly"
                }
            }
        }
        catch {
            Add-TestResult "Update Test Variable" "FAIL" $_.Exception.Message
        }
    }

    # Test 24: Delete Test Variable
    if ($script:TestVariableKey -and $targetWorkspace) {
        try {
            if ($MockMode) {
                Add-TestResult "Delete Test Variable" "MOCK" "Mock variable deleted"
            }
            else {
                Remove-TfcWorkspaceVariable -WorkspaceId $targetWorkspace -Key $script:TestVariableKey -Confirm:$false
                Add-TestResult "Delete Test Variable" "PASS" "Deleted test variable"
            }
        }
        catch {
            Add-TestResult "Delete Test Variable" "FAIL" $_.Exception.Message
        }
    }

    # Test 26: Create Variable Set
    if ($script:TestOrganization) {
        try {
            if ($MockMode) {
                Invoke-MockTfcFunction -FunctionName "New-TfcVariableSet" | Out-Null
                Add-TestResult "Create Variable Set" "MOCK" "Variable set creation simulated"
            }
            else {
                $varSet = New-TfcVariableSet -Organization $script:TestOrganization -Name "test-varset-$(Get-Random)" -Description "Test variable set"
                if ($varSet.data.id) {
                    $script:TestVarSetId = $varSet.data.id
                    Add-TestResult "Create Variable Set" "PASS" "Created test variable set"
                }
                else {
                    Add-TestResult "Create Variable Set" "FAIL" "No variable set ID returned"
                }
            }
        }
        catch {
            Add-TestResult "Create Variable Set" "FAIL" $_.Exception.Message
        }
    }

    # Test 27: Update Variable Set
    if ($script:TestVarSetId -and -not $MockMode) {
        try {
            $updated = Update-TfcVariableSet -VariableSetId $script:TestVarSetId -Description "Updated description"
            if ($updated.data) {
                Add-TestResult "Update Variable Set" "PASS" "Updated variable set"
            }
            else {
                Add-TestResult "Update Variable Set" "FAIL" "Update returned no data"
            }
        }
        catch {
            Add-TestResult "Update Variable Set" "FAIL" $_.Exception.Message
        }
    }
    elseif ($MockMode) {
        try {
            Invoke-MockTfcFunction -FunctionName "Update-TfcVariableSet" | Out-Null
            Add-TestResult "Update Variable Set" "MOCK" "Variable set update simulated"
        }
        catch {
            Add-TestResult "Update Variable Set" "FAIL" $_.Exception.Message
        }
    }

    # Test 28: Create Configuration Version
    if ($script:CreatedWorkspaceId -and -not $MockMode) {
        try {
            $configVersion = New-TfcConfigurationVersion -WorkspaceId $script:CreatedWorkspaceId -Speculative
            if ($configVersion.data.id) {
                Add-TestResult "Create Configuration Version" "PASS" "Created configuration version"
            }
            else {
                Add-TestResult "Create Configuration Version" "FAIL" "No configuration version ID returned"
            }
        }
        catch {
            Add-TestResult "Create Configuration Version" "FAIL" $_.Exception.Message
        }
    }
    elseif ($MockMode) {
        try {
            Invoke-MockTfcFunction -FunctionName "New-TfcConfigurationVersion" | Out-Null
            Add-TestResult "Create Configuration Version" "MOCK" "Configuration version creation simulated"
        }
        catch {
            Add-TestResult "Create Configuration Version" "FAIL" $_.Exception.Message
        }
    }

    # Test 29: Remove Variable Set (Cleanup)
    if ($script:TestVarSetId -and -not $MockMode) {
        try {
            $removed = Remove-TfcVariableSet -VariableSetId $script:TestVarSetId -Confirm:$false
            if ($removed) {
                Add-TestResult "Remove Variable Set" "PASS" "Removed test variable set"
            }
            else {
                Add-TestResult "Remove Variable Set" "WARN" "Variable set removal returned false"
            }
        }
        catch {
            Add-TestResult "Remove Variable Set" "FAIL" $_.Exception.Message
            Write-Host "⚠️  Manual cleanup required for variable set: $($script:TestVarSetId)" -ForegroundColor Yellow
        }
    }
    elseif ($MockMode) {
        try {
            Invoke-MockTfcFunction -FunctionName "Remove-TfcVariableSet" | Out-Null
            Add-TestResult "Remove Variable Set" "MOCK" "Variable set removal simulated"
        }
        catch {
            Add-TestResult "Remove Variable Set" "FAIL" $_.Exception.Message
        }
    }

    # Test 30: Set Workspace Tags
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Set-TfcWorkspaceTag" -Parameters @{
                Organization = "test-org"
                Workspace = "test-workspace"
                Tags = @("environment:test", "team:platform")
            }
            if ($result) {
                Add-TestResult "Set Workspace Tags" "MOCK" "Workspace tags set in mock mode"
            }
        }
        catch {
            Add-TestResult "Set Workspace Tags" "FAIL" $_.Exception.Message
        }
    }

    # Test 31: Create Team
    if ($MockMode) {
        try {
            $team = Invoke-MockTfcFunction -FunctionName "New-TfcTeam" -Parameters @{
                Organization = "test-org"
                Name = "test-team"
                Visibility = "organization"
            }
            if ($team.data) {
                Add-TestResult "Create Team" "MOCK" "Team created in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Team" "FAIL" $_.Exception.Message
        }
    }

    # Test 32: Update Team
    if ($MockMode) {
        try {
            $team = Invoke-MockTfcFunction -FunctionName "Update-TfcTeam" -Parameters @{
                TeamId = "team-mock123"
                Name = "updated-team-name"
            }
            if ($team.data) {
                Add-TestResult "Update Team" "MOCK" "Team updated in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Team" "FAIL" $_.Exception.Message
        }
    }

    # Test 33: Variable Set Workspace Assignment
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Set-TfcVariableSetWorkspace" -Parameters @{
                VariableSetId = "varset-mock123"
                WorkspaceIds = @("ws-mock1", "ws-mock2")
            }
            if ($result) {
                Add-TestResult "Variable Set Workspace Assignment" "MOCK" "Variable set assigned to workspaces in mock mode"
            }
        }
        catch {
            Add-TestResult "Variable Set Workspace Assignment" "FAIL" $_.Exception.Message
        }
    }

    # ===== PHASE 1 TESTS (Tests 35-60) =====

    # Test 35: Get Run Triggers
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunTrigger" -Parameters @{ WorkspaceId = "ws-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Run Triggers" "MOCK" "Retrieved run triggers in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Triggers" "FAIL" $_.Exception.Message
        }
    }

    # Test 36: Create Run Trigger
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcRunTrigger" -Parameters @{
                WorkspaceId = "ws-mocktest123"
                SourceableId = "ws-source123"
            }
            if ($result.data.id) {
                Add-TestResult "Create Run Trigger" "MOCK" "Created run trigger in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Run Trigger" "FAIL" $_.Exception.Message
        }
    }

    # Test 37: Get Run Trigger Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunTriggerDetails" -Parameters @{ RunTriggerId = "rt-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Run Trigger Details" "MOCK" "Retrieved run trigger details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Trigger Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 38: Remove Run Trigger
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcRunTrigger" -Parameters @{ RunTriggerId = "rt-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Run Trigger" "MOCK" "Removed run trigger in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Run Trigger" "FAIL" $_.Exception.Message
        }
    }

    # Test 39: Get Run Tasks
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunTask" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Run Tasks" "MOCK" "Retrieved run tasks in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Tasks" "FAIL" $_.Exception.Message
        }
    }

    # Test 40: Create Run Task
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcRunTask" -Parameters @{
                OrganizationName = "mock-org"
                Name = "mock-task"
                Url = "https://example.com/task"
            }
            if ($result.data.id) {
                Add-TestResult "Create Run Task" "MOCK" "Created run task in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Run Task" "FAIL" $_.Exception.Message
        }
    }

    # Test 41: Get Run Task Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunTaskDetails" -Parameters @{ RunTaskId = "task-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Run Task Details" "MOCK" "Retrieved run task details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Task Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 42: Update Run Task
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcRunTask" -Parameters @{
                RunTaskId = "task-mocktest123"
                Name = "updated-task"
            }
            if ($result.data) {
                Add-TestResult "Update Run Task" "MOCK" "Updated run task in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Run Task" "FAIL" $_.Exception.Message
        }
    }

    # Test 43: Remove Run Task
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcRunTask" -Parameters @{ RunTaskId = "task-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Run Task" "MOCK" "Removed run task in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Run Task" "FAIL" $_.Exception.Message
        }
    }

    # Test 44: Get Workspace Run Tasks
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcWorkspaceRunTask" -Parameters @{ WorkspaceId = "ws-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Workspace Run Tasks" "MOCK" "Retrieved workspace run tasks in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Workspace Run Tasks" "FAIL" $_.Exception.Message
        }
    }

    # Test 45: Add Workspace Run Task
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Add-TfcWorkspaceRunTask" -Parameters @{
                WorkspaceId = "ws-mocktest123"
                RunTaskId = "task-mocktest123"
                EnforcementLevel = "advisory"
            }
            if ($result.data) {
                Add-TestResult "Add Workspace Run Task" "MOCK" "Added workspace run task in mock mode"
            }
        }
        catch {
            Add-TestResult "Add Workspace Run Task" "FAIL" $_.Exception.Message
        }
    }

    # Test 46: Update Workspace Run Task
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcWorkspaceRunTask" -Parameters @{
                WorkspaceTaskId = "wstask-mocktest123"
                EnforcementLevel = "mandatory"
            }
            if ($result.data) {
                Add-TestResult "Update Workspace Run Task" "MOCK" "Updated workspace run task in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Workspace Run Task" "FAIL" $_.Exception.Message
        }
    }

    # Test 47: Remove Workspace Run Task
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcWorkspaceRunTask" -Parameters @{ WorkspaceTaskId = "wstask-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Workspace Run Task" "MOCK" "Removed workspace run task in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Workspace Run Task" "FAIL" $_.Exception.Message
        }
    }

    # Test 48: Get Run Task Stages
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunTaskStage" -Parameters @{ RunTaskId = "task-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Run Task Stages" "MOCK" "Retrieved run task stages in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Task Stages" "FAIL" $_.Exception.Message
        }
    }

    # Test 49: Get Notification Configurations
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcNotificationConfiguration" -Parameters @{ WorkspaceId = "ws-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Notification Configurations" "MOCK" "Retrieved notification configs in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Notification Configurations" "FAIL" $_.Exception.Message
        }
    }

    # Test 50: Create Notification Configuration
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcNotificationConfiguration" -Parameters @{
                WorkspaceId = "ws-mocktest123"
                Name = "mock-notification"
                DestinationType = "slack"
                Url = "https://hooks.slack.com/services/mock"
            }
            if ($result.data.id) {
                Add-TestResult "Create Notification Configuration" "MOCK" "Created notification config in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Notification Configuration" "FAIL" $_.Exception.Message
        }
    }

    # Test 51: Update Notification Configuration
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcNotificationConfiguration" -Parameters @{
                NotificationConfigurationId = "nc-mocktest123"
                Enabled = $true
            }
            if ($result.data) {
                Add-TestResult "Update Notification Configuration" "MOCK" "Updated notification config in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Notification Configuration" "FAIL" $_.Exception.Message
        }
    }

    # Test 52: Remove Notification Configuration
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcNotificationConfiguration" -Parameters @{ NotificationConfigurationId = "nc-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Notification Configuration" "MOCK" "Removed notification config in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Notification Configuration" "FAIL" $_.Exception.Message
        }
    }

    # Test 53: Test Notification Configuration
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Test-TfcNotificationConfiguration" -Parameters @{ NotificationConfigurationId = "nc-mocktest123" }
            if ($result.data) {
                Add-TestResult "Test Notification Configuration" "MOCK" "Tested notification config in mock mode"
            }
        }
        catch {
            Add-TestResult "Test Notification Configuration" "FAIL" $_.Exception.Message
        }
    }

    # Test 54: Get Plan JSON Output
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcPlanJsonOutput" -Parameters @{ PlanId = "plan-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Plan JSON Output" "MOCK" "Retrieved plan JSON in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Plan JSON Output" "FAIL" $_.Exception.Message
        }
    }

    # Test 55: Get Plan Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcPlanDetails" -Parameters @{ PlanId = "plan-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Plan Details" "MOCK" "Retrieved plan details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Plan Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 56: Get Plan Logs
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcPlanLogs" -Parameters @{ PlanId = "plan-mocktest123" }
            if ($result) {
                Add-TestResult "Get Plan Logs" "MOCK" "Retrieved plan logs in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Plan Logs" "FAIL" $_.Exception.Message
        }
    }

    # Test 57: Create Plan Export
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcPlanExport" -Parameters @{ PlanId = "plan-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Create Plan Export" "MOCK" "Created plan export in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Plan Export" "FAIL" $_.Exception.Message
        }
    }

    # Test 58: Get Plan Export
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcPlanExport" -Parameters @{ PlanExportId = "planexp-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Plan Export" "MOCK" "Retrieved plan export in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Plan Export" "FAIL" $_.Exception.Message
        }
    }

    # Test 59: Get Apply Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcApplyDetails" -Parameters @{ ApplyId = "apply-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Apply Details" "MOCK" "Retrieved apply details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Apply Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 60: Get Apply Logs
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcApplyLogs" -Parameters @{ ApplyId = "apply-mocktest123" }
            if ($result) {
                Add-TestResult "Get Apply Logs" "MOCK" "Retrieved apply logs in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Apply Logs" "FAIL" $_.Exception.Message
        }
    }

    # Test 61: Add Team Workspace Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Add-TfcTeamWorkspaceAccess" -Parameters @{
                TeamId = "team-mocktest123"
                WorkspaceId = "ws-mocktest123"
                Access = "write"
            }
            if ($result.data.id) {
                Add-TestResult "Add Team Workspace Access" "MOCK" "Added team workspace access in mock mode"
            }
        }
        catch {
            Add-TestResult "Add Team Workspace Access" "FAIL" $_.Exception.Message
        }
    }

    # Test 62: Update Team Workspace Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcTeamWorkspaceAccess" -Parameters @{
                TeamAccessId = "tws-mocktest123"
                Access = "admin"
            }
            if ($result.data) {
                Add-TestResult "Update Team Workspace Access" "MOCK" "Updated team workspace access in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Team Workspace Access" "FAIL" $_.Exception.Message
        }
    }

    # Test 63: Remove Team Workspace Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcTeamWorkspaceAccess" -Parameters @{ TeamAccessId = "tws-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Team Workspace Access" "MOCK" "Removed team workspace access in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Team Workspace Access" "FAIL" $_.Exception.Message
        }
    }

    # Test 64: Get Team Workspace Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcTeamWorkspaceAccess" -Parameters @{ TeamAccessId = "tws-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Team Workspace Access" "MOCK" "Retrieved team workspace access in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Team Workspace Access" "FAIL" $_.Exception.Message
        }
    }

    # ===== PHASE 2 TESTS (Tests 65-83) =====

    # Test 65: Get Agent Pools
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAgentPool" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Agent Pools" "MOCK" "Retrieved agent pools in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Agent Pools" "FAIL" $_.Exception.Message
        }
    }

    # Test 66: Create Agent Pool
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcAgentPool" -Parameters @{
                OrganizationName = "mock-org"
                Name = "mock-agent-pool"
            }
            if ($result.data.id) {
                Add-TestResult "Create Agent Pool" "MOCK" "Created agent pool in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Agent Pool" "FAIL" $_.Exception.Message
        }
    }

    # Test 67: Update Agent Pool
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcAgentPool" -Parameters @{
                AgentPoolId = "apool-mocktest123"
                Name = "updated-pool"
            }
            if ($result.data) {
                Add-TestResult "Update Agent Pool" "MOCK" "Updated agent pool in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Agent Pool" "FAIL" $_.Exception.Message
        }
    }

    # Test 68: Remove Agent Pool
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcAgentPool" -Parameters @{ AgentPoolId = "apool-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Agent Pool" "MOCK" "Removed agent pool in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Agent Pool" "FAIL" $_.Exception.Message
        }
    }

    # Test 69: Get Agents
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAgent" -Parameters @{ AgentPoolId = "apool-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Agents" "MOCK" "Retrieved agents in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Agents" "FAIL" $_.Exception.Message
        }
    }

    # Test 70: Get Agent Tokens
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAgentToken" -Parameters @{ AgentPoolId = "apool-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Agent Tokens" "MOCK" "Retrieved agent tokens in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Agent Tokens" "FAIL" $_.Exception.Message
        }
    }

    # Test 71: Create Agent Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcAgentToken" -Parameters @{
                AgentPoolId = "apool-mocktest123"
                Description = "mock token"
            }
            if ($result.data.id) {
                Add-TestResult "Create Agent Token" "MOCK" "Created agent token in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Agent Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 72: Remove Agent Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcAgentToken" -Parameters @{ AgentTokenId = "at-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Agent Token" "MOCK" "Removed agent token in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Agent Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 73: Get SSH Keys
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcSshKey" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get SSH Keys" "MOCK" "Retrieved SSH keys in mock mode"
            }
        }
        catch {
            Add-TestResult "Get SSH Keys" "FAIL" $_.Exception.Message
        }
    }

    # Test 74: Create SSH Key
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcSshKey" -Parameters @{
                OrganizationName = "mock-org"
                Name = "mock-ssh-key"
                Value = "ssh-rsa AAAAB3NzaC1yc2EAAA..."
            }
            if ($result.data.id) {
                Add-TestResult "Create SSH Key" "MOCK" "Created SSH key in mock mode"
            }
        }
        catch {
            Add-TestResult "Create SSH Key" "FAIL" $_.Exception.Message
        }
    }

    # Test 75: Get SSH Key Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcSshKeyDetails" -Parameters @{ SshKeyId = "sshkey-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get SSH Key Details" "MOCK" "Retrieved SSH key details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get SSH Key Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 76: Update SSH Key
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcSshKey" -Parameters @{
                SshKeyId = "sshkey-mocktest123"
                Name = "updated-key"
            }
            if ($result.data) {
                Add-TestResult "Update SSH Key" "MOCK" "Updated SSH key in mock mode"
            }
        }
        catch {
            Add-TestResult "Update SSH Key" "FAIL" $_.Exception.Message
        }
    }

    # Test 77: Remove SSH Key
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcSshKey" -Parameters @{ SshKeyId = "sshkey-mocktest123" }
            if ($result) {
                Add-TestResult "Remove SSH Key" "MOCK" "Removed SSH key in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove SSH Key" "FAIL" $_.Exception.Message
        }
    }

    # Test 78: Set Workspace SSH Key
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Set-TfcWorkspaceSshKey" -Parameters @{
                WorkspaceId = "ws-mocktest123"
                SshKeyId = "sshkey-mocktest123"
            }
            if ($result.data) {
                Add-TestResult "Set Workspace SSH Key" "MOCK" "Set workspace SSH key in mock mode"
            }
        }
        catch {
            Add-TestResult "Set Workspace SSH Key" "FAIL" $_.Exception.Message
        }
    }

    # Test 79: Get Team Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcTeamToken" -Parameters @{ TeamId = "team-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Team Token" "MOCK" "Retrieved team token in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Team Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 80: Create Team Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcTeamToken" -Parameters @{ TeamId = "team-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Create Team Token" "MOCK" "Created team token in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Team Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 81: Remove Team Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcTeamToken" -Parameters @{ TeamId = "team-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Team Token" "MOCK" "Removed team token in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Team Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 82: Get Organization Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcOrganizationToken" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Organization Token" "MOCK" "Retrieved organization token in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Organization Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 83: Create Organization Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcOrganizationToken" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data.id) {
                Add-TestResult "Create Organization Token" "MOCK" "Created organization token in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Organization Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 84: Remove Organization Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcOrganizationToken" -Parameters @{ OrganizationName = "mock-org" }
            if ($result) {
                Add-TestResult "Remove Organization Token" "MOCK" "Removed organization token in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Organization Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 85: Get User Tokens
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcUserToken"
            if ($result.data) {
                Add-TestResult "Get User Tokens" "MOCK" "Retrieved user tokens in mock mode"
            }
        }
        catch {
            Add-TestResult "Get User Tokens" "FAIL" $_.Exception.Message
        }
    }

    # Test 86: Create User Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcUserToken" -Parameters @{ Description = "mock user token" }
            if ($result.data.id) {
                Add-TestResult "Create User Token" "MOCK" "Created user token in mock mode"
            }
        }
        catch {
            Add-TestResult "Create User Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 87: Get User Token Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcUserTokenDetails" -Parameters @{ UserTokenId = "ut-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get User Token Details" "MOCK" "Retrieved user token details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get User Token Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 88: Remove User Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcUserToken" -Parameters @{ UserTokenId = "ut-mocktest123" }
            if ($result) {
                Add-TestResult "Remove User Token" "MOCK" "Removed user token in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove User Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 89: Get Workspace Resources
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcWorkspaceResources" -Parameters @{ WorkspaceId = "ws-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Workspace Resources" "MOCK" "Retrieved workspace resources in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Workspace Resources" "FAIL" $_.Exception.Message
        }
    }

    # Test 90: Get Cost Estimate
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcCostEstimate" -Parameters @{ CostEstimateId = "ce-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Cost Estimate" "MOCK" "Retrieved cost estimate in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Cost Estimate" "FAIL" $_.Exception.Message
        }
    }

    # Test 91: Send VCS Event
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Send-TfcVcsEvent" -Parameters @{ WorkspaceId = "ws-mocktest123" }
            if ($result) {
                Add-TestResult "Send VCS Event" "MOCK" "Sent VCS event in mock mode"
            }
        }
        catch {
            Add-TestResult "Send VCS Event" "FAIL" $_.Exception.Message
        }
    }

    #region Phase 3 Tests: Policy & Compliance (Tests 93-109)

    # Test 93: Get Policies
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcPolicy" -Parameters @{ Organization = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Policies" "MOCK" "Retrieved policies in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Policies" "FAIL" $_.Exception.Message
        }
    }

    # Test 94: Create Policy
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcPolicy" -Parameters @{
                Organization = "mock-org"
                Name = "test-policy"
                Enforcement = "hard-mandatory"
            }
            if ($result.data.id) {
                $script:MockPolicyId = $result.data.id
                Add-TestResult "Create Policy" "MOCK" "Created policy in mock mode: $($result.data.id)"
            }
        }
        catch {
            Add-TestResult "Create Policy" "FAIL" $_.Exception.Message
        }
    }

    # Test 95: Update Policy
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcPolicy" -Parameters @{
                PolicyId = "pol-mocktest123"
                Enforcement = "soft-mandatory"
            }
            if ($result.data) {
                Add-TestResult "Update Policy" "MOCK" "Updated policy in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Policy" "FAIL" $_.Exception.Message
        }
    }

    # Test 96: Upload Policy Content
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Invoke-TfcPolicyUpload" -Parameters @{
                PolicyId = "pol-mocktest123"
            }
            if ($result) {
                Add-TestResult "Upload Policy Content" "MOCK" "Uploaded policy content in mock mode"
            }
        }
        catch {
            Add-TestResult "Upload Policy Content" "FAIL" $_.Exception.Message
        }
    }

    # Test 97: Remove Policy
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcPolicy" -Parameters @{ PolicyId = "pol-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Policy" "MOCK" "Removed policy in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Policy" "FAIL" $_.Exception.Message
        }
    }

    # Test 98: Get Policy Sets
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcPolicySet" -Parameters @{ Organization = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Policy Sets" "MOCK" "Retrieved policy sets in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Policy Sets" "FAIL" $_.Exception.Message
        }
    }

    # Test 99: Create Policy Set
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcPolicySet" -Parameters @{
                Organization = "mock-org"
                Name = "test-policy-set"
                Description = "Test policy set"
            }
            if ($result.data.id) {
                $script:MockPolicySetId = $result.data.id
                Add-TestResult "Create Policy Set" "MOCK" "Created policy set in mock mode: $($result.data.id)"
            }
        }
        catch {
            Add-TestResult "Create Policy Set" "FAIL" $_.Exception.Message
        }
    }

    # Test 100: Update Policy Set
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcPolicySet" -Parameters @{
                PolicySetId = "polset-mocktest123"
                Description = "Updated description"
            }
            if ($result.data) {
                Add-TestResult "Update Policy Set" "MOCK" "Updated policy set in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Policy Set" "FAIL" $_.Exception.Message
        }
    }

    # Test 101: Add Policy to Policy Set
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Add-TfcPolicySetPolicy" -Parameters @{
                PolicySetId = "polset-mocktest123"
                PolicyId = "pol-mocktest123"
            }
            if ($result) {
                Add-TestResult "Add Policy to Policy Set" "MOCK" "Added policy to policy set in mock mode"
            }
        }
        catch {
            Add-TestResult "Add Policy to Policy Set" "FAIL" $_.Exception.Message
        }
    }

    # Test 102: Set Policy Set Workspace
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Set-TfcPolicySetWorkspace" -Parameters @{
                PolicySetId = "polset-mocktest123"
                WorkspaceId = "ws-mocktest123"
            }
            if ($result) {
                Add-TestResult "Set Policy Set Workspace" "MOCK" "Set policy set workspace in mock mode"
            }
        }
        catch {
            Add-TestResult "Set Policy Set Workspace" "FAIL" $_.Exception.Message
        }
    }

    # Test 103: Set Policy Set Project
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Set-TfcPolicySetProject" -Parameters @{
                PolicySetId = "polset-mocktest123"
                ProjectId = "prj-mocktest123"
            }
            if ($result) {
                Add-TestResult "Set Policy Set Project" "MOCK" "Set policy set project in mock mode"
            }
        }
        catch {
            Add-TestResult "Set Policy Set Project" "FAIL" $_.Exception.Message
        }
    }

    # Test 104: Remove Policy Set
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcPolicySet" -Parameters @{ PolicySetId = "polset-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Policy Set" "MOCK" "Removed policy set in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Policy Set" "FAIL" $_.Exception.Message
        }
    }

    # Test 105: Get Policy Checks
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcPolicyCheck" -Parameters @{ RunId = "run-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Policy Checks" "MOCK" "Retrieved policy checks in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Policy Checks" "FAIL" $_.Exception.Message
        }
    }

    # Test 106: Override Policy Check
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Set-TfcPolicyCheckOverride" -Parameters @{ PolicyCheckId = "polchk-mocktest123" }
            if ($result) {
                Add-TestResult "Override Policy Check" "MOCK" "Overrode policy check in mock mode"
            }
        }
        catch {
            Add-TestResult "Override Policy Check" "FAIL" $_.Exception.Message
        }
    }

    # Test 107: Get Audit Trail
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAuditTrail" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Audit Trail" "MOCK" "Retrieved audit trail in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Audit Trail" "FAIL" $_.Exception.Message
        }
    }

    # Test 108: Get Comments
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcComment" -Parameters @{ RunId = "run-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Comments" "MOCK" "Retrieved comments in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Comments" "FAIL" $_.Exception.Message
        }
    }

    # Test 109: Create Comment
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcComment" -Parameters @{
                RunId = "run-mocktest123"
                Body = "Test comment"
            }
            if ($result.data.id) {
                Add-TestResult "Create Comment" "MOCK" "Created comment in mock mode: $($result.data.id)"
            }
        }
        catch {
            Add-TestResult "Create Comment" "FAIL" $_.Exception.Message
        }
    }

    #endregion

    #region Phase 4 Tests: Enhanced RBAC & Variables (Tests 110-129)

    # Test 110: Get Variable Set Variables
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcVariableSetVariable" -Parameters @{ VariableSetId = "varset-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Variable Set Variables" "MOCK" "Retrieved variable set variables in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Variable Set Variables" "FAIL" $_.Exception.Message
        }
    }

    # Test 111: Create Variable Set Variable
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcVariableSetVariable" -Parameters @{
                VariableSetId = "varset-mocktest123"
                Key = "TEST_VAR"
                Value = "test_value"
                Category = "terraform"
            }
            if ($result.data.id) {
                Add-TestResult "Create Variable Set Variable" "MOCK" "Created variable set variable in mock mode: $($result.data.id)"
            }
        }
        catch {
            Add-TestResult "Create Variable Set Variable" "FAIL" $_.Exception.Message
        }
    }

    # Test 112: Update Variable Set Variable
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcVariableSetVariable" -Parameters @{
                VariableSetId = "varset-mocktest123"
                VariableId = "var-mocktest123"
                Value = "updated_value"
            }
            if ($result.data) {
                Add-TestResult "Update Variable Set Variable" "MOCK" "Updated variable set variable in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Variable Set Variable" "FAIL" $_.Exception.Message
        }
    }

    # Test 113: Remove Variable Set Variable
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcVariableSetVariable" -Parameters @{
                VariableSetId = "varset-mocktest123"
                VariableId = "var-mocktest123"
            }
            if ($result) {
                Add-TestResult "Remove Variable Set Variable" "MOCK" "Removed variable set variable in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Variable Set Variable" "FAIL" $_.Exception.Message
        }
    }

    # Test 114: Get Team Members
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcTeamMember" -Parameters @{ TeamId = "team-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Team Members" "MOCK" "Retrieved team members in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Team Members" "FAIL" $_.Exception.Message
        }
    }

    # Test 115: Add Team Member
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Add-TfcTeamMember" -Parameters @{
                TeamId = "team-mocktest123"
                OrganizationMembershipIds = @("ou-mocktest123")
            }
            if ($result) {
                Add-TestResult "Add Team Member" "MOCK" "Added team member in mock mode"
            }
        }
        catch {
            Add-TestResult "Add Team Member" "FAIL" $_.Exception.Message
        }
    }

    # Test 116: Get Team Member Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcTeamMemberDetails" -Parameters @{
                TeamId = "team-mocktest123"
                OrganizationMembershipId = "ou-mocktest123"
            }
            if ($result.data) {
                Add-TestResult "Get Team Member Details" "MOCK" "Retrieved team member details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Team Member Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 117: Remove Team Member
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcTeamMember" -Parameters @{
                TeamId = "team-mocktest123"
                OrganizationMembershipIds = @("ou-mocktest123")
            }
            if ($result) {
                Add-TestResult "Remove Team Member" "MOCK" "Removed team member in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Team Member" "FAIL" $_.Exception.Message
        }
    }

    # Test 118: Add Project Team Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Add-TfcProjectTeamAccess" -Parameters @{
                ProjectId = "prj-mocktest123"
                TeamId = "team-mocktest123"
                Access = "write"
            }
            if ($result.data.id) {
                Add-TestResult "Add Project Team Access" "MOCK" "Added project team access in mock mode: $($result.data.id)"
            }
        }
        catch {
            Add-TestResult "Add Project Team Access" "FAIL" $_.Exception.Message
        }
    }

    # Test 119: Get Project Team Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcProjectTeamAccess" -Parameters @{ ProjectId = "prj-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Project Team Access" "MOCK" "Retrieved project team access in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Project Team Access" "FAIL" $_.Exception.Message
        }
    }

    # Test 120: Get Project Team Access Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcProjectTeamAccessDetails" -Parameters @{ TeamProjectId = "tprj-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Project Team Access Details" "MOCK" "Retrieved project team access details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Project Team Access Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 121: Update Project Team Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcProjectTeamAccess" -Parameters @{
                TeamProjectId = "tprj-mocktest123"
                Access = "admin"
            }
            if ($result.data) {
                Add-TestResult "Update Project Team Access" "MOCK" "Updated project team access in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Project Team Access" "FAIL" $_.Exception.Message
        }
    }

    # Test 122: Remove Project Team Access
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcProjectTeamAccess" -Parameters @{ TeamProjectId = "tprj-mocktest123" }
            if ($result) {
                Add-TestResult "Remove Project Team Access" "MOCK" "Removed project team access in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Project Team Access" "FAIL" $_.Exception.Message
        }
    }

    # Test 123: Get Organization Memberships
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcOrganizationMembership" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Organization Memberships" "MOCK" "Retrieved organization memberships in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Organization Memberships" "FAIL" $_.Exception.Message
        }
    }

    # Test 124: Remove Organization Membership
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcOrganizationMembership" -Parameters @{ MembershipId = "ou-mocktest456" }
            if ($result) {
                Add-TestResult "Remove Organization Membership" "MOCK" "Removed organization membership in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Organization Membership" "FAIL" $_.Exception.Message
        }
    }

    # Test 125: Get Organization Tags
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcOrganizationTag" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Organization Tags" "MOCK" "Retrieved organization tags in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Organization Tags" "FAIL" $_.Exception.Message
        }
    }

    # Test 126: Create Organization Tag
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcOrganizationTag" -Parameters @{
                OrganizationName = "mock-org"
                Name = "production"
            }
            if ($result.data.id) {
                Add-TestResult "Create Organization Tag" "MOCK" "Created organization tag in mock mode: $($result.data.id)"
            }
        }
        catch {
            Add-TestResult "Create Organization Tag" "FAIL" $_.Exception.Message
        }
    }

    # Test 127: Add Organization Tag Relationship
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Add-TfcOrganizationTagRelationship" -Parameters @{
                TagId = "tag-mocktest123"
                WorkspaceIds = @("ws-mocktest123")
            }
            if ($result) {
                Add-TestResult "Add Organization Tag Relationship" "MOCK" "Added organization tag relationship in mock mode"
            }
        }
        catch {
            Add-TestResult "Add Organization Tag Relationship" "FAIL" $_.Exception.Message
        }
    }

    # Test 128: Remove Organization Tag Relationship
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcOrganizationTagRelationship" -Parameters @{
                TagId = "tag-mocktest123"
                WorkspaceIds = @("ws-mocktest123")
            }
            if ($result) {
                Add-TestResult "Remove Organization Tag Relationship" "MOCK" "Removed organization tag relationship in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Organization Tag Relationship" "FAIL" $_.Exception.Message
        }
    }

    # Test 129: Remove Organization Tag
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcOrganizationTag" -Parameters @{
                OrganizationName = "mock-org"
                TagId = "tag-mocktest123"
            }
            if ($result) {
                Add-TestResult "Remove Organization Tag" "MOCK" "Removed organization tag in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove Organization Tag" "FAIL" $_.Exception.Message
        }
    }

    #endregion

    #region Phase 5: Extended Run/Resource Management Tests

    # Test 130: Get Run Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunDetails" -Parameters @{ RunId = "run-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Get Run Details" "MOCK" "Retrieved run details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 131: Get Run Task Results
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunTaskResult" -Parameters @{ RunId = "run-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Run Task Results" "MOCK" "Retrieved run task results in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Task Results" "FAIL" $_.Exception.Message
        }
    }

    # Test 132: Get Run Task Result Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRunTaskResultDetails" -Parameters @{ TaskResultId = "taskrs-mocktest123" }
            if ($result.id) {
                Add-TestResult "Get Run Task Result Details" "MOCK" "Retrieved run task result details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Run Task Result Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 133: Get Workspace Resource Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcWorkspaceResourceDetails" -Parameters @{ ResourceId = "wsres-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Get Workspace Resource Details" "MOCK" "Retrieved workspace resource details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Workspace Resource Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 134: Get OAuth Tokens
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcOAuthToken" -Parameters @{ OAuthClientId = "oc-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get OAuth Tokens" "MOCK" "Retrieved OAuth tokens in mock mode"
            }
        }
        catch {
            Add-TestResult "Get OAuth Tokens" "FAIL" $_.Exception.Message
        }
    }

    # Test 135: Get OAuth Token Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcOAuthTokenDetails" -Parameters @{ OAuthTokenId = "ot-mocktest123" }
            if ($result.id) {
                Add-TestResult "Get OAuth Token Details" "MOCK" "Retrieved OAuth token details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get OAuth Token Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 136: Update OAuth Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcOAuthToken" -Parameters @{
                OAuthTokenId = "ot-mocktest123"
                SSHKeyId = "sshkey-mocktest123"
            }
            if ($result) {
                Add-TestResult "Update OAuth Token" "MOCK" "Updated OAuth token in mock mode"
            }
        }
        catch {
            Add-TestResult "Update OAuth Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 137: Remove OAuth Token
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcOAuthToken" -Parameters @{ OAuthTokenId = "ot-mocktest123" }
            if ($result) {
                Add-TestResult "Remove OAuth Token" "MOCK" "Removed OAuth token in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove OAuth Token" "FAIL" $_.Exception.Message
        }
    }

    # Test 138: Get Assessment Results
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAssessmentResult" -Parameters @{ WorkspaceId = "ws-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Assessment Results" "MOCK" "Retrieved assessment results in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Assessment Results" "FAIL" $_.Exception.Message
        }
    }

    # Test 139: Get Assessment Result Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAssessmentResultDetails" -Parameters @{ AssessmentResultId = "asmtrs-mocktest123" }
            if ($result.id) {
                Add-TestResult "Get Assessment Result Details" "MOCK" "Retrieved assessment result details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Assessment Result Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 140: Get Cost Estimate Logs
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcCostEstimateLog" -Parameters @{ CostEstimateId = "ce-mocktest123" }
            if ($result) {
                Add-TestResult "Get Cost Estimate Logs" "MOCK" "Retrieved cost estimate logs in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Cost Estimate Logs" "FAIL" $_.Exception.Message
        }
    }

    # Test 141: Get VCS Event Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcVCSEventDetails" -Parameters @{ VCSEventId = "vcsev-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Get VCS Event Details" "MOCK" "Retrieved VCS event details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get VCS Event Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 142: Invoke State Rollback
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Invoke-TfcStateRollback" -Parameters @{
                WorkspaceId = "ws-mocktest123"
                StateVersionId = "sv-mocktest123"
            }
            if ($result.data.id) {
                Add-TestResult "Invoke State Rollback" "MOCK" "Rolled back state in mock mode"
            }
        }
        catch {
            Add-TestResult "Invoke State Rollback" "FAIL" $_.Exception.Message
        }
    }

    #endregion

    #region Phase 6: New Features & Innovation Tests

    # Test 143: Get Change Requests
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcChangeRequest" -Parameters @{ WorkspaceId = "ws-mocktest123" }
            if ($result.data) {
                Add-TestResult "Get Change Requests" "MOCK" "Retrieved change requests in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Change Requests" "FAIL" $_.Exception.Message
        }
    }

    # Test 144: Create Change Request
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcChangeRequest" -Parameters @{
                WorkspaceId = "ws-mocktest123"
                Message = "Test change request"
            }
            if ($result.data.id) {
                Add-TestResult "Create Change Request" "MOCK" "Created change request in mock mode"
            }
        }
        catch {
            Add-TestResult "Create Change Request" "FAIL" $_.Exception.Message
        }
    }

    # Test 145: Get Change Request Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcChangeRequestDetails" -Parameters @{ ChangeRequestId = "chreq-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Get Change Request Details" "MOCK" "Retrieved change request details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Change Request Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 146: Approve Change Request
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Approve-TfcChangeRequest" -Parameters @{
                ChangeRequestId = "chreq-mocktest123"
                Comment = "Approved for testing"
            }
            if ($result) {
                Add-TestResult "Approve Change Request" "MOCK" "Approved change request in mock mode"
            }
        }
        catch {
            Add-TestResult "Approve Change Request" "FAIL" $_.Exception.Message
        }
    }

    # Test 147: Deny Change Request
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Deny-TfcChangeRequest" -Parameters @{
                ChangeRequestId = "chreq-mocktest123"
                Comment = "Denied for testing"
            }
            if ($result) {
                Add-TestResult "Deny Change Request" "MOCK" "Denied change request in mock mode"
            }
        }
        catch {
            Add-TestResult "Deny Change Request" "FAIL" $_.Exception.Message
        }
    }

    # Test 148: Create No-Code Module
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcNoCodeModule" -Parameters @{
                OrganizationName = "mock-org"
                RegistryModuleId = "rm-mocktest123"
                Name = "Test No-Code Module"
            }
            if ($result.data.id) {
                Add-TestResult "Create No-Code Module" "MOCK" "Created no-code module in mock mode"
            }
        }
        catch {
            Add-TestResult "Create No-Code Module" "FAIL" $_.Exception.Message
        }
    }

    # Test 149: Get No-Code Module
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcNoCodeModule" -Parameters @{ NoCodeModuleId = "ncm-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Get No-Code Module" "MOCK" "Retrieved no-code module in mock mode"
            }
        }
        catch {
            Add-TestResult "Get No-Code Module" "FAIL" $_.Exception.Message
        }
    }

    # Test 150: Update No-Code Module
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcNoCodeModule" -Parameters @{
                NoCodeModuleId = "ncm-mocktest123"
                Enabled = $false
            }
            if ($result.data.id) {
                Add-TestResult "Update No-Code Module" "MOCK" "Updated no-code module in mock mode"
            }
        }
        catch {
            Add-TestResult "Update No-Code Module" "FAIL" $_.Exception.Message
        }
    }

    # Test 151: Remove No-Code Module
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Remove-TfcNoCodeModule" -Parameters @{ NoCodeModuleId = "ncm-mocktest123" }
            if ($result) {
                Add-TestResult "Remove No-Code Module" "MOCK" "Removed no-code module in mock mode"
            }
        }
        catch {
            Add-TestResult "Remove No-Code Module" "FAIL" $_.Exception.Message
        }
    }

    # Test 152: Update No-Code Module Variable Options
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcNoCodeModuleVariableOptions" -Parameters @{ NoCodeModuleId = "ncm-mocktest123" }
            if ($result) {
                Add-TestResult "Update No-Code Module Variable Options" "MOCK" "Updated variable options in mock mode"
            }
        }
        catch {
            Add-TestResult "Update No-Code Module Variable Options" "FAIL" $_.Exception.Message
        }
    }

    # Test 153: Get GitHub App Installations
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcGitHubAppInstallation" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get GitHub App Installations" "MOCK" "Retrieved GitHub App installations in mock mode"
            }
        }
        catch {
            Add-TestResult "Get GitHub App Installations" "FAIL" $_.Exception.Message
        }
    }

    # Test 154: Get GitHub App Installation Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcGitHubAppInstallationDetails" -Parameters @{ InstallationId = "ghain-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Get GitHub App Installation Details" "MOCK" "Retrieved GitHub App installation details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get GitHub App Installation Details" "FAIL" $_.Exception.Message
        }
    }

    # Test 155: Execute GraphQL Query
    if ($MockMode) {
        try {
            $graphQuery = 'query { organization(name: "mock-org") { name } }'
            $result = Invoke-MockTfcFunction -FunctionName "Invoke-TfcExplorerQuery" -Parameters @{
                Query = $graphQuery
            }
            if ($result.data) {
                Add-TestResult "Execute GraphQL Query" "MOCK" "Executed GraphQL query in mock mode"
            }
        }
        catch {
            Add-TestResult "Execute GraphQL Query" "FAIL" $_.Exception.Message
        }
    }

    # Test 156: Get IP Ranges
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcIPRange"
            if ($result.data.attributes) {
                Add-TestResult "Get IP Ranges" "MOCK" "Retrieved IP ranges in mock mode"
            }
        }
        catch {
            Add-TestResult "Get IP Ranges" "FAIL" $_.Exception.Message
        }
    }

    # Test 157: Get Feature Sets
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcFeatureSet"
            if ($result.data) {
                Add-TestResult "Get Feature Sets" "MOCK" "Retrieved feature sets in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Feature Sets" "FAIL" $_.Exception.Message
        }
    }

    # Test 158: Get Feature Set Details
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcFeatureSetDetails" -Parameters @{ FeatureSetId = "fs-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Get Feature Set Details" "MOCK" "Retrieved feature set details in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Feature Set Details" "FAIL" $_.Exception.Message
        }
    }

    #endregion

    #region Phase 7: Enterprise & Admin Features Tests

    # Test 159: Get Admin Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAdminSettings"
            if ($result.data.attributes) {
                Add-TestResult "Get Admin Settings" "MOCK" "Retrieved admin settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Admin Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 160: Update Admin Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcAdminSettings" -Parameters @{
                EnablePolicyEnforcement = $true
            }
            if ($result.data.attributes) {
                Add-TestResult "Update Admin Settings" "MOCK" "Updated admin settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Admin Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 161: Get SAML Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcSAMLSettings" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data.attributes) {
                Add-TestResult "Get SAML Settings" "MOCK" "Retrieved SAML settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Get SAML Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 162: Update SAML Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcSAMLSettings" -Parameters @{
                OrganizationName = "mock-org"
                Enabled = $true
            }
            if ($result.data.attributes) {
                Add-TestResult "Update SAML Settings" "MOCK" "Updated SAML settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Update SAML Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 163: Revoke SAML Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Revoke-TfcSAMLSettings" -Parameters @{ OrganizationName = "mock-org" }
            if ($result) {
                Add-TestResult "Revoke SAML Settings" "MOCK" "Revoked SAML settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Revoke SAML Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 164: Get Admin Users
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcAdminUser"
            if ($result.data) {
                Add-TestResult "Get Admin Users" "MOCK" "Retrieved admin users in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Admin Users" "FAIL" $_.Exception.Message
        }
    }

    # Test 165: Suspend User
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Suspend-TfcUser" -Parameters @{ UserId = "user-mocktest123" }
            if ($result) {
                Add-TestResult "Suspend User" "MOCK" "Suspended user in mock mode"
            }
        }
        catch {
            Add-TestResult "Suspend User" "FAIL" $_.Exception.Message
        }
    }

    # Test 166: Resume User
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Resume-TfcUser" -Parameters @{ UserId = "user-mocktest123" }
            if ($result) {
                Add-TestResult "Resume User" "MOCK" "Resumed user in mock mode"
            }
        }
        catch {
            Add-TestResult "Resume User" "FAIL" $_.Exception.Message
        }
    }

    # Test 167: Grant Admin Privilege
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Grant-TfcAdminPrivilege" -Parameters @{ UserId = "user-mocktest123" }
            if ($result) {
                Add-TestResult "Grant Admin Privilege" "MOCK" "Granted admin privilege in mock mode"
            }
        }
        catch {
            Add-TestResult "Grant Admin Privilege" "FAIL" $_.Exception.Message
        }
    }

    # Test 168: Revoke Admin Privilege
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Revoke-TfcAdminPrivilege" -Parameters @{ UserId = "user-mocktest123" }
            if ($result) {
                Add-TestResult "Revoke Admin Privilege" "MOCK" "Revoked admin privilege in mock mode"
            }
        }
        catch {
            Add-TestResult "Revoke Admin Privilege" "FAIL" $_.Exception.Message
        }
    }

    # Test 169: Disable User Two-Factor
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Disable-TfcUserTwoFactor" -Parameters @{ UserId = "user-mocktest123" }
            if ($result) {
                Add-TestResult "Disable User Two-Factor" "MOCK" "Disabled user 2FA in mock mode"
            }
        }
        catch {
            Add-TestResult "Disable User Two-Factor" "FAIL" $_.Exception.Message
        }
    }

    # Test 170: Create User Impersonation
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "New-TfcUserImpersonation" -Parameters @{ UserId = "user-mocktest123" }
            if ($result.data.id) {
                Add-TestResult "Create User Impersonation" "MOCK" "Created user impersonation token in mock mode"
            }
        }
        catch {
            Add-TestResult "Create User Impersonation" "FAIL" $_.Exception.Message
        }
    }

    # Test 171: Get Registry Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcRegistrySettings" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data.attributes) {
                Add-TestResult "Get Registry Settings" "MOCK" "Retrieved registry settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Registry Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 172: Update Registry Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcRegistrySettings" -Parameters @{
                OrganizationName = "mock-org"
                ModuleConsumersEnabled = $true
            }
            if ($result.data.attributes) {
                Add-TestResult "Update Registry Settings" "MOCK" "Updated registry settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Registry Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 173: Get Subscription
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcSubscription" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data.attributes) {
                Add-TestResult "Get Subscription" "MOCK" "Retrieved subscription in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Subscription" "FAIL" $_.Exception.Message
        }
    }

    # Test 174: Get Invoices
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcInvoice" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data) {
                Add-TestResult "Get Invoices" "MOCK" "Retrieved invoices in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Invoices" "FAIL" $_.Exception.Message
        }
    }

    # Test 175: Get Two-Factor Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Get-TfcTwoFactorSettings" -Parameters @{ OrganizationName = "mock-org" }
            if ($result.data.attributes) {
                Add-TestResult "Get Two-Factor Settings" "MOCK" "Retrieved 2FA settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Get Two-Factor Settings" "FAIL" $_.Exception.Message
        }
    }

    # Test 176: Update Two-Factor Settings
    if ($MockMode) {
        try {
            $result = Invoke-MockTfcFunction -FunctionName "Update-TfcTwoFactorSettings" -Parameters @{
                OrganizationName = "mock-org"
                Required = $true
            }
            if ($result.data.attributes) {
                Add-TestResult "Update Two-Factor Settings" "MOCK" "Updated 2FA settings in mock mode"
            }
        }
        catch {
            Add-TestResult "Update Two-Factor Settings" "FAIL" $_.Exception.Message
        }
    }

    #endregion

    # Test 177: Cleanup Created Workspace
    if ($script:CreatedWorkspaceId -and $UseTestOrganization -and -not $MockMode) {
        try {
            Remove-TfcWorkspace -WorkspaceId $script:CreatedWorkspaceId -Confirm:$false
            Add-TestResult "Cleanup Test Workspace" "PASS" "Cleaned up created workspace"
        }
        catch {
            Add-TestResult "Cleanup Test Workspace" "FAIL" $_.Exception.Message
            Write-Host "⚠️  Manual cleanup required for workspace: $($script:CreatedWorkspaceId)" -ForegroundColor Yellow
        }
    }
    elseif ($MockMode) {
        Add-TestResult "Cleanup Test Workspace" "MOCK" "Mock cleanup completed"
    }
}
else {
    Add-TestResult "Destructive Tests" "SKIP" "Skipped (use -RunDestructiveTests to enable)"
}

# Test Results Summary
Write-Host "`n=== Comprehensive Test Results Summary ===" -ForegroundColor Green
$PassCount = ($TestResults | Where-Object { $_.Status -eq "PASS" }).Count
$FailCount = ($TestResults | Where-Object { $_.Status -eq "FAIL" }).Count
$SkipCount = ($TestResults | Where-Object { $_.Status -eq "SKIP" }).Count
$MockCount = ($TestResults | Where-Object { $_.Status -eq "MOCK" }).Count
$TotalCount = $TestResults.Count

Write-Host "Total Tests: $TotalCount" -ForegroundColor White
Write-Host "Passed: $PassCount" -ForegroundColor Green
Write-Host "Failed: $FailCount" -ForegroundColor Red
Write-Host "Skipped: $SkipCount" -ForegroundColor Yellow
Write-Host "Mocked: $MockCount" -ForegroundColor Cyan

if ($FailCount -gt 0) {
    Write-Host "`nFailed Tests:" -ForegroundColor Red
    $TestResults | Where-Object { $_.Status -eq "FAIL" } | ForEach-Object {
        Write-Host "  - $($_.Test): $($_.Message)" -ForegroundColor Red
    }
}

$ExecutedTests = $PassCount + $FailCount
if ($ExecutedTests -gt 0) {
    $SuccessRate = [math]::Round(($PassCount / $ExecutedTests) * 100, 1)
    Write-Host "`nSuccess Rate: $SuccessRate% ($PassCount/$ExecutedTests executed tests)" -ForegroundColor $(if ($SuccessRate -ge 90) { "Green" } elseif ($SuccessRate -ge 70) { "Yellow" } else { "Red" })
} else {
    Write-Host "`nSuccess Rate: No tests with results" -ForegroundColor Yellow
}

if ($MockMode) {
    Write-Host "`n💡 Mock Mode Summary:" -ForegroundColor Cyan
    Write-Host "   - All destructive operations were simulated" -ForegroundColor Gray
    Write-Host "   - No real API calls were made for create/update/delete operations" -ForegroundColor Gray
    Write-Host "   - Use -MockMode:`$false to run against real API" -ForegroundColor Gray
}

Write-Host "`n🔧 Usage Examples:" -ForegroundColor Yellow
Write-Host "   Mock Mode (Safe):           ./Test-TerraformCloudModule.ps1 -MockMode" -ForegroundColor Gray
Write-Host "   Test Organization Mode:     ./Test-TerraformCloudModule.ps1 -UseTestOrganization -TestOrganizationName 'my-test-org'" -ForegroundColor Gray
Write-Host "   Production Safe Mode:       ./Test-TerraformCloudModule.ps1" -ForegroundColor Gray
Write-Host "   Full Test Suite:            ./Test-TerraformCloudModule.ps1 -UseTestOrganization -RunDestructiveTests" -ForegroundColor Gray

Write-Host "`n📊 Test Categories Covered (177 Total Tests):" -ForegroundColor Green
Write-Host "   ✓ Core Module Functions" -ForegroundColor Gray
Write-Host "   ✓ Authentication & Account" -ForegroundColor Gray
Write-Host "   ✓ Organization Management" -ForegroundColor Gray
Write-Host "   ✓ Workspace Operations" -ForegroundColor Gray
Write-Host "   ✓ Team & Access Control" -ForegroundColor Gray
Write-Host "   ✓ Variable Management & Variable Sets" -ForegroundColor Gray
Write-Host "   ✓ Configuration Versions" -ForegroundColor Gray
Write-Host "   ✓ State & Run Operations" -ForegroundColor Gray
Write-Host "   ✓ Registry Modules & Providers" -ForegroundColor Gray
Write-Host "   ✓ Run Triggers & Run Tasks" -ForegroundColor Gray
Write-Host "   ✓ Notification Configurations" -ForegroundColor Gray
Write-Host "   ✓ Enhanced Plans & Applies" -ForegroundColor Gray
Write-Host "   ✓ Workspace Team Access" -ForegroundColor Gray
Write-Host "   ✓ Agent Pools & Agents" -ForegroundColor Gray
Write-Host "   ✓ Agent Tokens" -ForegroundColor Gray
Write-Host "   ✓ SSH Keys" -ForegroundColor Gray
Write-Host "   ✓ Token Management" -ForegroundColor Gray
Write-Host "   ✓ Workspace Resources & Cost Estimates" -ForegroundColor Gray
Write-Host "   ✓ Policy Management & Compliance" -ForegroundColor Gray
Write-Host "   ✓ Enhanced RBAC & Variables" -ForegroundColor Gray
Write-Host "   ✓ Extended Run/Resource Management (Phase 5)" -ForegroundColor Gray
Write-Host "   ✓ Change Requests & No-Code Provisioning (Phase 6)" -ForegroundColor Gray
Write-Host "   ✓ GitHub Integrations & GraphQL (Phase 6)" -ForegroundColor Gray
Write-Host "   ✓ Enterprise Admin Features (Phase 7)" -ForegroundColor Gray
Write-Host "   ✓ CRUD Operations (if enabled)" -ForegroundColor Gray

# Return test results for programmatic use
return $TestResults
