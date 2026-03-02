<#
.SYNOPSIS
    Updates an agent pool
.DESCRIPTION
    Updates an existing agent pool
.PARAMETER AgentPoolId
    The agent pool ID
.PARAMETER Name
    New name for the pool
.PARAMETER OrganizationScoped
    Whether the pool is available to all workspaces
.EXAMPLE
    Update-TfcAgentPool -AgentPoolId "apool-abc123" -Name "new-name"
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
        [bool]$OrganizationScoped
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('Name')) { $attributes['name'] = $Name }
    if ($PSBoundParameters.ContainsKey('OrganizationScoped')) { $attributes['organization-scoped'] = $OrganizationScoped }

    if ($attributes.Count -eq 0) {
        throw "At least one attribute must be specified for update"
    }

    $body = @{
        data = @{
            type = "agent-pools"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating agent pool: $AgentPoolId"
    if ($PSCmdlet.ShouldProcess("Agent Pool: $AgentPoolId", "Update agent pool")) {
        return Invoke-TfcApi -Uri "/agent-pools/$AgentPoolId" -Method PATCH -Body $body
    }
}
