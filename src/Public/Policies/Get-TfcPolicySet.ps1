<#
.SYNOPSIS
    Gets policy sets in an organization
.DESCRIPTION
    Retrieves policy sets that group policies together for workspace targeting
.PARAMETER OrganizationName
    The organization name
.PARAMETER PolicySetId
    Optional specific policy set ID to retrieve
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcPolicySet -OrganizationName "my-org"
.EXAMPLE
    Get-TfcPolicySet -OrganizationName "my-org" -PolicySetId "polset-123"
.OUTPUTS
    PSCustomObject representing policy sets
#>
function Get-TfcPolicySet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $false)]
        [string]$PolicySetId,
        [switch]$AllPages
    )

    Initialize-TfcConnection

    if ($PolicySetId) {
        Write-Verbose "Getting policy set: $PolicySetId"
        return Invoke-TfcApi -Uri "/policy-sets/$PolicySetId"
    }

    Write-Verbose "Getting policy sets for organization: $OrganizationName"
    $uri = "/organizations/$OrganizationName/policy-sets"

    if ($AllPages) {
        return Get-AllPages -Uri $uri
    }

    return Invoke-TfcApi -Uri $uri
}
