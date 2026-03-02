<#
.SYNOPSIS
    Lists HYOK configurations for an organization
.DESCRIPTION
    Retrieves Hold Your Own Key (HYOK) configurations for the specified organization.
    Supports pagination and retrieving all pages of results.
.PARAMETER Organization
    The name of the organization
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of results per page (default: 20, max: 100)
.PARAMETER PageNumber
    Page number to retrieve (default: 1)
.EXAMPLE
    Get-TfcHYOKConfiguration -Organization "my-org"
.EXAMPLE
    Get-TfcHYOKConfiguration -Organization "my-org" -AllPages
.EXAMPLE
    Get-TfcHYOKConfiguration -Organization "my-org" -PageSize 50 -PageNumber 2
.OUTPUTS
    PSCustomObject representing HYOK configurations
#>
function Get-TfcHYOKConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    $uri = "/organizations/$Organization/hyok-configurations?page%5Bnumber%5D=$PageNumber&page%5Bsize%5D=$PageSize"

    Write-Verbose "Getting HYOK configurations for organization: $Organization"

    if ($AllPages) {
        return Invoke-TfcApi -Uri $uri -Method GET -AllPages
    }

    return Invoke-TfcApi -Uri $uri -Method GET
}
