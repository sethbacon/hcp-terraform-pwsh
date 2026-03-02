<#
.SYNOPSIS
    List registry module versions
.DESCRIPTION
    Lists all versions of a registry module
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER RegistryName
    The registry name (e.g., "private")
.PARAMETER Namespace
    The namespace of the module
.PARAMETER Name
    The name of the module
.PARAMETER Provider
    The provider name
.EXAMPLE
    Get-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws"
.OUTPUTS
    PSCustomObject representing module versions
#>
function Get-TfcRegistryModuleVersion {
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
        [string]$Provider
    )

    try {
        Initialize-TfcConnection
        $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/versions"
        Write-Verbose "Getting versions for module: $Namespace/$Name/$Provider"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get module versions: $($_.Exception.Message)"
    }
}
