<#
.SYNOPSIS
    Create a new registry provider version
.DESCRIPTION
    Creates a new version of a registry provider
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
.PARAMETER KeyId
    GPG key ID for signing
.PARAMETER Protocols
    Array of supported protocol versions (e.g., @("5.0", "6.0"))
.EXAMPLE
    New-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Protocols @("5.0")
.OUTPUTS
    PSCustomObject representing the created version
#>
function New-TfcRegistryProviderVersion {
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
        [string]$Version,

        [Parameter(Mandatory = $false)]
        [string]$KeyId,

        [Parameter(Mandatory = $true)]
        [string[]]$Protocols
    )

    try {
        Initialize-TfcConnection

        $attributes = @{
            version = $Version
            protocols = $Protocols
        }

        if ($KeyId) {
            $attributes['key-id'] = $KeyId
        }

        $body = @{
            data = @{
                type = "registry-provider-versions"
                attributes = $attributes
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Provider: $Namespace/$Name", "Create version $Version")) {
            $uri = "/organizations/$OrganizationName/registry-providers/$RegistryName/$Namespace/$Name/versions"
            Write-Verbose "Creating provider version: $Version"
            return Invoke-TfcApi -Uri $uri -Method POST -Body $body
        }
    }
    catch {
        throw "Failed to create provider version: $($_.Exception.Message)"
    }
}
