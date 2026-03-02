<#
.SYNOPSIS
    Gets details of a policy set outcome
.DESCRIPTION
    Retrieves details of a specific policy set outcome
.PARAMETER PolicySetOutcomeId
    The policy set outcome ID
.EXAMPLE
    Get-TfcPolicySetOutcomeDetails -PolicySetOutcomeId "psout-abc123"
.OUTPUTS
    PSCustomObject representing the policy set outcome details
#>
function Get-TfcPolicySetOutcomeDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetOutcomeId
    )

    Write-Verbose "Getting policy set outcome details: $PolicySetOutcomeId"
    return Invoke-TfcApi -Uri "/policy-set-outcomes/$PolicySetOutcomeId"
}
