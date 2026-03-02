<#
.SYNOPSIS
    Disable drift detection for a workspace
.DESCRIPTION
    Disables automated drift detection for a workspace
.PARAMETER WorkspaceId
    The ID of the workspace
.EXAMPLE
    Disable-TfcDriftDetection -WorkspaceId "ws-123"
#>
function Disable-TfcDriftDetection {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    try {
        Initialize-TfcConnection

        if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Disable drift detection")) {
            Write-Verbose "Disabling drift detection for workspace: $WorkspaceId"
            return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/drift-detection" -Method DELETE
        }
    }
    catch {
        throw "Failed to disable drift detection: $($_.Exception.Message)"
    }
}
