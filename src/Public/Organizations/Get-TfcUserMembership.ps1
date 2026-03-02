<#
.SYNOPSIS
    Lists organization memberships for the current user
.DESCRIPTION
    Retrieves all organization memberships for the authenticated user
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcUserMembership
.OUTPUTS
    PSCustomObject representing organization memberships
#>
function Get-TfcUserMembership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    $uri = "/organization-memberships?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting user organization memberships"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
