<#
.SYNOPSIS
    List registry webhooks
.DESCRIPTION
    Retrieves registry webhooks for an organization
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Get-TfcRegistryWebhook -OrganizationName "my-org"
.OUTPUTS
    PSCustomObject representing webhooks
#>
function Get-TfcRegistryWebhook {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting registry webhooks for organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/registry-webhooks" -Method GET
    }
    catch {
        throw "Failed to get registry webhooks: $($_.Exception.Message)"
    }
}
