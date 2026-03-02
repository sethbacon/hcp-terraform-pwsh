<#
.SYNOPSIS
    Grant admin privileges to a user
.DESCRIPTION
    Grants site admin privileges to a user (requires admin access)
.PARAMETER UserId
    The ID of the user (format: user-xxxxx)
.EXAMPLE
    Grant-TfcAdminPrivilege -UserId user-abc123
#>
function Grant-TfcAdminPrivilege {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("User: $UserId", "Grant admin privileges")) {
        Write-Verbose "Granting admin privileges to user: $UserId"
        return Invoke-TfcApi -Uri "/admin/users/$UserId/actions/grant-admin" -Method POST
    }
}
