<#
.SYNOPSIS
    Delete a registry module version
.DESCRIPTION
    Removes a specific version of a registry module
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
    The version string to delete
.EXAMPLE
    Remove-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0"
#>
function Remove-TfcRegistryModuleVersion {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
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

        if ($PSCmdlet.ShouldProcess("Module: $Namespace/$Name/$Provider", "Delete version $Version")) {
            $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/$Version"
            Write-Verbose "Deleting module version: $Version"
            return Invoke-TfcApi -Uri $uri -Method DELETE
        }
    }
    catch {
        throw "Failed to delete module version: $($_.Exception.Message)"
    }
}
