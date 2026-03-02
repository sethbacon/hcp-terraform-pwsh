<#
.SYNOPSIS
    Gets policy evaluation information
.DESCRIPTION
    Retrieves policy evaluation details for a run in Terraform Cloud
.PARAMETER RunId
    The ID of the run to get policy evaluations for
.PARAMETER PolicyEvaluationId
    Optional specific policy evaluation ID to retrieve
.EXAMPLE
    Get-TfcPolicyEvaluation -RunId "run-123"
.EXAMPLE
    Get-TfcPolicyEvaluation -RunId "run-123" -PolicyEvaluationId "poleval-456"
.OUTPUTS
    PSCustomObject representing policy evaluations
#>
function Get-TfcPolicyEvaluation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,

        [Parameter(Mandatory = $false)]
        [string]$PolicyEvaluationId
    )

    if ($PolicyEvaluationId) {
        Write-Verbose "Getting policy evaluation: $PolicyEvaluationId"
        return Invoke-TfcApi -Uri "/policy-evaluations/$PolicyEvaluationId"
    }
    else {
        Write-Verbose "Getting policy evaluations for run: $RunId"
        return Invoke-TfcApi -Uri "/runs/$RunId/policy-evaluations"
    }
}
