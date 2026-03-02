<#
.SYNOPSIS
    Gets workspace resources
.DESCRIPTION
    Retrieves resources managed by a workspace from the latest state
.PARAMETER WorkspaceId
    The workspace ID
.EXAMPLE
    Get-TfcWorkspaceResource -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing workspace resources
#>
function Get-TfcWorkspaceResource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    Write-Verbose "Getting resources for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/resources"
}
