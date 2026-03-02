<#
.SYNOPSIS
    Removes a run task
.DESCRIPTION
    Deletes a run task from an organization
.PARAMETER RunTaskId
    The run task ID to delete
.EXAMPLE
    Remove-TfcRunTask -RunTaskId "task-abc123"
.OUTPUTS
    None
#>
function Remove-TfcRunTask {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunTaskId
    )

    if ($PSCmdlet.ShouldProcess("Run Task $RunTaskId", "Delete")) {
        Write-Verbose "Deleting run task: $RunTaskId"
        Invoke-TfcApi -Uri "/tasks/$RunTaskId" -Method DELETE | Out-Null
        return $true
    }
}
