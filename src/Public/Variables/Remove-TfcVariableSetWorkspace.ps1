<#
.SYNOPSIS
    Removes a variable set from workspace(s)
.DESCRIPTION
    Removes a variable set assignment from one or more workspaces
.PARAMETER VariableSetId
    The variable set ID
.PARAMETER WorkspaceIds
    Array of workspace IDs to remove the variable set from
.EXAMPLE
    Remove-TfcVariableSetWorkspace -VariableSetId "varset-abc123" -WorkspaceIds @("ws-123", "ws-456")
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcVariableSetWorkspace {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,

        [Parameter(Mandatory = $true)]
        [string[]]$WorkspaceIds
    )

    if ($PSCmdlet.ShouldProcess("$($WorkspaceIds.Count) workspace(s)", "Remove variable set assignment")) {
        $workspaceData = $WorkspaceIds | ForEach-Object {
            @{
                type = "workspaces"
                id = $_
            }
        }

        $body = @{
            data = $workspaceData
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Removing variable set $VariableSetId from $($WorkspaceIds.Count) workspace(s)"
        try {
            Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/workspaces" -Method DELETE -Body $body
            return $true
        }
        catch {
            Write-Error "Failed to remove variable set from workspaces: $_"
            return $false
        }
    }
}
