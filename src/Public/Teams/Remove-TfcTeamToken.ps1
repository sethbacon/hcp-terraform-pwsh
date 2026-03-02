<#
.SYNOPSIS
    Removes a team token
.DESCRIPTION
    Deletes the API token for a team
.PARAMETER TeamId
    The team ID
.EXAMPLE
    Remove-TfcTeamToken -TeamId "team-abc123"
.OUTPUTS
    None
#>
function Remove-TfcTeamToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId
    )

    if ($PSCmdlet.ShouldProcess("Team $TeamId Token", "Delete")) {
        Write-Verbose "Deleting team token for team: $TeamId"
        Invoke-TfcApi -Uri "/teams/$TeamId/authentication-token" -Method DELETE | Out-Null
        return $true
    }
}
