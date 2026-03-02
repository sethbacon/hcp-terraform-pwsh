<#
.SYNOPSIS
    Lists test runs for a registry module
.DESCRIPTION
    Retrieves test runs for a specified private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.EXAMPLE
    Get-TfcRegistryModuleTestRun -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
.OUTPUTS
    PSCustomObject representing test runs
#>
function Get-TfcRegistryModuleTestRun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName
    )

    $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/test-runs"
    Write-Verbose "Getting test runs for module: $Organization/$ModuleName/$ProviderName"
    return Invoke-TfcApi -Uri $uri
}
