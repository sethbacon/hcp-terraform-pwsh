<#
.SYNOPSIS
    Gets notification configurations for a workspace
.DESCRIPTION
    Retrieves notification configurations (webhooks, Slack, etc.) for a workspace
.PARAMETER WorkspaceId
    The workspace ID
.EXAMPLE
    Get-TfcNotificationConfiguration -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing notification configurations
#>
function Get-TfcNotificationConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    Write-Verbose "Getting notification configurations for workspace: $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/notification-configurations"
}
