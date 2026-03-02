<#
.SYNOPSIS
    Uploads a test configuration to a registry module
.DESCRIPTION
    Uploads a tarball containing test configuration to the upload URL from New-TfcRegistryModuleTestConfigVersion
.PARAMETER UploadUrl
    The upload URL from the configuration version response
.PARAMETER TarballPath
    Path to the tar.gz file containing the test configuration
.EXAMPLE
    Invoke-TfcRegistryModuleTestConfigUpload -UploadUrl "https://archivist.terraform.io/v1/object/..." -TarballPath "./test-config.tar.gz"
.OUTPUTS
    Boolean indicating success or failure
#>
function Invoke-TfcRegistryModuleTestConfigUpload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UploadUrl,

        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path $_})]
        [string]$TarballPath
    )

    $resolvedPath = Resolve-Path $TarballPath
    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($resolvedPath)
        $null = Invoke-RestMethod -Uri $UploadUrl -Method PUT -Body $fileBytes -ContentType "application/octet-stream"
        Write-Verbose "Successfully uploaded test configuration from: $TarballPath"
        return $true
    }
    catch {
        Write-Error "Failed to upload test configuration: $_"
        return $false
    }
}
