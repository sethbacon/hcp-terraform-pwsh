<#
.SYNOPSIS
    Gets invoice details
.DESCRIPTION
    Retrieves invoice details for an organization (admin only)
.PARAMETER Organization
    The name of the organization
.PARAMETER InvoiceId
    Optional specific invoice ID to retrieve
.EXAMPLE
    Get-TfcInvoiceDetails -Organization "my-org"
.EXAMPLE
    Get-TfcInvoiceDetails -Organization "my-org" -InvoiceId "inv-123"
.OUTPUTS
    PSCustomObject or array of PSCustomObjects representing invoices
#>
function Get-TfcInvoiceDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$InvoiceId
    )

    if ($InvoiceId) {
        Write-Verbose "Retrieving invoice $InvoiceId for organization: $Organization"
        $result = Invoke-TfcApi -Uri "/organizations/$Organization/invoices/$InvoiceId"
        return $result.data
    } else {
        Write-Verbose "Retrieving all invoices for organization: $Organization"
        $result = Invoke-TfcApi -Uri "/organizations/$Organization/invoices"
        return $result.data
    }
}
