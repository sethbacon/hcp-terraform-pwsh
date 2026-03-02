<#
.SYNOPSIS
    Gets teams for an organization
.DESCRIPTION
    Retrieves teams from a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcTeam -Organization "my-org"
.OUTPUTS
    PSCustomObject representing the organization's teams
#>
function Get-TfcTeam {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    Write-Verbose "Getting teams for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/teams" -AllPages:$AllPages
}
