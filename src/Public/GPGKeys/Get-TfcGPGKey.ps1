<#
.SYNOPSIS
    Lists GPG keys for a registry
.DESCRIPTION
    Retrieves GPG keys for a given registry namespace
.PARAMETER RegistryName
    The registry name (e.g., "private")
.PARAMETER Namespace
    The namespace (organization name)
.EXAMPLE
    Get-TfcGPGKey -RegistryName "private" -Namespace "my-org"
.OUTPUTS
    PSCustomObject representing GPG keys
#>
function Get-TfcGPGKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RegistryName,

        [Parameter(Mandatory = $true)]
        [string]$Namespace
    )

    Initialize-TfcConnection
    $baseUrl = $script:TfcApiBaseUri -replace '/api/v2', ''
    $uri = "$baseUrl/api/registry/$RegistryName/v2/gpg-keys?filter%5Bnamespace%5D=$Namespace"
    Write-Verbose "Getting GPG keys for registry: $RegistryName, namespace: $Namespace"
    return Invoke-TfcApi -Uri $uri
}
