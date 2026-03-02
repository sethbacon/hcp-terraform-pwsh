<#
.SYNOPSIS
    Create a registry provider platform
.DESCRIPTION
    Adds a new platform to a provider version
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
    Operating system (e.g., "linux", "darwin", "windows")
.PARAMETER Arch
    Architecture (e.g., "amd64", "arm64", "386")
.PARAMETER Shasum
    SHA256 checksum of the binary
.PARAMETER Filename
    Filename of the binary
.EXAMPLE
    New-TfcRegistryProviderPlatform -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64" -Shasum "abc123..." -Filename "terraform-provider-custom_1.0.0_linux_amd64.zip"
.OUTPUTS
    PSCustomObject representing the created platform
#>
function New-TfcRegistryProviderPlatform {
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

        [Parameter(Mandatory = $true)]
        [string]$Os,

        [Parameter(Mandatory = $true)]
        [string]$Arch,

        [Parameter(Mandatory = $true)]
        [string]$Shasum,

        [Parameter(Mandatory = $true)]
        [string]$Filename
    )

    try {
        Initialize-TfcConnection

        $body = @{
            data = @{
                type = "registry-provider-platforms"
                attributes = @{
                    os = $Os
                    arch = $Arch
                    shasum = $Shasum
                    filename = $Filename
                }
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Provider: $Namespace/$Name v$Version", "Create platform $Os/$Arch")) {
            $uri = "/organizations/$OrganizationName/registry-providers/$RegistryName/$Namespace/$Name/$Version/platforms"
            Write-Verbose "Creating provider platform: $Os/$Arch"
            return Invoke-TfcApi -Uri $uri -Method POST -Body $body
        }
    }
    catch {
        throw "Failed to create provider platform: $($_.Exception.Message)"
    }
}
