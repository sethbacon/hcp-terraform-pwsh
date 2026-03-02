<#
.SYNOPSIS
    Uploads a registry module version tarball
.DESCRIPTION
    Uploads a tarball containing Terraform module source code to a registry module version.
    The upload URL is obtained from a previously created module version.
.PARAMETER UploadUrl
    The upload URL from the module version (data.links.upload)
.PARAMETER TarballPath
    Path to the .tar.gz file containing the module source code
.EXAMPLE
    $version = New-TfcRegistryModuleVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-org" -Name "vpc" -Provider "aws" -Version "1.0.0"
    Invoke-TfcRegistryModuleVersionUpload -UploadUrl $version.data.links.upload -TarballPath "./module.tar.gz"
.OUTPUTS
    Boolean indicating success
#>
function Invoke-TfcRegistryModuleVersionUpload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UploadUrl,

        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path $_})]
        [string]$TarballPath
    )

    $tarballPath = Resolve-Path $TarballPath
    Write-Verbose "Uploading module version from: $tarballPath"
    Write-Verbose "Upload URL: $UploadUrl"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($tarballPath)
        $null = Invoke-RestMethod -Uri $UploadUrl -Method PUT -Body $fileBytes -ContentType "application/octet-stream"
        Write-Verbose "Module version uploaded successfully"
        return $true
    }
    catch {
        Write-Error "Failed to upload module version: $_"
        return $false
    }
}
