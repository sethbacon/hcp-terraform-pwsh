<#
.SYNOPSIS
    Force unlocks a workspace
.DESCRIPTION
    Force unlocks a workspace, even if it was locked by another user or a run
.PARAMETER WorkspaceId
    The workspace ID to force unlock
.EXAMPLE
    Invoke-TfcWorkspaceForceUnlock -WorkspaceId "ws-abc123"
.OUTPUTS
    PSCustomObject representing the unlocked workspace
#>
function Invoke-TfcWorkspaceForceUnlock {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if ($PSCmdlet.ShouldProcess("Workspace $WorkspaceId", "Force unlock")) {
        Write-Verbose "Force unlocking workspace: $WorkspaceId"
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/actions/force-unlock" -Method POST
    }
}
