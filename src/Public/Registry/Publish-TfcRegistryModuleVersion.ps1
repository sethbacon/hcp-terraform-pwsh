<#
.SYNOPSIS
    Publish a registry module version
.DESCRIPTION
    Uploads module content for a specific version
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
    The version string
.PARAMETER FilePath
    Path to the module tarball (.tar.gz)
.EXAMPLE
    Publish-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-namespace" -Name "vpc" -Provider "aws" -Version "1.0.0" -FilePath "./module.tar.gz"
.OUTPUTS
    PSCustomObject representing upload status
#>
function Publish-TfcRegistryModuleVersion {
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
        [string]$Version,

        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    try {
        Initialize-TfcConnection

        if (-not (Test-Path $FilePath)) {
            throw "File not found: $FilePath"
        }

        if ($PSCmdlet.ShouldProcess("Module: $Namespace/$Name/$Provider v$Version", "Upload module content")) {
            # Get upload URL
            $uri = "/organizations/$OrganizationName/registry-modules/$RegistryName/$Namespace/$Name/$Provider/$Version/upload"
            $uploadInfo = Invoke-TfcApi -Uri $uri -Method GET

            if ($uploadInfo.data.attributes.'upload-url') {
                $uploadUrl = $uploadInfo.data.attributes.'upload-url'

                # Upload file
                $fileContent = [System.IO.File]::ReadAllBytes($FilePath)
                Write-Verbose "Uploading module content to: $uploadUrl"

                $response = Invoke-RestMethod -Uri $uploadUrl -Method PUT -Body $fileContent -ContentType "application/octet-stream"

                Write-Verbose "Module version published successfully"
                return $uploadInfo
            }
            else {
                throw "Upload URL not available"
            }
        }
    }
    catch {
        throw "Failed to publish module version: $($_.Exception.Message)"
    }
}
