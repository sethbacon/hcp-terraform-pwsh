<#
.SYNOPSIS
    Creates a notification configuration
.DESCRIPTION
    Creates a new notification configuration for a workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER DestinationType
    Type: 'slack', 'generic', 'email', or 'microsoft-teams'
.PARAMETER Name
    Configuration name
.PARAMETER Url
    Webhook URL (for slack, generic, microsoft-teams)
.PARAMETER Enabled
    Whether enabled (default: true)
.PARAMETER Triggers
    Array of triggers: 'run:created', 'run:planning', 'run:needs_attention', 'run:applying', 'run:completed', 'run:errored'
.PARAMETER EmailAddresses
    Email addresses (for email type)
.PARAMETER EmailUserIds
    User IDs to email (for email type)
.EXAMPLE
    New-TfcNotificationConfiguration -WorkspaceId "ws-123" -DestinationType "slack" -Name "Slack Alerts" -Url "https://hooks.slack.com/..." -Triggers @("run:completed", "run:errored")
.OUTPUTS
    PSCustomObject representing the created notification configuration
#>
function New-TfcNotificationConfiguration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateSet('slack', 'generic', 'email', 'microsoft-teams')]
        [string]$DestinationType,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled = $true,

        [Parameter(Mandatory = $false)]
        [string[]]$Triggers,

        [Parameter(Mandatory = $false)]
        [string[]]$EmailAddresses,

        [Parameter(Mandatory = $false)]
        [string[]]$EmailUserIds
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $attributes = @{
        'destination-type' = $DestinationType
        name = $Name
        enabled = $Enabled
    }

    if ($Url) {
        $attributes['url'] = $Url
    }

    if ($Triggers) {
        $attributes['triggers'] = $Triggers
    }

    if ($EmailAddresses) {
        $attributes['email-addresses'] = $EmailAddresses
    }

    if ($EmailUserIds) {
        $attributes['email-user-ids'] = $EmailUserIds
    }

    $body = @{
        data = @{
            type = "notification-configurations"
            attributes = $attributes
            relationships = @{
                workspace = @{
                    data = @{
                        type = "workspaces"
                        id = $WorkspaceId
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating notification configuration '$Name' for workspace $WorkspaceId"
    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Create notification: $Name")) {
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/notification-configurations" -Method POST -Body $body
    }
}
