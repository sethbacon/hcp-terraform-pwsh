<#
.SYNOPSIS
    Disable two-factor authentication for a user
.DESCRIPTION
    Disables 2FA for a user account (requires admin access, emergency use only)
.PARAMETER UserId
    The ID of the user (format: user-xxxxx)
.EXAMPLE
    Disable-TfcUserTwoFactor -UserId user-abc123
#>
function Disable-TfcUserTwoFactor {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("User: $UserId", "Disable two-factor authentication")) {
        Write-Verbose "Disabling two-factor authentication for user: $UserId"
        return Invoke-TfcApi -Uri "/admin/users/$UserId/actions/disable-two-factor" -Method POST
    }
}
