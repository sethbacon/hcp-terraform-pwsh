<#
.SYNOPSIS
    Get detailed run task result information
.DESCRIPTION
    Retrieves detailed information about a specific run task result
.PARAMETER TaskResultId
    The ID of the task result (format: taskrs-xxxxx)
.EXAMPLE
    Get-TfcRunTaskResultDetails -TaskResultId taskrs-abc123
#>
function Get-TfcRunTaskResultDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TaskResultId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for task result: $TaskResultId"
    return Invoke-TfcApi -Uri "/task-results/$TaskResultId" -Method GET
}
