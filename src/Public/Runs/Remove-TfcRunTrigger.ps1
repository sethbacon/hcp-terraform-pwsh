<#
.SYNOPSIS
    Removes a run trigger
.DESCRIPTION
    Deletes a run trigger between workspaces
.PARAMETER RunTriggerId
    The run trigger ID to delete
.EXAMPLE
    Remove-TfcRunTrigger -RunTriggerId "rt-abc123"
.OUTPUTS
    None
#>
function Remove-TfcRunTrigger {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunTriggerId
    )

    if ($PSCmdlet.ShouldProcess("Run Trigger $RunTriggerId", "Delete")) {
        Write-Verbose "Deleting run trigger: $RunTriggerId"
        Invoke-TfcApi -Uri "/run-triggers/$RunTriggerId" -Method DELETE | Out-Null
        return $true
    }
}
