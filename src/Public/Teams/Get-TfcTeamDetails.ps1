<#
.SYNOPSIS
    Gets details of a team
.DESCRIPTION
    Retrieves details of a specific team by ID
.PARAMETER TeamId
    The team ID
.EXAMPLE
    Get-TfcTeamDetails -TeamId "team-abc123"
.OUTPUTS
    PSCustomObject representing the team details
#>
function Get-TfcTeamDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId
    )

    Write-Verbose "Getting team details: $TeamId"
    return Invoke-TfcApi -Uri "/teams/$TeamId"
}
