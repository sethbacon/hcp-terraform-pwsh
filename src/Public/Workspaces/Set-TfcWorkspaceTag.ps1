<#
.SYNOPSIS
    Sets tags on a workspace
.DESCRIPTION
    Adds or replaces tags on a workspace
.PARAMETER Organization
    The organization name
.PARAMETER Workspace
    The workspace name
.PARAMETER Tags
    Array of tag names to apply
.PARAMETER Replace
    If specified, replaces all existing tags. Otherwise, adds to existing tags.
.EXAMPLE
    Set-TfcWorkspaceTag -Organization "my-org" -Workspace "my-workspace" -Tags @("environment:prod", "team:platform")
.EXAMPLE
    Set-TfcWorkspaceTag -Organization "my-org" -Workspace "my-workspace" -Tags @("new-tag") -Replace
.OUTPUTS
    Boolean indicating success
#>
function Set-TfcWorkspaceTag {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Workspace,

        [Parameter(Mandatory = $true)]
        [string[]]$Tags,

        [Parameter()]
        [switch]$Replace
    )

    Write-Verbose "Setting tags on workspace: $Workspace in organization: $Organization"

    # Get workspace ID
    $workspace = Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$Workspace"
    $workspaceId = $workspace.data.id

    # Get or create tag IDs
    $tagData = @()
    foreach ($tagName in $Tags) {
        # Check if tag exists
        $existingTags = Invoke-TfcApi -Uri "/organizations/$Organization/tags?filter%5Bname%5D=$([uri]::EscapeDataString($tagName))"

        if ($existingTags.data -and $existingTags.data.Count -gt 0) {
            $tagId = $existingTags.data[0].id
            Write-Verbose "Using existing tag: $tagName (ID: $tagId)"
        }
        else {
            # Create new tag
            Write-Verbose "Creating new tag: $tagName"
            $newTagBody = @{
                data = @{
                    type = "tags"
                    attributes = @{
                        name = $tagName
                    }
                }
            } | ConvertTo-Json -Depth 10

            $newTag = Invoke-TfcApi -Uri "/organizations/$Organization/tags" -Method POST -Body $newTagBody
            $tagId = $newTag.data.id
        }

        $tagData += @{
            type = "tags"
            id = $tagId
        }
    }

    # Apply tags to workspace
    $body = @{
        data = @{
            type = "workspaces"
            id = $workspaceId
            relationships = @{
                tags = @{
                    data = $tagData
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    try {
        $action = if ($Replace) { "Replace all tags on" } else { "Add tags to" }
        if ($PSCmdlet.ShouldProcess("Workspace: $Workspace", "$action workspace")) {
            if ($Replace) {
                Write-Verbose "Replacing all tags on workspace"
                Invoke-TfcApi -Uri "/workspaces/$workspaceId/relationships/tags" -Method PATCH -Body $body
            }
            else {
                Write-Verbose "Adding tags to workspace"
                Invoke-TfcApi -Uri "/workspaces/$workspaceId/relationships/tags" -Method POST -Body $body
            }
        }
        return $true
    }
    catch {
        Write-Error "Failed to set tags: $_"
        return $false
    }
}
