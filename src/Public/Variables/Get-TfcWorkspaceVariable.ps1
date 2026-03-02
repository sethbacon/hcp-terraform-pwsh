<#
.SYNOPSIS
    Gets variables from a workspace
.DESCRIPTION
    Retrieves all variables from a specific workspace
.PARAMETER WorkspaceId
    The workspace ID
.EXAMPLE
    Get-TfcWorkspaceVariable -WorkspaceId "ws-1234567890abcdef"
.OUTPUTS
    PSCustomObject representing the workspace variables
#>
function Get-TfcWorkspaceVariable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    Write-Verbose "Getting variables for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/vars"
}
