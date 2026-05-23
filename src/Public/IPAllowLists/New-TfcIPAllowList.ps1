<#
.SYNOPSIS
    Creates an IP allowlist (CIDR range list)
.DESCRIPTION
    Creates a new IP allowlist in an organization to scope access by source IP
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The allowlist name
.PARAMETER Description
    Optional description
.PARAMETER EnforcementScope
    Where the allowlist is enforced: 'api' | 'agent' | 'all'
.PARAMETER Enabled
    Whether the allowlist is active (default: true)
.EXAMPLE
    New-TfcIPAllowList -Organization "my-org" -Name "office-network" -EnforcementScope "api" -Description "Corporate office IPs"
.OUTPUTS
    PSCustomObject representing the created IP allowlist
#>
function New-TfcIPAllowList {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [ValidateSet('api', 'agent', 'all')]
        [string]$EnforcementScope = 'api',

        [Parameter(Mandatory = $false)]
        [bool]$Enabled = $true
    )

    $attributes = @{
        name = $Name
        'enforcement-scope' = $EnforcementScope
        enabled = $Enabled
    }

    if ($Description) {
        $attributes['description'] = $Description
    }

    $body = @{
        data = @{
            type = 'cidr-range-lists'
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating IP allowlist '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create IP allowlist: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/cidr-range-lists" -Method POST -Body $body
    }
}
