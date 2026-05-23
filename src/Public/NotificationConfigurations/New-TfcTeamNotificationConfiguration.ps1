<#
.SYNOPSIS
    Creates a team-scoped notification configuration
.DESCRIPTION
    Creates a notification configuration attached to a team. Use the existing
    Update/Remove/Test-TfcNotificationConfiguration cmdlets to manage the resource
    after creation.
.PARAMETER TeamId
    The team ID
.PARAMETER DestinationType
    Type: 'slack', 'generic', 'email', or 'microsoft-teams'
.PARAMETER Name
    Configuration name
.PARAMETER Url
    Webhook URL (for slack, generic, microsoft-teams)
.PARAMETER Enabled
    Whether enabled (default: true)
.PARAMETER Triggers
    Array of triggers
.PARAMETER EmailAddresses
    Email addresses (for email type)
.PARAMETER EmailUserIds
    User IDs to email (for email type)
.PARAMETER Token
    Optional secure token for authenticity verification
.EXAMPLE
    New-TfcTeamNotificationConfiguration -TeamId "team-abc123" -DestinationType "slack" -Name "Team Alerts" -Url "https://hooks.slack.com/..."
.OUTPUTS
    PSCustomObject representing the created notification configuration
#>
function New-TfcTeamNotificationConfiguration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId,

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
        [string[]]$EmailUserIds,

        [Parameter(Mandatory = $false)]
        [string]$Token
    )

    $attributes = @{
        'destination-type' = $DestinationType
        name = $Name
        enabled = $Enabled
    }
    if ($Url) { $attributes['url'] = $Url }
    if ($Triggers) { $attributes['triggers'] = $Triggers }
    if ($EmailAddresses) { $attributes['email-addresses'] = $EmailAddresses }
    if ($EmailUserIds) { $attributes['email-user-ids'] = $EmailUserIds }
    if ($Token) { $attributes['token'] = $Token }

    $body = @{
        data = @{
            type = 'notification-configurations'
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating team notification '$Name' for team: $TeamId"
    if ($PSCmdlet.ShouldProcess("Team: $TeamId", "Create notification: $Name")) {
        return Invoke-TfcApi -Uri "/teams/$TeamId/notification-configurations" -Method POST -Body $body
    }
}
