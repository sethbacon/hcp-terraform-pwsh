<#
.SYNOPSIS
    Cancels a run with a comment
.DESCRIPTION
    Cancels a run and optionally provides a comment explaining why
.PARAMETER RunId
    The ID of the run to cancel
.PARAMETER Comment
    Optional comment explaining the cancellation reason
.EXAMPLE
    Stop-TfcRunWithComment -RunId "run-123" -Comment "Cancelling due to incorrect configuration"
.EXAMPLE
    Stop-TfcRunWithComment -RunId "run-123"
.OUTPUTS
    PSCustomObject representing the cancelled run
#>
function Stop-TfcRunWithComment {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,

        [Parameter(Mandatory = $false)]
        [string]$Comment
    )

    if ($PSCmdlet.ShouldProcess("Run $RunId", "Cancel run")) {
        $body = @{
            comment = $Comment
        } | ConvertTo-Json

        Write-Verbose "Cancelling run: $RunId"
        if ($Comment) {
            Write-Verbose "Cancellation comment: $Comment"
        }

        return Invoke-TfcApi -Uri "/runs/$RunId/actions/cancel" -Method POST -Body $body
    }
}
