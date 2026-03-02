<#
.SYNOPSIS
    List registry provider versions
.DESCRIPTION
    Lists all versions of a registry provider
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER RegistryName
    The registry name
.PARAMETER Namespace
    The namespace of the provider
.PARAMETER Name
    The name of the provider
.EXAMPLE
    Get-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "hashicorp" -Name "aws"
.OUTPUTS
    PSCustomObject representing provider versions
#>
function Get-TfcRegistryProviderVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,

        [Parameter(Mandatory = $true)]
        [string]$RegistryName,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    try {
        Initialize-TfcConnection
        $uri = "/organizations/$OrganizationName/registry-providers/$RegistryName/$Namespace/$Name/versions"
        Write-Verbose "Getting versions for provider: $Namespace/$Name"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get provider versions: $($_.Exception.Message)"
    }
}
