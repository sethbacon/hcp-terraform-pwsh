<#
.SYNOPSIS
    List subscriptions
.DESCRIPTION
    Retrieves billing subscription information (requires admin access)
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Get-TfcSubscription -OrganizationName my-org
#>
function Get-TfcSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    Initialize-TfcConnection
    Write-Verbose "Getting subscription for organization: $OrganizationName"
    return Invoke-TfcApi -Uri "/organizations/$OrganizationName/subscription" -Method GET
}
