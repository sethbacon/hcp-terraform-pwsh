<#
.SYNOPSIS
    Safely removes a workspace after verifying it has no managed resources
.DESCRIPTION
    Deletes a workspace only after confirming it has no managed resources in state.
    This prevents accidental deletion of workspaces managing active infrastructure.
.PARAMETER Organization
    The name of the organization
.PARAMETER WorkspaceName
    The name of the workspace to delete
.PARAMETER Force
    Skip resource count check and force deletion
.EXAMPLE
    Remove-TfcWorkspaceSafely -Organization "my-org" -WorkspaceName "test-workspace"
.EXAMPLE
    Remove-TfcWorkspaceSafely -Organization "my-org" -WorkspaceName "test-workspace" -Force
.OUTPUTS
    Boolean indicating success or failure
#>
function Remove-TfcWorkspaceSafely {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    Write-Verbose "Checking workspace safety: $WorkspaceName"

    # Get workspace details
    $workspace = Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$WorkspaceName"

    if (-not $workspace.data) {
        Write-Error "Workspace $WorkspaceName not found in organization $Organization"
        return $false
    }

    $resourceCount = $workspace.data.attributes.'resource-count'

    if (-not $Force -and $resourceCount -gt 0) {
        Write-Error "Workspace $WorkspaceName has $resourceCount managed resources. Use -Force to delete anyway."
        return $false
    }

    if ($resourceCount -gt 0) {
        Write-Warning "Workspace $WorkspaceName has $resourceCount managed resources but Force flag is set"
    }

    if ($PSCmdlet.ShouldProcess("Workspace $WorkspaceName", "Delete workspace")) {
        try {
            $workspaceId = $workspace.data.id
            Invoke-TfcApi -Uri "/workspaces/$workspaceId" -Method DELETE
            Write-Verbose "Successfully deleted workspace: $WorkspaceName"
            return $true
        } catch {
            Write-Error "Failed to delete workspace: $_"
            return $false
        }
    }

    return $false
}
