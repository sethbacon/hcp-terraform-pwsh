<#
.SYNOPSIS
    Gets run task stages
.DESCRIPTION
    Retrieves the run task stages for a run (pre-plan, post-plan, pre-apply)
.PARAMETER RunId
    The ID of the run
.EXAMPLE
    Get-TfcRunTaskStage -RunId "run-123"
.OUTPUTS
    Array of PSCustomObjects representing run task stages
#>
function Get-TfcRunTaskStage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Write-Verbose "Retrieving task stages for run: $RunId"

    $result = Invoke-TfcApi -Uri "/runs/$RunId/task-stages"

    return $result.data
}
