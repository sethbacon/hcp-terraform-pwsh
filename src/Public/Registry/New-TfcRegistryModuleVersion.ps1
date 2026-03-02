<#
.SYNOPSIS
    Create a new registry module version
.DESCRIPTION
    Creates a new version of a registry module
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
    The version string (e.g., "1.0.0")
.EXAMPLE
    New-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.1.0"
.OUTPUTS
    PSCustomObject representing the created version
#>
function New-TfcRegistryModuleVersion {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
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

        $body = @{
            data = @{
                type = "registry-module-versions"
                attributes = @{
                    version = $Version
                }
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Module: $Namespace/$Name/$Provider", "Create version $Version")) {
            $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/versions"
            Write-Verbose "Creating module version: $Version"
            return Invoke-TfcApi -Uri $uri -Method POST -Body $body
        }
    }
    catch {
        throw "Failed to create module version: $($_.Exception.Message)"
    }
}
