<#
.SYNOPSIS
    Impersonate a user
.DESCRIPTION
    Creates an impersonation token to act as another user (requires admin access, audited)
.PARAMETER UserId
    The ID of the user to impersonate (format: user-xxxxx)
.EXAMPLE
    New-TfcUserImpersonation -UserId user-abc123
#>
function New-TfcUserImpersonation {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("User: $UserId", "Create impersonation token")) {
        Write-Verbose "Creating impersonation token for user: $UserId"
        return Invoke-TfcApi -Uri "/admin/users/$UserId/actions/impersonate" -Method POST
    }
}
