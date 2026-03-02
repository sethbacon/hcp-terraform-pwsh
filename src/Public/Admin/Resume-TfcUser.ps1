<#
.SYNOPSIS
    Reactivate a suspended user account
.DESCRIPTION
    Reactivates a suspended user account in Terraform Cloud (requires admin access)
.PARAMETER UserId
    The ID of the user to reactivate (format: user-xxxxx)
.EXAMPLE
    Resume-TfcUser -UserId user-abc123
#>
function Resume-TfcUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("User: $UserId", "Resume")) {
        Write-Verbose "Resuming user: $UserId"
        return Invoke-TfcApi -Uri "/admin/users/$UserId/actions/unsuspend" -Method POST
    }
}
