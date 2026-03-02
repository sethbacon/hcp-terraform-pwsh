<#
.SYNOPSIS
    Get registry module download URL
.DESCRIPTION
    Retrieves the download URL for a module version
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
    Get-TfcRegistryModuleDownloadUrl -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
.OUTPUTS
    String containing the download URL
#>
function Get-TfcRegistryModuleDownloadUrl {
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
        $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/$Version/download"
        Write-Verbose "Getting download URL for: $Namespace/$Name/$Provider/$Version"
        $result = Invoke-TfcApi -Uri $uri -Method GET
        return $result.data.attributes.'download-url'
    }
    catch {
        throw "Failed to get download URL: $($_.Exception.Message)"
    }
}
