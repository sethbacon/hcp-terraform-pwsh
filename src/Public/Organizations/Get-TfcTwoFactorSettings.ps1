<#
.SYNOPSIS
    Get two-factor authentication settings
.DESCRIPTION
    Retrieves 2FA settings for an organization
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Get-TfcTwoFactorSettings -OrganizationName my-org
#>
function Get-TfcTwoFactorSettings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    Initialize-TfcConnection
    Write-Verbose "Getting two-factor settings for organization: $OrganizationName"
    return Invoke-TfcApi -Uri "/organizations/$OrganizationName/two-factor" -Method GET
}
