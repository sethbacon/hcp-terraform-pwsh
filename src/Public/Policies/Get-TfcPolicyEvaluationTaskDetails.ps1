<#
.SYNOPSIS
    Gets detailed policy evaluation task information
.DESCRIPTION
    Retrieves detailed information for a specific policy evaluation task
.PARAMETER PolicyEvaluationId
    The ID of the policy evaluation task to retrieve details for
.PARAMETER Include
    Optional comma-separated list of relationships to include
.EXAMPLE
    Get-TfcPolicyEvaluationTaskDetails -PolicyEvaluationId "poleval-123"
.OUTPUTS
    PSCustomObject with detailed policy evaluation task information
#>
function Get-TfcPolicyEvaluationTaskDetails {
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

    Write-Verbose "Getting detailed policy evaluation task: $PolicyEvaluationId"
    return Invoke-TfcApi -Uri $uri
}
