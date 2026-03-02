<#
.SYNOPSIS
    Stops user impersonation
.DESCRIPTION
    Ends the current admin user impersonation session (Terraform Enterprise only)
.EXAMPLE
    Stop-TfcUserImpersonation
.OUTPUTS
    None
#>
function Stop-TfcUserImpersonation {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param()

    if ($PSCmdlet.ShouldProcess("Current impersonation session", "Stop")) {
        Write-Verbose "Stopping user impersonation"
        return Invoke-TfcApi -Uri "/admin/users/actions/unimpersonate" -Method POST
    }
}
