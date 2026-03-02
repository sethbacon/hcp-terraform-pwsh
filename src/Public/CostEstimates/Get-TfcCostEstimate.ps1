<#
.SYNOPSIS
    Gets cost estimate for a run
.DESCRIPTION
    Retrieves cost estimate information for a Terraform run
.PARAMETER RunId
    The run ID
.EXAMPLE
    Get-TfcCostEstimate -RunId "run-abc123"
.OUTPUTS
    PSCustomObject representing the cost estimate
#>
function Get-TfcCostEstimate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Write-Verbose "Getting cost estimate for run: $RunId"
    $run = Invoke-TfcApi -Uri "/runs/$RunId"

    if ($run.data.relationships.'cost-estimate'.data) {
        $costEstimateId = $run.data.relationships.'cost-estimate'.data.id
        return Invoke-TfcApi -Uri "/cost-estimates/$costEstimateId"
    }
    else {
        throw "No cost estimate available for run $RunId"
    }
}
