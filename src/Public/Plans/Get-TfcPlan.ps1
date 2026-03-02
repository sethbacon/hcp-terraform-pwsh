<#
.SYNOPSIS
    Gets plans for a run
.DESCRIPTION
    Retrieves plan information for a specific run
.PARAMETER RunId
    The run ID
.EXAMPLE
    Get-TfcPlan -RunId "run-123"
.OUTPUTS
    PSCustomObject representing the run's plan
#>
function Get-TfcPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Write-Verbose "Getting plan for run: $RunId"
    $run = Invoke-TfcApi -Uri "/runs/$RunId"

    if ($run.data.relationships.plan.data) {
        $planId = $run.data.relationships.plan.data.id
        return Invoke-TfcApi -Uri "/plans/$planId"
    }
    else {
        throw "No plan found for run $RunId"
    }
}
