<#
.SYNOPSIS
    List change requests for a workspace
.DESCRIPTION
    Retrieves all change requests for a workspace
.PARAMETER WorkspaceId
    The ID of the workspace (format: ws-xxxxx)
.EXAMPLE
    Get-TfcChangeRequest -WorkspaceId ws-abc123
#>
function Get-TfcChangeRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting change requests for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/change-requests" -Method GET
}
