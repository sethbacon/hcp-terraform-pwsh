<#
.SYNOPSIS
    Publish a provider version binary
.DESCRIPTION
    Uploads a provider binary for a specific platform
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
.PARAMETER FilePath
    Path to the provider binary (zip file)
.EXAMPLE
    Publish-TfcProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64" -FilePath "./terraform-provider-custom_1.0.0_linux_amd64.zip"
.OUTPUTS
    PSCustomObject representing upload status
#>
function Publish-TfcProviderVersion {
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
        [string]$FilePath
    )

    try {
        Initialize-TfcConnection

        if (-not (Test-Path $FilePath)) {
            throw "File not found: $FilePath"
        }

        if ($PSCmdlet.ShouldProcess("Provider: $Namespace/$Name v$Version $Os/$Arch", "Upload binary")) {
            # Get upload URL
            $uri = "/organizations/$OrganizationName/registry-providers/$RegistryName/$Namespace/$Name/$Version/platforms/$Os/$Arch/upload"
            $uploadInfo = Invoke-TfcApi -Uri $uri -Method GET

            if ($uploadInfo.data.attributes.'upload-url') {
                $uploadUrl = $uploadInfo.data.attributes.'upload-url'

                # Upload file
                $fileContent = [System.IO.File]::ReadAllBytes($FilePath)
                Write-Verbose "Uploading provider binary to: $uploadUrl"

                $response = Invoke-RestMethod -Uri $uploadUrl -Method PUT -Body $fileContent -ContentType "application/zip"

                Write-Verbose "Provider binary published successfully"
                return $uploadInfo
            }
            else {
                throw "Upload URL not available"
            }
        }
    }
    catch {
        throw "Failed to publish provider binary: $($_.Exception.Message)"
    }
}
