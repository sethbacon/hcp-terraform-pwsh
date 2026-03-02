<#
.SYNOPSIS
    Deletes a GPG key
.DESCRIPTION
    Removes a GPG key from the specified registry
.PARAMETER RegistryName
    The registry name (e.g., "private")
.PARAMETER Namespace
    The namespace (organization name)
.PARAMETER KeyId
    The GPG key ID to delete
.EXAMPLE
    Remove-TfcGPGKey -RegistryName "private" -Namespace "my-org" -KeyId "12345"
.OUTPUTS
    None
#>
function Remove-TfcGPGKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RegistryName,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$KeyId
    )

    if ($PSCmdlet.ShouldProcess("GPG key $KeyId in namespace $Namespace", "Delete")) {
        Initialize-TfcConnection
        $baseUrl = $script:TfcApiBaseUri -replace '/api/v2', ''
        $uri = "$baseUrl/api/registry/$RegistryName/v2/gpg-keys/$Namespace/$KeyId"
        Write-Verbose "Deleting GPG key: $KeyId in namespace: $Namespace"
        return Invoke-TfcApi -Uri $uri -Method DELETE
    }
}
