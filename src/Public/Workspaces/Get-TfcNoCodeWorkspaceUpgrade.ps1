<#
.SYNOPSIS
    Gets the status of a no-code workspace upgrade
.DESCRIPTION
    Retrieves information about a specific no-code workspace upgrade
.PARAMETER NoCodeModuleId
    The ID of the no-code module (format: ncm-xxxxx)
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER UpgradeId
    The upgrade ID
.EXAMPLE
    Get-TfcNoCodeWorkspaceUpgrade -NoCodeModuleId "ncm-abc123" -WorkspaceId "ws-xyz789" -UpgradeId "ncup-def456"
.OUTPUTS
    PSCustomObject representing the upgrade details
#>
function Get-TfcNoCodeWorkspaceUpgrade {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$UpgradeId
    )

    Initialize-TfcConnection

    Write-Verbose "Getting upgrade $UpgradeId for workspace $WorkspaceId from no-code module: $NoCodeModuleId"
    return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId/workspaces/$WorkspaceId/upgrade/$UpgradeId" -Method GET
}
