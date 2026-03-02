<#
.SYNOPSIS
    Removes a run task from a workspace
.DESCRIPTION
    Detaches a run task from a workspace
.PARAMETER WorkspaceTaskId
    The workspace task ID to remove
.EXAMPLE
    Remove-TfcWorkspaceRunTask -WorkspaceTaskId "wstask-abc123"
.OUTPUTS
    None
#>
function Remove-TfcWorkspaceRunTask {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceTaskId
    )

    if ($PSCmdlet.ShouldProcess("Workspace Task $WorkspaceTaskId", "Remove")) {
        Write-Verbose "Removing workspace task: $WorkspaceTaskId"
        Invoke-TfcApi -Uri "/workspace-tasks/$WorkspaceTaskId" -Method DELETE | Out-Null
        return $true
    }
}
