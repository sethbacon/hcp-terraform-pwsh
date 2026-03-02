<#
.SYNOPSIS
    Lists runs for an organization
.DESCRIPTION
    Retrieves runs across all workspaces in an organization
.PARAMETER Organization
    The organization name
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcOrganizationRun -Organization "my-org"
.OUTPUTS
    PSCustomObject representing organization runs
#>
function Get-TfcOrganizationRun {
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

    $uri = "/organizations/$Organization/runs?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting runs for organization: $Organization"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
