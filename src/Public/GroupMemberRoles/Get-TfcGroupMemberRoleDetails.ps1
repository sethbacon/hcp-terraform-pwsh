<#
.SYNOPSIS
    Gets group member role details with group filter
.DESCRIPTION
    Retrieves group member roles for a specific resource, filtered by group
.PARAMETER ResourceType
    The resource type (e.g., "organizations", "projects", "workspaces")
.PARAMETER ResourceId
    The resource ID
.PARAMETER GroupId
    The group ID to filter by
.EXAMPLE
    Get-TfcGroupMemberRoleDetails -ResourceType "organizations" -ResourceId "org-abc123" -GroupId "group-abc123"
.OUTPUTS
    PSCustomObject representing filtered group member roles
#>
function Get-TfcGroupMemberRoleDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("organizations", "projects", "workspaces")]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [string]$ResourceId,

        [Parameter(Mandatory = $true)]
        [string]$GroupId
    )

    $uri = "/member-roles/$ResourceType/$ResourceId?filter%5Bgroup%5D=$GroupId"
    Write-Verbose "Getting group member role details for $ResourceType/$ResourceId filtered by group: $GroupId"
    return Invoke-TfcApi -Uri $uri
}
