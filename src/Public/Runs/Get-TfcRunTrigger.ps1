<#
.SYNOPSIS
    Gets run triggers for a workspace
.DESCRIPTION
    Retrieves run triggers that link workspaces together for orchestration
.PARAMETER WorkspaceId
    The workspace ID to get triggers for
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcRunTrigger -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing run triggers
#>
function Get-TfcRunTrigger {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    Write-Verbose "Getting run triggers for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/run-triggers" -AllPages:$AllPages
}
