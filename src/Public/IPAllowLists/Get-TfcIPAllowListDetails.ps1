<#
.SYNOPSIS
    Gets details for a specific IP allowlist
.DESCRIPTION
    Retrieves an IP allowlist by ID, including its CIDR ranges and agent pool associations
.PARAMETER IPAllowListId
    The IP allowlist (CIDR range list) ID
.EXAMPLE
    Get-TfcIPAllowListDetails -IPAllowListId "ial-abc123"
.OUTPUTS
    PSCustomObject representing the IP allowlist
#>
function Get-TfcIPAllowListDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAllowListId
    )

    Write-Verbose "Getting IP allowlist details: $IPAllowListId"
    return Invoke-TfcApi -Uri "/cidr-range-lists/$IPAllowListId"
}
