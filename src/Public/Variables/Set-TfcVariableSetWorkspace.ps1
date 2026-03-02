<#
.SYNOPSIS
    Assigns a variable set to workspace(s)
.DESCRIPTION
    Adds a variable set to one or more workspaces
.PARAMETER VariableSetId
    The variable set ID
.PARAMETER WorkspaceIds
    Array of workspace IDs to assign the variable set to
.EXAMPLE
    Set-TfcVariableSetWorkspace -VariableSetId "varset-abc123" -WorkspaceIds @("ws-123", "ws-456")
.OUTPUTS
    Boolean indicating success
#>
function Set-TfcVariableSetWorkspace {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,

        [Parameter(Mandatory = $true)]
        [string[]]$WorkspaceIds
    )

    $workspaceData = $WorkspaceIds | ForEach-Object {
        @{
            type = "workspaces"
            id = $_
        }
    }

    $body = @{
        data = $workspaceData
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Assigning variable set $VariableSetId to $($WorkspaceIds.Count) workspace(s)"
    try {
        Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/workspaces" -Method POST -Body $body
        return $true
    }
    catch {
        Write-Error "Failed to assign variable set to workspaces: $_"
        return $false
    }
}
