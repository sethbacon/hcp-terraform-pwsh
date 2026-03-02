<#
.SYNOPSIS
    Confirms a no-code workspace upgrade
.DESCRIPTION
    Confirms and applies an upgrade for a workspace provisioned from a no-code module
.PARAMETER NoCodeModuleId
    The ID of the no-code module (format: ncm-xxxxx)
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER UpgradeId
    The upgrade ID to confirm
.EXAMPLE
    Confirm-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId "ncm-abc123" -WorkspaceId "ws-xyz789" -UpgradeId "ncup-def456"
.OUTPUTS
    PSCustomObject representing the confirmed upgrade
#>
function Confirm-TfcNoCodeWorkspaceUpgrade {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$UpgradeId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Upgrade: $UpgradeId for Workspace: $WorkspaceId", "Confirm no-code module upgrade")) {
        Write-Verbose "Confirming upgrade $UpgradeId for workspace $WorkspaceId"
        return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId/workspaces/$WorkspaceId/upgrade/$UpgradeId/confirm" -Method POST
    }
}
