<#
.SYNOPSIS
    Gets policy checks for a run
.DESCRIPTION
    Retrieves policy check results for a Terraform run
.PARAMETER RunId
    The run ID
.PARAMETER PolicyCheckId
    Optional specific policy check ID
.EXAMPLE
    Get-TfcPolicyCheck -RunId "run-123"
.OUTPUTS
    PSCustomObject representing policy checks
#>
function Get-TfcPolicyCheck {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$RunId,
        [Parameter(Mandatory = $false)]
        [string]$PolicyCheckId
    )

    Initialize-TfcConnection

    if ($PolicyCheckId) {
        Write-Verbose "Getting policy check: $PolicyCheckId"
        return Invoke-TfcApi -Uri "/policy-checks/$PolicyCheckId"
    }

    if ($RunId) {
        Write-Verbose "Getting policy checks for run: $RunId"
        return Invoke-TfcApi -Uri "/runs/$RunId/policy-checks"
    }

    throw "Either RunId or PolicyCheckId must be specified"
}
