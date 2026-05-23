<#
.SYNOPSIS
    Lists IP allowlists for an organization
.DESCRIPTION
    Retrieves CIDR range lists (IP allowlists) for an organization
.PARAMETER Organization
    The organization name
.PARAMETER Query
    Optional search query to filter allowlists by name
.PARAMETER PageNumber
    The page number (default: 1)
.PARAMETER PageSize
    Number of items per page (default: 20)
.PARAMETER AllPages
    Return all pages of results
.EXAMPLE
    Get-TfcIPAllowList -Organization "my-org"
.OUTPUTS
    PSCustomObject representing IP allowlists
#>
function Get-TfcIPAllowList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Query,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    $uri = "/organizations/$Organization/cidr-range-lists?page%5Bnumber%5D=$PageNumber&page%5Bsize%5D=$PageSize"
    if ($Query) {
        $encoded = [System.Web.HttpUtility]::UrlEncode($Query)
        $uri += "&q=$encoded"
    }

    Write-Verbose "Listing IP allowlists for organization: $Organization"
    if ($AllPages) {
        return Get-AllPages -InitialUri $uri
    }
    return Invoke-TfcApi -Uri $uri
}
