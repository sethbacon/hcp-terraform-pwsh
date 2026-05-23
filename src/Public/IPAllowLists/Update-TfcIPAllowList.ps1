<#
.SYNOPSIS
    Updates an IP allowlist
.DESCRIPTION
    Updates an existing IP allowlist's name, description, scope, or enabled state
.PARAMETER IPAllowListId
    The IP allowlist ID
.PARAMETER Name
    New name
.PARAMETER Description
    New description
.PARAMETER EnforcementScope
    Updated enforcement scope: 'api' | 'agent' | 'all'
.PARAMETER Enabled
    Updated enabled state
.EXAMPLE
    Update-TfcIPAllowList -IPAllowListId "ial-abc123" -Enabled $false
.OUTPUTS
    PSCustomObject representing the updated IP allowlist
#>
function Update-TfcIPAllowList {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAllowListId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [ValidateSet('api', 'agent', 'all')]
        [string]$EnforcementScope,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled
    )

    $attributes = @{}
    if ($PSBoundParameters.ContainsKey('Name')) { $attributes['name'] = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $attributes['description'] = $Description }
    if ($PSBoundParameters.ContainsKey('EnforcementScope')) { $attributes['enforcement-scope'] = $EnforcementScope }
    if ($PSBoundParameters.ContainsKey('Enabled')) { $attributes['enabled'] = $Enabled }

    if ($attributes.Count -eq 0) {
        throw "At least one attribute must be specified for update"
    }

    $body = @{
        data = @{
            type = 'cidr-range-lists'
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating IP allowlist: $IPAllowListId"
    if ($PSCmdlet.ShouldProcess("IP Allowlist: $IPAllowListId", "Update IP allowlist")) {
        return Invoke-TfcApi -Uri "/cidr-range-lists/$IPAllowListId" -Method PATCH -Body $body
    }
}
