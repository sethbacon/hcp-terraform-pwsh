<#
.SYNOPSIS
    Enable drift detection for a workspace
.DESCRIPTION
    Enables automated drift detection for a workspace
.PARAMETER WorkspaceId
    The ID of the workspace
.PARAMETER Schedule
    Cron schedule for drift detection (e.g., "0 0 * * *" for daily)
.EXAMPLE
    Enable-TfcDriftDetection -WorkspaceId "ws-123" -Schedule "0 0 * * *"
.OUTPUTS
    PSCustomObject representing drift detection configuration
#>
function Enable-TfcDriftDetection {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$Schedule
    )

    try {
        Initialize-TfcConnection

        $body = @{
            data = @{
                type = "drift-detection-settings"
                attributes = @{
                    enabled = $true
                    schedule = $Schedule
                }
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Enable drift detection")) {
            Write-Verbose "Enabling drift detection for workspace: $WorkspaceId"
            return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/drift-detection" -Method POST -Body $body
        }
    }
    catch {
        throw "Failed to enable drift detection: $($_.Exception.Message)"
    }
}
