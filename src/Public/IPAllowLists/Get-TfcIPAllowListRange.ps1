<#
.SYNOPSIS
    Lists CIDR ranges associated with an IP allowlist
.DESCRIPTION
    Retrieves all CIDR ranges that belong to a given IP allowlist
.PARAMETER IPAllowListId
    The IP allowlist (CIDR range list) ID
.EXAMPLE
    Get-TfcIPAllowListRange -IPAllowListId "ial-abc123"
.OUTPUTS
    PSCustomObject representing the CIDR ranges
#>
function Get-TfcIPAllowListRange {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAllowListId
    )

    Write-Verbose "Listing CIDR ranges for IP allowlist: $IPAllowListId"
    return Invoke-TfcApi -Uri "/cidr-range-lists/$IPAllowListId/relationships/cidr-ranges"
}
