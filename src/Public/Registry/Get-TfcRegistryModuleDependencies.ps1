<#
.SYNOPSIS
    Get registry module dependencies
.DESCRIPTION
    Retrieves dependencies for a module version
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
    The version string
.EXAMPLE
    Get-TfcRegistryModuleDependencies -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
.OUTPUTS
    PSCustomObject representing module dependencies
#>
function Get-TfcRegistryModuleDependencies {
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
        $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/$Version/dependencies"
        Write-Verbose "Getting dependencies for: $Namespace/$Name/$Provider/$Version"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get module dependencies: $($_.Exception.Message)"
    }
}
