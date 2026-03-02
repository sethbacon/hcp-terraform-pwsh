<#
.SYNOPSIS
    Gets projects for an organization
.DESCRIPTION
    Retrieves projects from a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    Optional project name to get a specific project
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcProject -Organization "my-org"
.EXAMPLE
    Get-TfcProject -Organization "my-org" -Name "production"
.OUTPUTS
    PSCustomObject representing the organization's projects
#>
function Get-TfcProject {
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
        Write-Verbose "Getting project '$Name' from organization: $Organization"
        return Invoke-TfcApi -Uri "/organizations/$Organization/projects/$Name"
    }
    else {
        $uri = "/organizations/$Organization/projects?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
        Write-Verbose "Getting projects for organization: $Organization"
        return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
    }
}
