<#
.SYNOPSIS
    Gets team access for a workspace
.DESCRIPTION
    Retrieves team access permissions for a specific workspace
.PARAMETER WorkspaceId
    The workspace ID
.EXAMPLE
    Get-TfcTeamAccess -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing team access to the workspace
#>
function Get-TfcTeamAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    Write-Verbose "Getting team access for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/team-workspaces?filter%5Bworkspace%5D%5Bid%5D=$WorkspaceId"
}
