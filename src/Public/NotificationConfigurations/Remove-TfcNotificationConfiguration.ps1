<#
.SYNOPSIS
    Removes a notification configuration
.DESCRIPTION
    Deletes a notification configuration from a workspace
.PARAMETER NotificationConfigurationId
    The notification configuration ID to delete
.EXAMPLE
    Remove-TfcNotificationConfiguration -NotificationConfigurationId "nc-abc123"
.OUTPUTS
    None
#>
function Remove-TfcNotificationConfiguration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NotificationConfigurationId
    )

    if ($PSCmdlet.ShouldProcess("Notification Configuration $NotificationConfigurationId", "Delete")) {
        Write-Verbose "Deleting notification configuration: $NotificationConfigurationId"
        Invoke-TfcApi -Uri "/notification-configurations/$NotificationConfigurationId" -Method DELETE
        Write-Output "Notification configuration '$NotificationConfigurationId' has been deleted"
    }
}
