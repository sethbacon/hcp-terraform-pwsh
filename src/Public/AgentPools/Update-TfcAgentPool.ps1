<#
.SYNOPSIS
    Updates an agent pool
.DESCRIPTION
    Updates an existing agent pool. Supports updating allowed-projects and
    excluded-workspaces relationships.
.PARAMETER AgentPoolId
    The agent pool ID
.PARAMETER Name
    New name for the pool
.PARAMETER OrganizationScoped
    Whether the pool is available to all workspaces
.PARAMETER AllowedProjects
    Array of project IDs allowed to use this pool (replaces the existing list)
.PARAMETER ExcludedWorkspaces
    Array of workspace IDs that should NOT use this pool (replaces the existing list)
.EXAMPLE
    Update-TfcAgentPool -AgentPoolId "apool-abc123" -Name "new-name"
.EXAMPLE
    Update-TfcAgentPool -AgentPoolId "apool-abc123" -AllowedProjects @("prj-xyz789")
.OUTPUTS
    PSCustomObject representing the updated agent pool
#>
function Update-TfcAgentPool {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentPoolId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [bool]$OrganizationScoped,

        [Parameter(Mandatory = $false)]
        [string[]]$AllowedProjects,

        [Parameter(Mandatory = $false)]
        [string[]]$ExcludedWorkspaces
    )

    $attributes = @{}
    if ($PSBoundParameters.ContainsKey('Name')) { $attributes['name'] = $Name }
    if ($PSBoundParameters.ContainsKey('OrganizationScoped')) { $attributes['organization-scoped'] = $OrganizationScoped }

    $relationships = @{}
    if ($PSBoundParameters.ContainsKey('AllowedProjects')) {
        $relationships['allowed-projects'] = @{
            data = @($AllowedProjects | ForEach-Object { @{ type = 'projects'; id = $_ } })
        }
    }
    if ($PSBoundParameters.ContainsKey('ExcludedWorkspaces')) {
        $relationships['excluded-workspaces'] = @{
            data = @($ExcludedWorkspaces | ForEach-Object { @{ type = 'workspaces'; id = $_ } })
        }
    }

    if ($attributes.Count -eq 0 -and $relationships.Count -eq 0) {
        throw "At least one attribute or relationship must be specified for update"
    }

    $data = @{ type = "agent-pools" }
    if ($attributes.Count -gt 0) { $data['attributes'] = $attributes }
    if ($relationships.Count -gt 0) { $data['relationships'] = $relationships }

    $body = @{ data = $data } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating agent pool: $AgentPoolId"
    if ($PSCmdlet.ShouldProcess("Agent Pool: $AgentPoolId", "Update agent pool")) {
        return Invoke-TfcApi -Uri "/agent-pools/$AgentPoolId" -Method PATCH -Body $body
    }
}
