<#
.SYNOPSIS
    Lists team tokens for an organization
.DESCRIPTION
    Retrieves team tokens for a specified organization
.PARAMETER Organization
    The organization name
.EXAMPLE
    Get-TfcOrganizationTeamToken -Organization "my-org"
.OUTPUTS
    PSCustomObject representing the team tokens
#>
function Get-TfcOrganizationTeamToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Getting team tokens for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/team-tokens"
}
