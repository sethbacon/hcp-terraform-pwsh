<#
.SYNOPSIS
    Sets workspace targeting for a policy set
.DESCRIPTION
    Attaches a policy set to specific workspaces
.PARAMETER PolicySetId
    The policy set ID
.PARAMETER WorkspaceIds
    Array of workspace IDs to target
.EXAMPLE
    Set-TfcPolicySetWorkspace -PolicySetId "polset-123" -WorkspaceIds @("ws-1", "ws-2")
.OUTPUTS
    None
#>
function Set-TfcPolicySetWorkspace {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,
        [Parameter(Mandatory = $true)]
        [string[]]$WorkspaceIds
    )

    Initialize-TfcConnection

    $relationships = $WorkspaceIds | ForEach-Object {
        @{
            type = "workspaces"
            id = $_
        }
    }

    $body = @{
        data = $relationships
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Policy Set '$PolicySetId'", "Set workspaces")) {
        Write-Verbose "Attaching policy set to $($WorkspaceIds.Count) workspaces"
        Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/relationships/workspaces" -Method POST -Body $body | Out-Null
        return $true
    }
}
