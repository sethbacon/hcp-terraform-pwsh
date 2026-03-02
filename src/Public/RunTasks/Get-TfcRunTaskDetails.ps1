<#
.SYNOPSIS
    Gets details of a run task
.DESCRIPTION
    Retrieves details of a specific run task by ID
.PARAMETER TaskId
    The run task ID
.EXAMPLE
    Get-TfcRunTaskDetails -TaskId "task-abc123"
.OUTPUTS
    PSCustomObject representing the run task details
#>
function Get-TfcRunTaskDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TaskId
    )

    Write-Verbose "Getting run task details: $TaskId"
    return Invoke-TfcApi -Uri "/tasks/$TaskId"
}
