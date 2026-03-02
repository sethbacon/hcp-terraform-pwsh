<#
.SYNOPSIS
    Update a registry webhook
.DESCRIPTION
    Updates an existing registry webhook
.PARAMETER WebhookId
    The ID of the webhook
.PARAMETER Url
    New webhook URL
.PARAMETER Events
    New array of events
.PARAMETER Enabled
    Whether the webhook is enabled
.EXAMPLE
    Update-TfcRegistryWebhook -WebhookId "webhook-123" -Enabled $false
.OUTPUTS
    PSCustomObject representing the updated webhook
#>
function Update-TfcRegistryWebhook {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WebhookId,

        [Parameter(Mandatory = $false)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string[]]$Events,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled
    )

    try {
        Initialize-TfcConnection

        $attributes = @{}
        if ($Url) { $attributes['url'] = $Url }
        if ($Events) { $attributes['events'] = $Events }
        if ($PSBoundParameters.ContainsKey('Enabled')) { $attributes['enabled'] = $Enabled }

        if ($attributes.Count -eq 0) {
            throw "At least one attribute must be specified for update"
        }

        $body = @{
            data = @{
                type = "registry-webhooks"
                attributes = $attributes
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Webhook: $WebhookId", "Update webhook")) {
            Write-Verbose "Updating registry webhook: $WebhookId"
            return Invoke-TfcApi -Uri "/registry-webhooks/$WebhookId" -Method PATCH -Body $body
        }
    }
    catch {
        throw "Failed to update registry webhook: $($_.Exception.Message)"
    }
}
