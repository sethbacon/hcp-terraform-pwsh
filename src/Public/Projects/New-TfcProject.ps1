<#
.SYNOPSIS
    Creates a new project
.DESCRIPTION
    Creates a new project in a Terraform Cloud organization. Supports project-level
    defaults that inherit to workspaces (execution mode, agent pool, auto-destroy).
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The project name
.PARAMETER Description
    Optional description for the project
.PARAMETER DefaultExecutionMode
    Project-level default execution mode for workspaces: 'remote', 'local', or 'agent'
.PARAMETER DefaultAgentPoolId
    Default agent pool ID (required when DefaultExecutionMode is 'agent')
.PARAMETER AutoDestroyActivityDuration
    Inactivity duration before auto-destroy (e.g., "14d", "30d")
.EXAMPLE
    New-TfcProject -Organization "my-org" -Name "production" -Description "Production workspaces"
.EXAMPLE
    New-TfcProject -Organization "my-org" -Name "agent-project" -DefaultExecutionMode "agent" -DefaultAgentPoolId "apool-abc123"
.OUTPUTS
    PSCustomObject representing the created project
#>
function New-TfcProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [ValidateSet('remote', 'local', 'agent')]
        [string]$DefaultExecutionMode,

        [Parameter(Mandatory = $false)]
        [string]$DefaultAgentPoolId,

        [Parameter(Mandatory = $false)]
        [string]$AutoDestroyActivityDuration
    )

    $attributes = @{
        name = $Name
    }

    if ($Description) { $attributes['description'] = $Description }
    if ($DefaultExecutionMode) { $attributes['default-execution-mode'] = $DefaultExecutionMode }
    if ($AutoDestroyActivityDuration) { $attributes['auto-destroy-activity-duration'] = $AutoDestroyActivityDuration }

    $data = @{
        type = "projects"
        attributes = $attributes
    }

    if ($DefaultAgentPoolId) {
        $data['relationships'] = @{
            'default-agent-pool' = @{
                data = @{ type = 'agent-pools'; id = $DefaultAgentPoolId }
            }
        }
    }

    $body = @{ data = $data } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating project '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create project: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/projects" -Method POST -Body $body
    }
}
