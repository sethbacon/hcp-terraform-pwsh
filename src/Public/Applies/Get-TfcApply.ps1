<#
.SYNOPSIS
    Gets applies for a run
.DESCRIPTION
    Retrieves apply information for a specific run
.PARAMETER RunId
    The run ID
.EXAMPLE
    Get-TfcApply -RunId "run-123"
.OUTPUTS
    PSCustomObject representing the run's apply
#>
function Get-TfcApply {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Write-Verbose "Getting apply for run: $RunId"
    $run = Invoke-TfcApi -Uri "/runs/$RunId"

    if ($run.data.relationships.apply.data) {
        $applyId = $run.data.relationships.apply.data.id
        return Invoke-TfcApi -Uri "/applies/$applyId"
    }
    else {
        throw "No apply found for run $RunId"
    }
}
