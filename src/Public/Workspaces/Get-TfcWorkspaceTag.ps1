<#
.SYNOPSIS
    Gets tags from a workspace
.DESCRIPTION
    Retrieves all tags assigned to a workspace
.PARAMETER Organization
    The organization name
.PARAMETER Workspace
    The workspace name
.EXAMPLE
    Get-TfcWorkspaceTag -Organization "my-org" -Workspace "my-workspace"
.OUTPUTS
    Array of tag objects
#>
function Get-TfcWorkspaceTag {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Workspace
    )

    Write-Verbose "Getting tags for workspace: $Workspace in organization: $Organization"
    $workspace = Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$Workspace"

    if ($workspace.data.relationships.'tag-bindings'.data) {
        $tagIds = $workspace.data.relationships.'tag-bindings'.data | ForEach-Object { $_.id }
        Write-Verbose "Found $($tagIds.Count) tags"
        return $tagIds
    }
    else {
        Write-Verbose "No tags found on workspace"
        return @()
    }
}
