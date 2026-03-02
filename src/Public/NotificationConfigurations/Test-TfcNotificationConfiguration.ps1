<#
.SYNOPSIS
    Verifies a notification configuration
.DESCRIPTION
    Sends a test notification to verify the configuration
.PARAMETER NotificationConfigurationId
    The notification configuration ID to verify
.EXAMPLE
    Test-TfcNotificationConfiguration -NotificationConfigurationId "nc-abc123"
.OUTPUTS
    None
#>
function Test-TfcNotificationConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NotificationConfigurationId
    )

    Write-Verbose "Verifying notification configuration: $NotificationConfigurationId"
    Invoke-TfcApi -Uri "/notification-configurations/$NotificationConfigurationId/actions/verify" -Method POST
    Write-Output "Verification request sent for notification configuration '$NotificationConfigurationId'"
}
