<#
.SYNOPSIS
    Creates a new configuration version
.DESCRIPTION
    Creates a new configuration version for a workspace to prepare for code upload
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER Speculative
    Whether this is a speculative plan (optional, default false)
.PARAMETER Provisional
    Whether this configuration version can be used for planning (optional)
.PARAMETER AutoQueueRuns
    Whether to automatically queue a run after upload (optional, default true)
.EXAMPLE
    New-TfcConfigurationVersion -WorkspaceId "ws-abc123"
.EXAMPLE
    New-TfcConfigurationVersion -WorkspaceId "ws-abc123" -Speculative -AutoQueueRuns:$false
.OUTPUTS
    PSCustomObject representing the new configuration version with upload-url
#>
function New-TfcConfigurationVersion {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [switch]$Speculative,

        [switch]$Provisional,

        [bool]$AutoQueueRuns = $true
    )

    $attributes = @{
        "auto-queue-runs" = $AutoQueueRuns
        "speculative" = $Speculative.IsPresent
    }

    if ($PSBoundParameters.ContainsKey('Provisional')) {
        $attributes["provisional"] = $Provisional.IsPresent
    }

    $body = @{
        data = @{
            type = "configuration-versions"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating configuration version for workspace: $WorkspaceId"
    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Create configuration version")) {
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/configuration-versions" -Method POST -Body $body
    }
}
