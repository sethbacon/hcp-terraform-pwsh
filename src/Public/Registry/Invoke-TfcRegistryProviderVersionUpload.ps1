<#
.SYNOPSIS
    Uploads a registry provider version binary
.DESCRIPTION
    Uploads a provider binary to a registry provider version.
    The upload URL is obtained from a previously created provider version.
.PARAMETER UploadUrl
    The upload URL from the provider version (data.links.shasums-upload or data.links.shasums-sig-upload)
.PARAMETER FilePath
    Path to the file to upload (SHA256SUMS or SHA256SUMS.sig)
.EXAMPLE
    $version = New-TfcRegistryProviderVersion -OrganizationName "my-org" -RegistryName "private" -Namespace "my-org" -Name "custom" -Version "1.0.0" -KeyId "abc123" -Protocols @("5.0")
    Invoke-TfcRegistryProviderVersionUpload -UploadUrl $version.data.links.'shasums-upload' -FilePath "./SHA256SUMS"
.OUTPUTS
    Boolean indicating success
#>
function Invoke-TfcRegistryProviderVersionUpload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UploadUrl,

        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path $_})]
        [string]$FilePath
    )

    $filePath = Resolve-Path $FilePath
    Write-Verbose "Uploading provider version file from: $filePath"
    Write-Verbose "Upload URL: $UploadUrl"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        $null = Invoke-RestMethod -Uri $UploadUrl -Method PUT -Body $fileBytes -ContentType "application/octet-stream"
        Write-Verbose "Provider version file uploaded successfully"
        return $true
    }
    catch {
        Write-Error "Failed to upload provider version file: $_"
        return $false
    }
}
