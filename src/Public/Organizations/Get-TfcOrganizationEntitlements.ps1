<#
.SYNOPSIS
    Gets the entitlement set for an organization
.DESCRIPTION
    Retrieves the feature entitlements for a specific organization
.PARAMETER Organization
    The organization name
.EXAMPLE
    Get-TfcOrganizationEntitlements -Organization "my-org"
.OUTPUTS
    PSCustomObject representing the organization's entitlements
#>
function Get-TfcOrganizationEntitlements {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Getting entitlements for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/entitlement-set"
}
