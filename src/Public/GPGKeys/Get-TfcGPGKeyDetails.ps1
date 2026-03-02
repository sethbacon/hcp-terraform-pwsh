<#
.SYNOPSIS
    Gets details of a GPG key
.DESCRIPTION
    Retrieves details of a specific GPG key by namespace and key ID
.PARAMETER RegistryName
    The registry name (e.g., "private")
.PARAMETER Namespace
    The namespace (organization name)
.PARAMETER KeyId
    The GPG key ID
.EXAMPLE
    Get-TfcGPGKeyDetails -RegistryName "private" -Namespace "my-org" -KeyId "12345"
.OUTPUTS
    PSCustomObject representing the GPG key details
#>
function Get-TfcGPGKeyDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RegistryName,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$KeyId
    )

    Initialize-TfcConnection
    $baseUrl = $script:TfcApiBaseUri -replace '/api/v2', ''
    $uri = "$baseUrl/api/registry/$RegistryName/v2/gpg-keys/$Namespace/$KeyId"
    Write-Verbose "Getting GPG key details: $KeyId in namespace: $Namespace"
    return Invoke-TfcApi -Uri $uri
}
