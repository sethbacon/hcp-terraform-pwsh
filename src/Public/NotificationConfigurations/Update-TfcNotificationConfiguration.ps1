<#
.SYNOPSIS
    Updates a notification configuration
.DESCRIPTION
    Updates an existing notification configuration
.PARAMETER NotificationConfigurationId
    The notification configuration ID
.PARAMETER Name
    New name
.PARAMETER Url
    New URL
.PARAMETER Enabled
    Whether enabled
.PARAMETER Triggers
    New triggers array
.EXAMPLE
    Update-TfcNotificationConfiguration -NotificationConfigurationId "nc-abc123" -Enabled $false
.OUTPUTS
    PSCustomObject representing the updated configuration
#>
function Update-TfcNotificationConfiguration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NotificationConfigurationId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled,

        [Parameter(Mandatory = $false)]
        [string[]]$Triggers
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('Name')) { $attributes['name'] = $Name }
    if ($PSBoundParameters.ContainsKey('Url')) { $attributes['url'] = $Url }
    if ($PSBoundParameters.ContainsKey('Enabled')) { $attributes['enabled'] = $Enabled }
    if ($PSBoundParameters.ContainsKey('Triggers')) { $attributes['triggers'] = $Triggers }

    if ($attributes.Count -eq 0) {
        throw "At least one attribute must be specified for update"
    }

    $body = @{
        data = @{
            type = "notification-configurations"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating notification configuration: $NotificationConfigurationId"
    if ($PSCmdlet.ShouldProcess("Notification: $NotificationConfigurationId", "Update notification configuration")) {
        return Invoke-TfcApi -Uri "/notification-configurations/$NotificationConfigurationId" -Method PATCH -Body $body
    }
}
