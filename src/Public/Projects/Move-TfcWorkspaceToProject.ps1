<#
.SYNOPSIS
    Moves workspace(s) to a project
.DESCRIPTION
    Moves one or more workspaces into a specified project
.PARAMETER ProjectId
    The project ID to move workspaces into
.PARAMETER WorkspaceIds
    Array of workspace IDs to move into the project
.EXAMPLE
    Move-TfcWorkspaceToProject -ProjectId "prj-abc123" -WorkspaceIds @("ws-123", "ws-456")
.OUTPUTS
    Boolean indicating success
#>
function Move-TfcWorkspaceToProject {
    [OutputType([bool])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $true)]
        [string[]]$WorkspaceIds
    )

    Initialize-TfcConnection

    $workspaceData = $WorkspaceIds | ForEach-Object {
        @{
            type = "workspaces"
            id = $_
        }
    }

    $body = @{
        data = $workspaceData
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Project '$ProjectId'", "Move $($WorkspaceIds.Count) workspace(s)")) {
        Write-Verbose "Moving $($WorkspaceIds.Count) workspace(s) to project: $ProjectId"
        try {
            Invoke-TfcApi -Uri "/projects/$ProjectId/relationships/workspaces" -Method POST -Body $body | Out-Null
            return $true
        }
        catch {
            Write-Error "Failed to move workspaces to project: $_"
            return $false
        }
    }
}
