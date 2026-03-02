<#
.SYNOPSIS
    Delete a registry provider version
.DESCRIPTION
    Removes a specific version of a registry provider
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER RegistryName
    The registry name
.PARAMETER Namespace
    The namespace of the provider
.PARAMETER Name
    The name of the provider
.PARAMETER Version
    The version string to delete
.EXAMPLE
    Remove-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0"
#>
function Remove-TfcRegistryProviderVersion {
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
        [string]$Version
    )

    try {
        Initialize-TfcConnection

        if ($PSCmdlet.ShouldProcess("Provider: $Namespace/$Name", "Delete version $Version")) {
            $uri = "/organizations/$OrganizationName/registry-providers/$RegistryName/$Namespace/$Name/$Version"
            Write-Verbose "Deleting provider version: $Version"
            return Invoke-TfcApi -Uri $uri -Method DELETE
        }
    }
    catch {
        throw "Failed to delete provider version: $($_.Exception.Message)"
    }
}
