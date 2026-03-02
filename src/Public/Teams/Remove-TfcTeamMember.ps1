function Remove-TfcTeamMember {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
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

    if ($PSCmdlet.ShouldProcess("Team '$TeamId'", "Remove members")) {
        Write-Verbose "Removing members from team: $TeamId"
        Invoke-TfcApi -Uri "/teams/$TeamId/relationships/organization-memberships" -Method DELETE -Body $body | Out-Null
        return $true
    }
}
