<#
.SYNOPSIS
    Uploads a registry provider platform binary
.DESCRIPTION
    Uploads a provider platform binary to a registry provider platform.
    The upload URL is obtained from a previously created provider platform.
.PARAMETER UploadUrl
    The upload URL from the provider platform (data.links.provider-binary-upload)
.PARAMETER FilePath
    Path to the provider binary file to upload (e.g., terraform-provider-custom_1.0.0_linux_amd64.zip)
.EXAMPLE
    $platform = New-TfcRegistryProviderPlatform -OrganizationName "my-org" -RegistryName "private" -Namespace "my-org" -Name "custom" -Version "1.0.0" -Os "linux" -Arch "amd64" -Shasum "abc123..." -Filename "terraform-provider-custom_1.0.0_linux_amd64.zip"
    Invoke-TfcRegistryProviderPlatformUpload -UploadUrl $platform.data.links.'provider-binary-upload' -FilePath "./terraform-provider-custom_1.0.0_linux_amd64.zip"
.OUTPUTS
    Boolean indicating success
#>
function Invoke-TfcRegistryProviderPlatformUpload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UploadUrl,

        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path $_})]
        [string]$FilePath
    )

    $filePath = Resolve-Path $FilePath
    Write-Verbose "Uploading provider platform binary from: $filePath"
    Write-Verbose "Upload URL: $UploadUrl"

    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        $null = Invoke-RestMethod -Uri $UploadUrl -Method PUT -Body $fileBytes -ContentType "application/octet-stream"
        Write-Verbose "Provider platform binary uploaded successfully"
        return $true
    }
    catch {
        Write-Error "Failed to upload provider platform binary: $_"
        return $false
    }
}
