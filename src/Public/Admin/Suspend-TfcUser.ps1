<#
.SYNOPSIS
    Suspend a user account
.DESCRIPTION
    Suspends a user account in Terraform Cloud (requires admin access)
.PARAMETER UserId
    The ID of the user to suspend (format: user-xxxxx)
.EXAMPLE
    Suspend-TfcUser -UserId user-abc123
#>
function Suspend-TfcUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("User: $UserId", "Suspend")) {
        Write-Verbose "Suspending user: $UserId"
        return Invoke-TfcApi -Uri "/admin/users/$UserId/actions/suspend" -Method POST
    }
}
