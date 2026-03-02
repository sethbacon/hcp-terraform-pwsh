<#
.SYNOPSIS
    Creates a new GPG key
.DESCRIPTION
    Uploads a new GPG key to the specified registry
.PARAMETER RegistryName
    The registry name (e.g., "private")
.PARAMETER Namespace
    The namespace (organization name)
.PARAMETER AsciiArmor
    The ASCII-armored GPG public key
.EXAMPLE
    New-TfcGPGKey -RegistryName "private" -Namespace "my-org" -AsciiArmor "-----BEGIN PGP PUBLIC KEY BLOCK-----..."
.OUTPUTS
    PSCustomObject representing the created GPG key
#>
function New-TfcGPGKey {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RegistryName,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$AsciiArmor
    )

    Initialize-TfcConnection
    $baseUrl = $script:TfcApiBaseUri -replace '/api/v2', ''
    $uri = "$baseUrl/api/registry/$RegistryName/v2/gpg-keys"

    $body = @{
        data = @{
            type       = "gpg-keys"
            attributes = @{
                namespace   = $Namespace
                ascii_armor = $AsciiArmor
            }
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Creating GPG key in registry: $RegistryName, namespace: $Namespace"
    if ($PSCmdlet.ShouldProcess("GPG key in registry '$RegistryName' namespace '$Namespace'", "Create GPG key")) {
        return Invoke-TfcApi -Uri $uri -Method POST -Body $body
    }
}
