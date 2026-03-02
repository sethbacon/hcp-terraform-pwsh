<#
.SYNOPSIS
    Cancels a change request
.DESCRIPTION
    Cancels a specific change request
.PARAMETER ChangeRequestId
    The change request ID to cancel
.EXAMPLE
    Stop-TfcChangeRequest -ChangeRequestId "cr-abc123"
.OUTPUTS
    None
#>
function Stop-TfcChangeRequest {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ChangeRequestId
    )

    if ($PSCmdlet.ShouldProcess("Change request $ChangeRequestId", "Cancel")) {
        Write-Verbose "Cancelling change request: $ChangeRequestId"
        return Invoke-TfcApi -Uri "/change-requests/$ChangeRequestId/actions/cancel" -Method POST
    }
}
