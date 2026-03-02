<#
.SYNOPSIS
    Uploads configuration files to a configuration version
.DESCRIPTION
    Uploads a tarball of Terraform configuration files to a configuration version.
    The tarball should be gzipped and contain .tf files at the root or in a subdirectory.
.PARAMETER UploadUrl
    The upload URL from the configuration version (data.attributes.upload-url)
.PARAMETER TarballPath
    Path to the .tar.gz file containing Terraform configuration
.EXAMPLE
    $cv = New-TfcConfigurationVersion -WorkspaceId "ws-abc123"
    Invoke-TfcConfigurationUpload -UploadUrl $cv.data.attributes.'upload-url' -TarballPath "./config.tar.gz"
.OUTPUTS
    Boolean indicating success
#>
function Invoke-TfcConfigurationUpload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UploadUrl,

        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path $_})]
        [string]$TarballPath
    )

    $tarballPath = Resolve-Path $TarballPath
    Write-Verbose "Uploading configuration from: $tarballPath"
    Write-Verbose "Upload URL: $UploadUrl"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($tarballPath)
        $null = Invoke-RestMethod -Uri $UploadUrl -Method PUT -Body $fileBytes -ContentType "application/octet-stream"
        Write-Verbose "Configuration uploaded successfully"
        return $true
    }
    catch {
        Write-Error "Failed to upload configuration: $_"
        return $false
    }
}
