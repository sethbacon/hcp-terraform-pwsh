<#
.SYNOPSIS
    Cancels a registry module test run
.DESCRIPTION
    Cancels a running test run for a private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.PARAMETER TestRunId
    The test run ID to cancel
.EXAMPLE
    Stop-TfcRegistryModuleTestRun -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -TestRunId "modtestrun-abc123"
.OUTPUTS
    None
#>
function Stop-TfcRegistryModuleTestRun {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

    if ($PSCmdlet.ShouldProcess("Test run $TestRunId", "Cancel")) {
        $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/test-runs/$TestRunId/cancel"
        Write-Verbose "Cancelling test run: $TestRunId for module: $Organization/$ModuleName/$ProviderName"
        return Invoke-TfcApi -Uri $uri -Method POST
    }
}
