<#
.SYNOPSIS
    Creates a configuration version for module tests
.DESCRIPTION
    Creates a new configuration version for testing a private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.EXAMPLE
    New-TfcRegistryModuleTestConfigVersion -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
.OUTPUTS
    PSCustomObject representing the configuration version with upload URL
#>
function New-TfcRegistryModuleTestConfigVersion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName
    )

    $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/test-runs/configuration-versions"

    $body = @{
        data = @{
            type = "configuration-versions"
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Creating test configuration version for module: $Organization/$ModuleName/$ProviderName"
    if ($PSCmdlet.ShouldProcess("Module '$Organization/$ModuleName/$ProviderName'", "Create test configuration version")) {
        return Invoke-TfcApi -Uri $uri -Method POST -Body $body
    }
}
