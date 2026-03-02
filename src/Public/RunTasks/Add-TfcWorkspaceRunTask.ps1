<#
.SYNOPSIS
    Attaches a run task to a workspace
.DESCRIPTION
    Creates a relationship between a run task and a workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER RunTaskId
    The run task ID to attach
.PARAMETER EnforcementLevel
    Enforcement level: 'advisory' or 'mandatory'
.PARAMETER Stage
    Stage to run: 'pre_plan', 'post_plan', 'pre_apply', or 'post_apply'
.EXAMPLE
    Add-TfcWorkspaceRunTask -WorkspaceId "ws-123" -RunTaskId "task-abc" -EnforcementLevel "mandatory" -Stage "pre_plan"
.OUTPUTS
    PSCustomObject representing the workspace task relationship
#>
function Add-TfcWorkspaceRunTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$RunTaskId,

        [Parameter(Mandatory = $true)]
        [ValidateSet('advisory', 'mandatory')]
        [string]$EnforcementLevel,

        [Parameter(Mandatory = $false)]
        [ValidateSet('pre_plan', 'post_plan', 'pre_apply', 'post_apply')]
        [string]$Stage = 'post_plan'
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $body = @{
        data = @{
            type = "workspace-tasks"
            attributes = @{
                'enforcement-level' = $EnforcementLevel
                stage = $Stage
            }
            relationships = @{
                task = @{
                    data = @{
                        type = "tasks"
                        id = $RunTaskId
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Attaching run task $RunTaskId to workspace $WorkspaceId"
    return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/tasks" -Method POST -Body $body
}
