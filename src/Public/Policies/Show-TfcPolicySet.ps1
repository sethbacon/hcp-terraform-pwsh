<#
.SYNOPSIS
    Shows a policy set with all relationships
.DESCRIPTION
    Retrieves a policy set with included relationships (policies, workspaces, projects, etc.)
.PARAMETER PolicySetId
    The ID of the policy set to retrieve
.PARAMETER Include
    Comma-separated list of relationships to include. Options: policies, workspaces, projects,
    newest-version, current-run, organization
.EXAMPLE
    Show-TfcPolicySet -PolicySetId "polset-123"
.EXAMPLE
    Show-TfcPolicySet -PolicySetId "polset-123" -Include "policies,workspaces,projects"
.OUTPUTS
    PSCustomObject with policy set and included relationships
#>
function Show-TfcPolicySet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,

        [Parameter(Mandatory = $false)]
        [string]$Include = "policies,workspaces,projects"
    )

    $uri = "/policy-sets/$PolicySetId"

    if ($Include) {
        $uri += "?include=$Include"
    }

    Write-Verbose "Getting policy set with relationships: $PolicySetId"
    return Invoke-TfcApi -Uri $uri
}
