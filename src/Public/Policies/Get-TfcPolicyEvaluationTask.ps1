<#
.SYNOPSIS
    Gets policy evaluation tasks
.DESCRIPTION
    Retrieves policy evaluation tasks (OPA/Sentinel) for a task stage
.PARAMETER TaskStageId
    The ID of the task stage to get policy tasks for
.EXAMPLE
    Get-TfcPolicyEvaluationTask -TaskStageId "ts-123"
.OUTPUTS
    PSCustomObject array of policy evaluation tasks
#>
function Get-TfcPolicyEvaluationTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TaskStageId
    )

    Write-Verbose "Getting policy evaluation tasks for task stage: $TaskStageId"
    return Invoke-TfcApi -Uri "/task-stages/$TaskStageId/policy-evaluations"
}
