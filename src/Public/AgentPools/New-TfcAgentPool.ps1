<#
.SYNOPSIS
    Creates an agent pool
.DESCRIPTION
    Creates a new agent pool for self-hosted agents. Supports scoping the pool to
    specific projects (allowed-projects) and excluding specific workspaces from
    using it (excluded-workspaces).
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The agent pool name
.PARAMETER OrganizationScoped
    Whether the pool is available to all workspaces (default: true)
.PARAMETER AllowedProjects
    Array of project IDs allowed to use this pool (only when -OrganizationScoped:$false)
.PARAMETER ExcludedWorkspaces
    Array of workspace IDs that should NOT use this pool
.EXAMPLE
    New-TfcAgentPool -Organization "my-org" -Name "production-agents"
.EXAMPLE
    New-TfcAgentPool -Organization "my-org" -Name "scoped-pool" -OrganizationScoped $false -AllowedProjects @("prj-abc123")
.OUTPUTS
    PSCustomObject representing the created agent pool
#>
function New-TfcAgentPool {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [bool]$OrganizationScoped = $true,

        [Parameter(Mandatory = $false)]
        [string[]]$AllowedProjects,

        [Parameter(Mandatory = $false)]
        [string[]]$ExcludedWorkspaces
    )

    $data = @{
        type = "agent-pools"
        attributes = @{
            name = $Name
            'organization-scoped' = $OrganizationScoped
        }
    }

    $relationships = @{}
    if ($AllowedProjects) {
        $relationships['allowed-projects'] = @{
            data = @($AllowedProjects | ForEach-Object { @{ type = 'projects'; id = $_ } })
        }
    }
    if ($ExcludedWorkspaces) {
        $relationships['excluded-workspaces'] = @{
            data = @($ExcludedWorkspaces | ForEach-Object { @{ type = 'workspaces'; id = $_ } })
        }
    }
    if ($relationships.Count -gt 0) {
        $data['relationships'] = $relationships
    }

    $body = @{ data = $data } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating agent pool '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create agent pool: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/agent-pools" -Method POST -Body $body
    }
}
