<#
.SYNOPSIS
    Updates a workspace run task
.DESCRIPTION
    Updates the enforcement level or stage of a workspace run task
.PARAMETER WorkspaceTaskId
    The workspace task ID
.PARAMETER EnforcementLevel
    New enforcement level: 'advisory' or 'mandatory'
.PARAMETER Stage
    New stage: 'pre_plan', 'post_plan', 'pre_apply', or 'post_apply'
.EXAMPLE
    Update-TfcWorkspaceRunTask -WorkspaceTaskId "wstask-abc123" -EnforcementLevel "advisory"
.OUTPUTS
    PSCustomObject representing the updated workspace task
#>
function Update-TfcWorkspaceRunTask {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceTaskId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('advisory', 'mandatory')]
        [string]$EnforcementLevel,

        [Parameter(Mandatory = $false)]
        [ValidateSet('pre_plan', 'post_plan', 'pre_apply', 'post_apply')]
        [string]$Stage
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('EnforcementLevel')) {
        $attributes['enforcement-level'] = $EnforcementLevel
    }

    if ($PSBoundParameters.ContainsKey('Stage')) {
        $attributes['stage'] = $Stage
    }

    if ($attributes.Count -eq 0) {
        throw "At least one attribute must be specified for update"
    }

    $body = @{
        data = @{
            type = "workspace-tasks"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Workspace Task: $WorkspaceTaskId", "Update workspace run task")) {
        Write-Verbose "Updating workspace task: $WorkspaceTaskId"
        return Invoke-TfcApi -Uri "/workspace-tasks/$WorkspaceTaskId" -Method PATCH -Body $body
    }
}
