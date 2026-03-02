<#
.SYNOPSIS
    Removes VCS connection from a workspace
.DESCRIPTION
    Disconnects the VCS repository integration from a workspace
.PARAMETER WorkspaceId
    The ID of the workspace to remove VCS connection from
.EXAMPLE
    Remove-TfcWorkspaceVCS -WorkspaceId "ws-123"
.OUTPUTS
    PSCustomObject representing the updated workspace
#>
function Remove-TfcWorkspaceVCS {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    if ($PSCmdlet.ShouldProcess("Workspace $WorkspaceId", "Remove VCS connection")) {
        $body = @{
            data = @{
                type = 'workspaces'
                id = $WorkspaceId
                attributes = @{
                    'vcs-repo' = $null
                }
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Removing VCS connection from workspace: $WorkspaceId"
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId" -Method PATCH -Body $body
    }
}
