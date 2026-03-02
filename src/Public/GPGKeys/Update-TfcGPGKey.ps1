<#
.SYNOPSIS
    Updates a GPG key
.DESCRIPTION
    Updates the namespace of an existing GPG key
.PARAMETER RegistryName
    The registry name (e.g., "private")
.PARAMETER Namespace
    The current namespace (organization name)
.PARAMETER KeyId
    The GPG key ID
.PARAMETER NewNamespace
    The new namespace to assign to the key
.EXAMPLE
    Update-TfcGPGKey -RegistryName "private" -Namespace "my-org" -KeyId "12345" -NewNamespace "new-org"
.OUTPUTS
    PSCustomObject representing the updated GPG key
#>
function Update-TfcGPGKey {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RegistryName,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$KeyId,

        [Parameter(Mandatory = $true)]
        [string]$NewNamespace
    )

    Initialize-TfcConnection
    $baseUrl = $script:TfcApiBaseUri -replace '/api/v2', ''
    $uri = "$baseUrl/api/registry/$RegistryName/v2/gpg-keys/$Namespace/$KeyId"

    $body = @{
        data = @{
            type       = "gpg-keys"
            attributes = @{
                namespace = $NewNamespace
            }
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Updating GPG key: $KeyId in namespace: $Namespace"
    if ($PSCmdlet.ShouldProcess("GPG key '$KeyId' in namespace '$Namespace'", "Update GPG key")) {
        return Invoke-TfcApi -Uri $uri -Method PATCH -Body $body
    }
}
