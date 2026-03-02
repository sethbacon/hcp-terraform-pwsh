<#
.SYNOPSIS
    Revoke admin privileges from a user
.DESCRIPTION
    Revokes site admin privileges from a user (requires admin access)
.PARAMETER UserId
    The ID of the user (format: user-xxxxx)
.EXAMPLE
    Revoke-TfcAdminPrivilege -UserId user-abc123
#>
function Revoke-TfcAdminPrivilege {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("User: $UserId", "Revoke admin privileges")) {
        Write-Verbose "Revoking admin privileges from user: $UserId"
        return Invoke-TfcApi -Uri "/admin/users/$UserId/actions/revoke-admin" -Method POST
    }
}
