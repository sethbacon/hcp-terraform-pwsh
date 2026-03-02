<#
.SYNOPSIS
    Gets organization membership details
.DESCRIPTION
    Retrieves detailed information about an organization membership including relationships
.PARAMETER MembershipId
    The ID of the organization membership
.PARAMETER Include
    Optional array of relationships to include (user, teams, organization)
.EXAMPLE
    Get-TfcOrganizationMembershipDetails -MembershipId "om-123"
.EXAMPLE
    Get-TfcOrganizationMembershipDetails -MembershipId "om-123" -Include @('user', 'teams')
.OUTPUTS
    PSCustomObject representing the organization membership
#>
function Get-TfcOrganizationMembershipDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$MembershipId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('user', 'teams', 'organization')]
        [string[]]$Include
    )

    $uri = "/organization-memberships/$MembershipId"

    if ($Include) {
        $includeParam = $Include -join ','
        $uri += "?include=$includeParam"
        Write-Verbose "Retrieving organization membership $MembershipId with relationships: $includeParam"
    } else {
        Write-Verbose "Retrieving organization membership: $MembershipId"
    }

    return Invoke-TfcApi -Uri $uri
}
