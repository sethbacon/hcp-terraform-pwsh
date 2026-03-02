<#
.SYNOPSIS
    Gets run events
.DESCRIPTION
    Retrieves timeline events for a run (creation, status changes, etc.)
.PARAMETER RunId
    The ID of the run
.EXAMPLE
    Get-TfcRunEvent -RunId "run-123"
.OUTPUTS
    Array of PSCustomObjects representing run events
#>
function Get-TfcRunEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Write-Verbose "Retrieving events for run: $RunId"

    $result = Invoke-TfcApi -Uri "/runs/$RunId/run-events"

    return $result.data
}
