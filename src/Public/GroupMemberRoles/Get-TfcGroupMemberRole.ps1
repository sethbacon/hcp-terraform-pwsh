<#
.SYNOPSIS
    Lists group member roles for a resource
.DESCRIPTION
    Retrieves group member roles for a specific resource type and ID
.PARAMETER ResourceType
    The resource type (e.g., "organizations", "projects", "workspaces")
.PARAMETER ResourceId
    The resource ID
.EXAMPLE
    Get-TfcGroupMemberRole -ResourceType "organizations" -ResourceId "org-abc123"
.OUTPUTS
    PSCustomObject representing group member roles
#>
function Get-TfcGroupMemberRole {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("organizations", "projects", "workspaces")]
        [string]$ResourceType,

        [Parameter(Mandatory = $true)]
        [string]$ResourceId
    )

    Write-Verbose "Getting group member roles for $ResourceType/$ResourceId"
    return Invoke-TfcApi -Uri "/member-roles/$ResourceType/$ResourceId"
}
