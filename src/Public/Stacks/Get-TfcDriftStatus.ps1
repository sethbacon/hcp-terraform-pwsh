<#
.SYNOPSIS
    Get drift detection status
.DESCRIPTION
    Retrieves the current drift detection status and configuration for a workspace
.PARAMETER WorkspaceId
    The ID of the workspace
.EXAMPLE
    Get-TfcDriftStatus -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing drift detection status
#>
function Get-TfcDriftStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting drift detection status for workspace: $WorkspaceId"
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/drift-detection" -Method GET
    }
    catch {
        throw "Failed to get drift detection status: $($_.Exception.Message)"
    }
}
