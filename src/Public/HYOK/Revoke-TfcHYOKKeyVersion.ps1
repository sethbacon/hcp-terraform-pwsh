<#
.SYNOPSIS
    Revokes a HYOK key version
.DESCRIPTION
    Revokes a specific HYOK customer key version, preventing it from being used for encryption
.PARAMETER KeyVersionId
    The HYOK customer key version ID to revoke
.EXAMPLE
    Revoke-TfcHYOKKeyVersion -KeyVersionId "hyokkv-abc123"
.OUTPUTS
    PSCustomObject representing the revoked key version
#>
function Revoke-TfcHYOKKeyVersion {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$KeyVersionId
    )

    if ($PSCmdlet.ShouldProcess("HYOK key version $KeyVersionId", "Revoke")) {
        Write-Verbose "Revoking HYOK key version: $KeyVersionId"
        return Invoke-TfcApi -Uri "/hyok-customer-key-versions/$KeyVersionId/actions/revoke" -Method POST
    }
}
