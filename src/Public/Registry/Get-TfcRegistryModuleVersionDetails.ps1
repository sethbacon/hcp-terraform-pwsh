<#
.SYNOPSIS
    Get registry module version details
.DESCRIPTION
    Retrieves detailed information about a specific module version
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER RegistryName
    The registry name
.PARAMETER Namespace
    The namespace of the module
.PARAMETER Name
    The name of the module
.PARAMETER Provider
    The provider name
.PARAMETER Version
    The version string (e.g., "1.0.0")
.EXAMPLE
    Get-TfcRegistryModuleVersionDetails -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
.OUTPUTS
    PSCustomObject representing module version details
#>
function Get-TfcRegistryModuleVersionDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,

        [Parameter(Mandatory = $true)]
        [string]$RegistryName,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Provider,

        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    try {
        Initialize-TfcConnection
        $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/$Version"
        Write-Verbose "Getting details for module version: $Namespace/$Name/$Provider/$Version"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get module version details: $($_.Exception.Message)"
    }
}
