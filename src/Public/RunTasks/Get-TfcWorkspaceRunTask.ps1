<#
.SYNOPSIS
    Gets workspace run tasks
.DESCRIPTION
    Retrieves run tasks attached to a workspace
.PARAMETER WorkspaceId
    The workspace ID
.EXAMPLE
    Get-TfcWorkspaceRunTask -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing workspace run tasks
#>
function Get-TfcWorkspaceRunTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    Write-Verbose "Getting run tasks for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/tasks"
}
