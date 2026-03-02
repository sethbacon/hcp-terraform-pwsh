<#
.SYNOPSIS
    Lists policy set outcomes for a policy evaluation
.DESCRIPTION
    Retrieves policy set outcomes for a specific policy evaluation
.PARAMETER PolicyEvaluationId
    The policy evaluation ID
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcPolicySetOutcome -PolicyEvaluationId "poleval-abc123"
.OUTPUTS
    PSCustomObject representing policy set outcomes
#>
function Get-TfcPolicySetOutcome {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyEvaluationId,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    $uri = "/policy-evaluations/$PolicyEvaluationId/policy-set-outcomes?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting policy set outcomes for evaluation: $PolicyEvaluationId"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
