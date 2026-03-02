<#
.SYNOPSIS
    Gets policies in an organization
.DESCRIPTION
    Retrieves Sentinel or OPA policies for policy-as-code enforcement
.PARAMETER OrganizationName
    The organization name
.PARAMETER PolicyId
    Optional specific policy ID to retrieve
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcPolicy -OrganizationName "my-org"
.EXAMPLE
    Get-TfcPolicy -OrganizationName "my-org" -PolicyId "pol-123"
.OUTPUTS
    PSCustomObject representing policies
#>
function Get-TfcPolicy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $false)]
        [string]$PolicyId,
        [switch]$AllPages
    )

    Initialize-TfcConnection

    if ($PolicyId) {
        Write-Verbose "Getting policy: $PolicyId"
        return Invoke-TfcApi -Uri "/policies/$PolicyId"
    }

    Write-Verbose "Getting policies for organization: $OrganizationName"
    $uri = "/organizations/$OrganizationName/policies"

    if ($AllPages) {
        return Get-AllPages -Uri $uri
    }

    return Invoke-TfcApi -Uri $uri
}
