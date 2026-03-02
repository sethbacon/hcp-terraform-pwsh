function Get-TfcOrganizationMembership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $false)]
        [string]$MembershipId
    )

    Initialize-TfcConnection

    if ($MembershipId) {
        Write-Verbose "Getting organization membership: $MembershipId"
        return Invoke-TfcApi -Uri "/organization-memberships/$MembershipId" -Method GET
    } else {
        Write-Verbose "Listing all memberships for organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/organization-memberships" -Method GET
    }
}
