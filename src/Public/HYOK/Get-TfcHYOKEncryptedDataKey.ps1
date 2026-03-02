<#
.SYNOPSIS
    Gets a HYOK encrypted data key
.DESCRIPTION
    Retrieves a specific HYOK encrypted data key by ID
.PARAMETER EncryptedDataKeyId
    The HYOK encrypted data key ID
.EXAMPLE
    Get-TfcHYOKEncryptedDataKey -EncryptedDataKeyId "hyokdek-abc123"
.OUTPUTS
    PSCustomObject representing the encrypted data key
#>
function Get-TfcHYOKEncryptedDataKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$EncryptedDataKeyId
    )

    Write-Verbose "Getting HYOK encrypted data key: $EncryptedDataKeyId"
    return Invoke-TfcApi -Uri "/hyok-encrypted-data-keys/$EncryptedDataKeyId"
}
