<#
.SYNOPSIS
    Gets variable sets for an organization
.DESCRIPTION
    Retrieves variable sets from a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcVariableSet -Organization "my-org"
.EXAMPLE
    Get-TfcVariableSet -Organization "my-org" -AllPages
.OUTPUTS
    PSCustomObject representing the organization's variable sets
#>
function Get-TfcVariableSet {
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

    $uri = "/organizations/$Organization/varsets?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting variable sets for organization: $Organization"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
