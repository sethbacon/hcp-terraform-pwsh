<#
.SYNOPSIS
    Gets VCS events for a workspace
.DESCRIPTION
    Retrieves version control system events for debugging VCS connections
.PARAMETER WorkspaceId
    The workspace ID
.EXAMPLE
    Get-TfcVCSEvent -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing VCS events
#>
function Get-TfcVCSEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    Write-Verbose "Getting VCS events for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/vcs-events"
}
