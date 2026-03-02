function Add-TfcTeamMember {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId,
        [Parameter(Mandatory = $true)]
        [string[]]$OrganizationMembershipIds
    )

    Initialize-TfcConnection

    $body = @{
        data = @($OrganizationMembershipIds | ForEach-Object {
            @{
                type = "organization-memberships"
                id = $_
            }
        })
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Team '$TeamId'", "Add members")) {
        Write-Verbose "Adding members to team: $TeamId"
        Invoke-TfcApi -Uri "/teams/$TeamId/relationships/organization-memberships" -Method POST -Body $body | Out-Null
        return $true
    }
}
