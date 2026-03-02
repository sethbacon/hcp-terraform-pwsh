<#
.SYNOPSIS
    Gets workspaces from an organization
.DESCRIPTION
    Retrieves workspaces from a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    Optional workspace name to get a specific workspace
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcWorkspace -Organization "my-org"
.EXAMPLE
    Get-TfcWorkspace -Organization "my-org" -Name "my-workspace"
.EXAMPLE
    Get-TfcWorkspace -Organization "my-org" -AllPages
.OUTPUTS
    PSCustomObject or array of PSCustomObjects representing workspaces
#>
function Get-TfcWorkspace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    if ($Name) {
        Write-Verbose "Getting workspace: $Organization/$Name"
        return Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$Name"
    }
    else {
        $uri = "/organizations/$Organization/workspaces?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
        Write-Verbose "Getting workspaces for organization: $Organization"
        return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
    }
}
