<#
.SYNOPSIS
    Get registry provider version details
.DESCRIPTION
    Retrieves detailed information about a specific provider version
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER RegistryName
    The registry name
.PARAMETER Namespace
    The namespace of the provider
.PARAMETER Name
    The name of the provider
.PARAMETER Version
    The version string
.EXAMPLE
    Get-TfcRegistryProviderVersionDetails -OrganizationName "my-org" -RegistryName "private" -Namespace "hashicorp" -Name "aws" -Version "5.0.0"
.OUTPUTS
    PSCustomObject representing provider version details
#>
function Get-TfcRegistryProviderVersionDetails {
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
        [string]$Version
    )

    try {
        Initialize-TfcConnection
        $uri = "/organizations/$OrganizationName/registry-providers/$RegistryName/$Namespace/$Name/$Version"
        Write-Verbose "Getting details for provider version: $Namespace/$Name/$Version"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get provider version details: $($_.Exception.Message)"
    }
}
