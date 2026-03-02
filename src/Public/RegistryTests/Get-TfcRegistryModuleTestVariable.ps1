<#
.SYNOPSIS
    Lists test variables for a registry module
.DESCRIPTION
    Retrieves variables configured for testing a private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.EXAMPLE
    Get-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
.OUTPUTS
    PSCustomObject representing test variables
#>
function Get-TfcRegistryModuleTestVariable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName
    )

    $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/vars"
    Write-Verbose "Getting test variables for module: $Organization/$ModuleName/$ProviderName"
    return Invoke-TfcApi -Uri $uri
}
