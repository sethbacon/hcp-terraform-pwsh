<#
.SYNOPSIS
    Finds a workspace by name across organizations
.DESCRIPTION
    Searches for a workspace by name, optionally within a specific organization
.PARAMETER WorkspaceName
    The name of the workspace to find
.PARAMETER Organization
    Optional organization name to limit the search
.PARAMETER ListOrganizations
    Switch to list all accessible organizations instead of searching for a workspace
.EXAMPLE
    Find-TfcWorkspace -WorkspaceName "my-workspace"
.EXAMPLE
    Find-TfcWorkspace -WorkspaceName "my-workspace" -Organization "my-org"
.EXAMPLE
    Find-TfcWorkspace -ListOrganizations
.OUTPUTS
    PSCustomObject representing the found workspace or list of organizations
#>
function Find-TfcWorkspace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [switch]$ListOrganizations
    )

    if ($ListOrganizations) {
        Write-Output "Fetching organizations you have access to..."
        $orgsResponse = Get-TfcOrganization

        Write-Output "`nOrganizations you have access to:"
        Write-Output "=================================="
        foreach ($org in $orgsResponse.data) {
            Write-Output "Name: $($org.attributes.name)"
            if ($org.attributes.email) {
                Write-Output "Email: $($org.attributes.email)"
            }
            Write-Output "Created: $($org.attributes.'created-at')"
            Write-Output "---"
        }
        return
    }

    if ([string]::IsNullOrEmpty($Organization)) {
        Write-Output "Please specify an organization name with -Organization parameter or use -ListOrganizations to see available organizations."
        return
    }

    Write-Output "Fetching workspaces from organization: $Organization"
    try {
        $workspacesResponse = Get-TfcWorkspace -Organization $Organization -AllPages

        Write-Output "`nWorkspaces in organization '$Organization':"
        Write-Output "=========================================="

        $matchingWorkspaces = @()
        foreach ($workspace in $workspacesResponse.data) {
            $workspaceInfo = @{
                Name = $workspace.attributes.name
                Id = $workspace.id
                Created = $workspace.attributes.'created-at'
                TerraformVersion = $workspace.attributes.'terraform-version'
                Locked = $workspace.attributes.locked
            }

            if ([string]::IsNullOrEmpty($WorkspaceName) -or $workspace.attributes.name -like "*$WorkspaceName*") {
                $matchingWorkspaces += $workspaceInfo
                Write-Output "Name: $($workspaceInfo.Name)"
                Write-Output "ID: $($workspaceInfo.Id)"
                Write-Output "Created: $($workspaceInfo.Created)"
                Write-Output "Terraform Version: $($workspaceInfo.TerraformVersion)"
                Write-Output "Locked: $($workspaceInfo.Locked)"
                Write-Output "---"
            }
        }

        if ($matchingWorkspaces.Count -eq 0) {
            if ($WorkspaceName) {
                Write-Output "No workspaces found matching '$WorkspaceName' in organization '$Organization'."
            }
            else {
                Write-Output "No workspaces found in organization '$Organization'."
            }
        }

        return $matchingWorkspaces
    }
    catch {
        if ($_.Exception.Message -like "*404*") {
            Write-Error "Organization '$Organization' not found or you don't have access to it. Try using -ListOrganizations to see organizations you have access to."
        }
        elseif ($_.Exception.Message -like "*401*") {
            Write-Error "Authentication failed. Please check your TFE_TOKEN environment variable."
        }
        elseif ($_.Exception.Message -like "*403*") {
            Write-Error "Access denied. Your API token does not have permission to access this resource."
        }
        else {
            Write-Error $_.Exception.Message
        }
    }
}
