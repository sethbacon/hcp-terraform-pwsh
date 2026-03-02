<#
.SYNOPSIS
    Rollback workspace to previous state
.DESCRIPTION
    Rolls back a workspace to a previous state version
.PARAMETER WorkspaceId
    The ID of the workspace (format: ws-xxxxx)
.PARAMETER StateVersionId
    The ID of the state version to roll back to (format: sv-xxxxx)
.EXAMPLE
    Invoke-TfcStateRollback -WorkspaceId ws-abc123 -StateVersionId sv-xyz789
#>
function Invoke-TfcStateRollback {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,
        [Parameter(Mandatory = $true)]
        [string]$StateVersionId
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "state-versions"
            attributes = @{
                serial = (Get-TfcStateVersion -StateVersionId $StateVersionId).data.attributes.serial
            }
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Rollback to state version: $StateVersionId")) {
        Write-Verbose "Rolling back workspace $WorkspaceId to state version: $StateVersionId"
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/state-versions" -Method POST -Body $body
    }
}
