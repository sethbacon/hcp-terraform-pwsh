<#
.SYNOPSIS
    Gets detailed policy evaluation information
.DESCRIPTION
    Retrieves detailed policy evaluation with relationships for a specific policy evaluation
.PARAMETER PolicyEvaluationId
    The ID of the policy evaluation to retrieve
.PARAMETER Include
    Optional comma-separated list of relationships to include (e.g., "policy-set,policy-set-outcomes")
.EXAMPLE
    Get-TfcPolicyEvaluationDetails -PolicyEvaluationId "poleval-123"
.EXAMPLE
    Get-TfcPolicyEvaluationDetails -PolicyEvaluationId "poleval-123" -Include "policy-set,policy-set-outcomes"
.OUTPUTS
    PSCustomObject with detailed policy evaluation information
#>
function Get-TfcPolicyEvaluationDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyEvaluationId,

        [Parameter(Mandatory = $false)]
        [string]$Include
    )

    $uri = "/policy-evaluations/$PolicyEvaluationId"

    if ($Include) {
        $uri += "?include=$Include"
    }

    Write-Verbose "Getting detailed policy evaluation: $PolicyEvaluationId"
    return Invoke-TfcApi -Uri $uri
}
