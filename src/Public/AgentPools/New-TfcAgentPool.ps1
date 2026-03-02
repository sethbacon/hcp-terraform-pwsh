<#
.SYNOPSIS
    Creates an agent pool
.DESCRIPTION
    Creates a new agent pool for self-hosted agents
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The agent pool name
.PARAMETER OrganizationScoped
    Whether the pool is available to all workspaces (default: true)
.EXAMPLE
    New-TfcAgentPool -Organization "my-org" -Name "production-agents"
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
        [bool]$OrganizationScoped = $true
    )

    $body = @{
        data = @{
            type = "agent-pools"
            attributes = @{
                name = $Name
                'organization-scoped' = $OrganizationScoped
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating agent pool '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create agent pool: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/agent-pools" -Method POST -Body $body
    }
}
