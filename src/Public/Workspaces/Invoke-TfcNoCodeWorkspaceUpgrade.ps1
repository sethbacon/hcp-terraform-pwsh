<#
.SYNOPSIS
    Initiates an upgrade for a no-code workspace
.DESCRIPTION
    Triggers an upgrade process for a workspace provisioned from a no-code module
.PARAMETER NoCodeModuleId
    The ID of the no-code module (format: ncm-xxxxx)
.PARAMETER WorkspaceId
    The workspace ID to upgrade
.EXAMPLE
    Invoke-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId "ncm-abc123" -WorkspaceId "ws-xyz789"
.OUTPUTS
    PSCustomObject representing the upgrade details
#>
function Invoke-TfcNoCodeWorkspaceUpgrade {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Initiate no-code module upgrade")) {
        Write-Verbose "Initiating upgrade for workspace $WorkspaceId from no-code module: $NoCodeModuleId"
        return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId/workspaces/$WorkspaceId/upgrade" -Method POST
    }
}
