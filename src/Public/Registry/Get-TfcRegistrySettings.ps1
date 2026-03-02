<#
.SYNOPSIS
    Get registry settings for an organization
.DESCRIPTION
    Retrieves private registry settings for an organization
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Get-TfcRegistrySettings -OrganizationName my-org
#>
function Get-TfcRegistrySettings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    Initialize-TfcConnection
    Write-Verbose "Getting registry settings for organization: $OrganizationName"
    return Invoke-TfcApi -Uri "/organizations/$OrganizationName/registry-settings" -Method GET
}
