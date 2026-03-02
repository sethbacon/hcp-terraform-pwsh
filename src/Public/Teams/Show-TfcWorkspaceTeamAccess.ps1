<#
.SYNOPSIS
    Shows team workspace access details
.DESCRIPTION
    Retrieves detailed information about a team's access to a workspace
.PARAMETER TeamWorkspaceId
    The team workspace relationship ID
.EXAMPLE
    Show-TfcWorkspaceTeamAccess -TeamWorkspaceId "tws-abc123"
.OUTPUTS
    PSCustomObject representing the team workspace access
#>
function Show-TfcWorkspaceTeamAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamWorkspaceId
    )

    Write-Verbose "Getting team workspace access: $TeamWorkspaceId"
    return Invoke-TfcApi -Uri "/team-workspaces/$TeamWorkspaceId"
}
