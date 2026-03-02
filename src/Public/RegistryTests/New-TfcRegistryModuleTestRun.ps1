<#
.SYNOPSIS
    Creates a new test run for a registry module
.DESCRIPTION
    Initiates a new test run for a private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.PARAMETER ConfigurationVersionId
    Optional configuration version ID to use for the test
.EXAMPLE
    New-TfcRegistryModuleTestRun -Organization "my-org" -ModuleName "vpc" -ProviderName "aws"
.OUTPUTS
    PSCustomObject representing the created test run
#>
function New-TfcRegistryModuleTestRun {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName,

        [Parameter(Mandatory = $false)]
        [string]$ConfigurationVersionId
    )

    $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/test-runs"

    $body = @{
        data = @{
            type = "test-runs"
        }
    }

    if ($ConfigurationVersionId) {
        $body.data.relationships = @{
            'configuration-version' = @{
                data = @{
                    type = "configuration-versions"
                    id   = $ConfigurationVersionId
                }
            }
        }
    }

    $bodyJson = $body | ConvertTo-Json -Depth 5

    Write-Verbose "Creating test run for module: $Organization/$ModuleName/$ProviderName"
    if ($PSCmdlet.ShouldProcess("Module '$Organization/$ModuleName/$ProviderName'", "Create test run")) {
        return Invoke-TfcApi -Uri $uri -Method POST -Body $bodyJson
    }
}
