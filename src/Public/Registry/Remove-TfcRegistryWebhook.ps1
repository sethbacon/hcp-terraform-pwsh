<#
.SYNOPSIS
    Delete a registry webhook
.DESCRIPTION
    Removes a registry webhook
.PARAMETER WebhookId
    The ID of the webhook to delete
.EXAMPLE
    Remove-TfcRegistryWebhook -WebhookId "webhook-123"
#>
function Remove-TfcRegistryWebhook {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WebhookId
    )

    try {
        Initialize-TfcConnection

        if ($PSCmdlet.ShouldProcess("Webhook: $WebhookId", "Delete webhook")) {
            Write-Verbose "Deleting registry webhook: $WebhookId"
            return Invoke-TfcApi -Uri "/registry-webhooks/$WebhookId" -Method DELETE
        }
    }
    catch {
        throw "Failed to delete registry webhook: $($_.Exception.Message)"
    }
}
