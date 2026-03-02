<#
.SYNOPSIS
    Creates a test variable for a registry module
.DESCRIPTION
    Creates a new variable for testing a private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.PARAMETER Key
    The variable key name
.PARAMETER Value
    The variable value
.PARAMETER Category
    The variable category (terraform or env)
.PARAMETER HCL
    Whether the value is HCL
.PARAMETER Sensitive
    Whether the variable is sensitive
.EXAMPLE
    New-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -Key "region" -Value "us-east-1" -Category "terraform"
.OUTPUTS
    PSCustomObject representing the created variable
#>
function New-TfcRegistryModuleTestVariable {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName,

        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter(Mandatory = $false)]
        [string]$Value = "",

        [Parameter(Mandatory = $true)]
        [ValidateSet("terraform", "env")]
        [string]$Category,

        [Parameter(Mandatory = $false)]
        [bool]$HCL = $false,

        [Parameter(Mandatory = $false)]
        [bool]$Sensitive = $false
    )

    $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/vars"

    $body = @{
        data = @{
            type       = "vars"
            attributes = @{
                key       = $Key
                value     = $Value
                category  = $Category
                hcl       = $HCL
                sensitive = $Sensitive
            }
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Creating test variable '$Key' for module: $Organization/$ModuleName/$ProviderName"
    if ($PSCmdlet.ShouldProcess("Variable '$Key' for module '$Organization/$ModuleName/$ProviderName'", "Create test variable")) {
        return Invoke-TfcApi -Uri $uri -Method POST -Body $body
    }
}
