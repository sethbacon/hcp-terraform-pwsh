<#
.SYNOPSIS
    Get assessment results for a workspace
.DESCRIPTION
    Retrieves drift detection and health check assessment results
.PARAMETER WorkspaceId
    The ID of the workspace (format: ws-xxxxx)
.EXAMPLE
    Get-TfcAssessmentResult -WorkspaceId ws-abc123
#>
function Get-TfcAssessmentResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting assessment results for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/assessment-results" -Method GET
}
