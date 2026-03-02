<#
.SYNOPSIS
    Get run task results for a run
.DESCRIPTION
    Retrieves the results of run tasks that were executed for a specific run
.PARAMETER RunId
    The ID of the run (format: run-xxxxx)
.EXAMPLE
    Get-TfcRunTaskResult -RunId run-abc123
#>
function Get-TfcRunTaskResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting run task results for run: $RunId"
    return Invoke-TfcApi -Uri "/runs/$RunId/task-results" -Method GET
}
