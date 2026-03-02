<#
.SYNOPSIS
    List invoices
.DESCRIPTION
    Retrieves billing invoices for an organization (requires admin access)
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Get-TfcInvoice -OrganizationName my-org
#>
function Get-TfcInvoice {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    Initialize-TfcConnection
    Write-Verbose "Getting invoices for organization: $OrganizationName"
    return Invoke-TfcApi -Uri "/organizations/$OrganizationName/invoices" -Method GET
}
