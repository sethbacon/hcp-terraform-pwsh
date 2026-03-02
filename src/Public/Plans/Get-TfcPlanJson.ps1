<#
.SYNOPSIS
    Gets plan JSON output
.DESCRIPTION
    Retrieves the JSON representation of a plan for programmatic analysis
.PARAMETER PlanId
    The plan ID
.EXAMPLE
    Get-TfcPlanJson -PlanId "plan-abc123"
.OUTPUTS
    PSCustomObject representing the plan JSON
#>
function Get-TfcPlanJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PlanId
    )

    Write-Verbose "Getting JSON output for plan: $PlanId"
    return Invoke-TfcApi -Uri "/plans/$PlanId/json-output"
}
