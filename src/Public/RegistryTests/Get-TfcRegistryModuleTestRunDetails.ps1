<#
.SYNOPSIS
    Gets details of a registry module test run
.DESCRIPTION
    Retrieves details of a specific test run for a private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.PARAMETER TestRunId
    The test run ID
.EXAMPLE
    Get-TfcRegistryModuleTestRunDetails -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -TestRunId "modtestrun-abc123"
.OUTPUTS
    PSCustomObject representing the test run details
#>
function Get-TfcRegistryModuleTestRunDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName,

        [Parameter(Mandatory = $true)]
        [string]$TestRunId
    )

    $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/test-runs/$TestRunId"
    Write-Verbose "Getting test run details: $TestRunId for module: $Organization/$ModuleName/$ProviderName"
    return Invoke-TfcApi -Uri $uri
}
