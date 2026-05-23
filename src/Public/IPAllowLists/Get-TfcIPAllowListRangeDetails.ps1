<#
.SYNOPSIS
    Gets details for a specific CIDR range
.DESCRIPTION
    Retrieves a single CIDR range by ID
.PARAMETER CidrRangeId
    The CIDR range ID
.EXAMPLE
    Get-TfcIPAllowListRangeDetails -CidrRangeId "cidr-abc123"
.OUTPUTS
    PSCustomObject representing the CIDR range
#>
function Get-TfcIPAllowListRangeDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CidrRangeId
    )

    Write-Verbose "Getting CIDR range details: $CidrRangeId"
    return Invoke-TfcApi -Uri "/cidr-ranges/$CidrRangeId"
}
