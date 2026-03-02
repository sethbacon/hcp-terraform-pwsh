function Get-TfcTeamMemberDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId,
        [Parameter(Mandatory = $true)]
        [string]$OrganizationMembershipId
    )

    Initialize-TfcConnection

    Write-Verbose "Getting details for member: $OrganizationMembershipId in team: $TeamId"
    return Invoke-TfcApi -Uri "/teams/$TeamId/relationships/organization-memberships/$OrganizationMembershipId" -Method GET
}
