<#
.SYNOPSIS
    Removes workspaces from a policy set
.DESCRIPTION
    Detaches one or more workspaces from a policy set
.PARAMETER PolicySetId
    The policy set ID
.PARAMETER WorkspaceIds
    Array of workspace IDs to remove
.EXAMPLE
    Remove-TfcPolicySetWorkspace -PolicySetId "polset-abc123" -WorkspaceIds @("ws-abc123", "ws-def456")
.OUTPUTS
    None
#>
function Remove-TfcPolicySetWorkspace {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,

        [Parameter(Mandatory = $true)]
        [string[]]$WorkspaceIds
    )

    if ($PSCmdlet.ShouldProcess("Policy set $PolicySetId", "Remove workspaces")) {
        $body = @{
            data = @($WorkspaceIds | ForEach-Object {
                @{ type = "workspaces"; id = $_ }
            })
        } | ConvertTo-Json -Depth 5

        Write-Verbose "Removing workspaces from policy set: $PolicySetId"
        return Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/relationships/workspaces" -Method DELETE -Body $body
    }
}
