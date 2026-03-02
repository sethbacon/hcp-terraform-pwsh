<#
.SYNOPSIS
    Gets the errored state of an apply
.DESCRIPTION
    Retrieves the errored state output for a specific apply
.PARAMETER ApplyId
    The apply ID
.EXAMPLE
    Get-TfcApplyErroredState -ApplyId "apply-abc123"
.OUTPUTS
    PSCustomObject representing the errored state
#>
function Get-TfcApplyErroredState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApplyId
    )

    Write-Verbose "Getting errored state for apply: $ApplyId"
    return Invoke-TfcApi -Uri "/applies/$ApplyId/errored-state"
}
