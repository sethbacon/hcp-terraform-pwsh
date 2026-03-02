<#
.SYNOPSIS
    Delete a registry provider platform
.DESCRIPTION
    Removes a platform from a provider version
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER RegistryName
    The registry name
.PARAMETER Namespace
    The namespace of the provider
.PARAMETER Name
    The name of the provider
.PARAMETER Version
    The version string
.PARAMETER Os
    Operating system
.PARAMETER Arch
    Architecture
.EXAMPLE
    Remove-TfcRegistryProviderPlatform -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64"
#>
function Remove-TfcRegistryProviderPlatform {
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
        [string]$Version,

        [Parameter(Mandatory = $true)]
        [string]$Os,

        [Parameter(Mandatory = $true)]
        [string]$Arch
    )

    try {
        Initialize-TfcConnection

        if ($PSCmdlet.ShouldProcess("Provider: $Namespace/$Name v$Version", "Delete platform $Os/$Arch")) {
            $uri = "/organizations/$OrganizationName/registry-providers/$RegistryName/$Namespace/$Name/$Version/platforms/$Os/$Arch"
            Write-Verbose "Deleting provider platform: $Os/$Arch"
            return Invoke-TfcApi -Uri $uri -Method DELETE
        }
    }
    catch {
        throw "Failed to delete provider platform: $($_.Exception.Message)"
    }
}
