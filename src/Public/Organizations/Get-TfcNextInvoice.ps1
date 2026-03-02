<#
.SYNOPSIS
    Gets the next invoice for an organization
.DESCRIPTION
    Retrieves the upcoming invoice for a specified organization
.PARAMETER Organization
    The organization name
.EXAMPLE
    Get-TfcNextInvoice -Organization "my-org"
.OUTPUTS
    PSCustomObject representing the next invoice
#>
function Get-TfcNextInvoice {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Getting next invoice for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/invoices/next"
}
