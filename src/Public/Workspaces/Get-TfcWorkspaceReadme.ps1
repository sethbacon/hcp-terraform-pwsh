<#
.SYNOPSIS
    Gets workspace README content
.DESCRIPTION
    Retrieves the README.md content from a workspace's VCS repository
.PARAMETER WorkspaceId
    The ID of the workspace to get README for
.EXAMPLE
    Get-TfcWorkspaceReadme -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject containing README content
#>
function Get-TfcWorkspaceReadme {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    Write-Verbose "Getting README for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/readme"
}
