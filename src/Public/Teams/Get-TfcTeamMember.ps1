function Get-TfcTeamMember {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId
    )

    Initialize-TfcConnection

    Write-Verbose "Listing members of team: $TeamId"
    return Invoke-TfcApi -Uri "/teams/$TeamId/relationships/organization-memberships" -Method GET
}
