<#
.SYNOPSIS
    Creates a run trigger
.DESCRIPTION
    Creates a link between a source workspace and a target workspace for run orchestration
.PARAMETER SourceWorkspaceId
    The source workspace ID that will trigger runs
.PARAMETER TargetWorkspaceId
    The target workspace ID that will be triggered
.EXAMPLE
    New-TfcRunTrigger -SourceWorkspaceId "ws-source123" -TargetWorkspaceId "ws-target456"
.OUTPUTS
    PSCustomObject representing the created run trigger
#>
function New-TfcRunTrigger {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceWorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$TargetWorkspaceId
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $SourceWorkspaceId)) {
        throw "Invalid source workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $TargetWorkspaceId)) {
        throw "Invalid target workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $body = @{
        data = @{
            type = "run-triggers"
            relationships = @{
                sourceable = @{
                    data = @{
                        type = "workspaces"
                        id = $SourceWorkspaceId
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating run trigger from $SourceWorkspaceId to $TargetWorkspaceId"
    if ($PSCmdlet.ShouldProcess("Workspace: $TargetWorkspaceId", "Create run trigger")) {
        return Invoke-TfcApi -Uri "/workspaces/$TargetWorkspaceId/run-triggers" -Method POST -Body $body
    }
}
