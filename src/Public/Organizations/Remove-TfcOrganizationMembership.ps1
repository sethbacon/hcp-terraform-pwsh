function Remove-TfcOrganizationMembership {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$MembershipId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Membership '$MembershipId'", "Remove from organization")) {
        Write-Verbose "Removing organization membership: $MembershipId"
        Invoke-TfcApi -Uri "/organization-memberships/$MembershipId" -Method DELETE | Out-Null
        return $true
    }
}
