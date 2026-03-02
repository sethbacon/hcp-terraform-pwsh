<#
.SYNOPSIS
    List SAML settings for an organization
.DESCRIPTION
    Retrieves SAML SSO configuration for an organization (requires admin access)
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Get-TfcSAMLSettings -OrganizationName my-org
#>
function Get-TfcSAMLSettings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    Initialize-TfcConnection
    Write-Verbose "Getting SAML settings for organization: $OrganizationName"
    return Invoke-TfcApi -Uri "/organizations/$OrganizationName/saml-settings" -Method GET
}
