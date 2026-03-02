<#
.SYNOPSIS
    Removes team access from a workspace
.DESCRIPTION
    Revokes a team's access to a workspace
.PARAMETER TeamWorkspaceId
    The team workspace relationship ID to remove
.EXAMPLE
    Remove-TfcWorkspaceTeamAccess -TeamWorkspaceId "tws-abc123"
.OUTPUTS
    None
#>
function Remove-TfcWorkspaceTeamAccess {
    [OutputType([bool])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamWorkspaceId
    )

    if ($PSCmdlet.ShouldProcess("Team Workspace Access $TeamWorkspaceId", "Remove")) {
        Write-Verbose "Removing team workspace access: $TeamWorkspaceId"
        Invoke-TfcApi -Uri "/team-workspaces/$TeamWorkspaceId" -Method DELETE | Out-Null
        return $true
    }
}
