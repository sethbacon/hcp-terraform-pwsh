<#
.SYNOPSIS
    Force cancels a run
.DESCRIPTION
    Forcefully cancels a run that is stuck or not responding to normal cancel
.PARAMETER RunId
    The run ID to force cancel
.PARAMETER Comment
    Optional comment explaining the force cancel
.EXAMPLE
    Stop-TfcRunForce -RunId "run-abc123" -Comment "Stuck run requiring force cancel"
.OUTPUTS
    None
#>
function Stop-TfcRunForce {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,

        [Parameter()]
        [string]$Comment
    )

    if ($PSCmdlet.ShouldProcess("Run $RunId", "Force Cancel")) {
        $body = @{}
        if ($Comment) {
            $body['comment'] = $Comment
        }

        $jsonBody = $body | ConvertTo-Json
        Write-Verbose "Force cancelling run: $RunId"
        Invoke-TfcApi -Uri "/runs/$RunId/actions/force-cancel" -Method POST -Body $jsonBody
        Write-Output "Run $RunId has been force cancelled"
    }
}
