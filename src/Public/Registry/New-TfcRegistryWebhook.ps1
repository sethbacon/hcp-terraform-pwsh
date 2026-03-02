<#
.SYNOPSIS
    Create a registry webhook
.DESCRIPTION
    Creates a new webhook for registry events
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER Url
    The webhook URL
.PARAMETER Events
    Array of events to trigger the webhook (e.g., @("module.published", "provider.published"))
.PARAMETER Enabled
    Whether the webhook is enabled (default: true)
.EXAMPLE
    New-TfcRegistryWebhook -OrganizationName "my-org" -Url "https://example.com/webhook" -Events @("module.published")
.OUTPUTS
    PSCustomObject representing the created webhook
#>
function New-TfcRegistryWebhook {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,

        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $true)]
        [string[]]$Events,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled = $true
    )

    try {
        Initialize-TfcConnection

        $body = @{
            data = @{
                type = "registry-webhooks"
                attributes = @{
                    url = $Url
                    events = $Events
                    enabled = $Enabled
                }
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Organization: $OrganizationName", "Create registry webhook")) {
            Write-Verbose "Creating registry webhook for: $Url"
            return Invoke-TfcApi -Uri "/organizations/$OrganizationName/registry-webhooks" -Method POST -Body $body
        }
    }
    catch {
        throw "Failed to create registry webhook: $($_.Exception.Message)"
    }
}
