<#
.SYNOPSIS
    Shows team token with details
.DESCRIPTION
    Retrieves detailed information about a team token
.PARAMETER TeamId
    The ID of the team
.EXAMPLE
    Show-TfcTeamToken -TeamId "team-123"
.OUTPUTS
    PSCustomObject representing the team token
#>
function Show-TfcTeamToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId
    )

    Write-Verbose "Retrieving team token for team: $TeamId"

    $result = Invoke-TfcApi -Uri "/teams/$TeamId/authentication-token"

    return $result.data
}
