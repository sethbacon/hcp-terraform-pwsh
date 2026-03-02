<#
.SYNOPSIS
    Cancels a run
.DESCRIPTION
    Cancels a run that is in progress
.PARAMETER RunId
    The run ID to cancel
.PARAMETER Comment
    Optional comment for the cancel action
.EXAMPLE
    Stop-TfcRun -RunId "run-123" -Comment "Cancelling due to emergency"
.OUTPUTS
    None
#>
function Stop-TfcRun {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,

        [Parameter(Mandatory = $false)]
        [string]$Comment
    )

    if ($PSCmdlet.ShouldProcess("Run $RunId", "Cancel")) {
        $body = @{}
        if ($Comment) {
            $body['comment'] = $Comment
        }

        $jsonBody = $body | ConvertTo-Json
        Write-Verbose "Cancelling run: $RunId"
        Invoke-TfcApi -Uri "/runs/$RunId/actions/cancel" -Method POST -Body $jsonBody
        Write-Output "Run $RunId has been cancelled"
    }
}
