<#
.SYNOPSIS
    Get registry module statistics
.DESCRIPTION
    Retrieves download statistics for a module
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
.EXAMPLE
    Get-TfcRegistryModuleStats -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws"
.OUTPUTS
    PSCustomObject representing module statistics
#>
function Get-TfcRegistryModuleStats {
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
        $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/stats"
        Write-Verbose "Getting statistics for: $Namespace/$Name/$Provider"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get module statistics: $($_.Exception.Message)"
    }
}
