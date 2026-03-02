<#
.SYNOPSIS
    Gets the subscription for an organization
.DESCRIPTION
    Retrieves the subscription details for a specified organization
.PARAMETER Organization
    The organization name
.EXAMPLE
    Get-TfcOrganizationSubscription -Organization "my-org"
.OUTPUTS
    PSCustomObject representing the organization subscription
#>
function Get-TfcOrganizationSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Getting subscription for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/subscription"
}
