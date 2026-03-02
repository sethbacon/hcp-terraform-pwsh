<#
.SYNOPSIS
    Applies a run
.DESCRIPTION
    Applies a run that is awaiting confirmation
.PARAMETER RunId
    The run ID to apply
.PARAMETER Comment
    Optional comment for the apply
.EXAMPLE
    Confirm-TfcRun -RunId "run-123" -Comment "Approved by admin"
.OUTPUTS
    None
#>
function Confirm-TfcRun {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,

        [Parameter(Mandatory = $false)]
        [string]$Comment
    )

    if ($PSCmdlet.ShouldProcess("Run $RunId", "Apply")) {
        $body = @{}
        if ($Comment) {
            $body['comment'] = $Comment
        }

        $jsonBody = $body | ConvertTo-Json
        Write-Verbose "Applying run: $RunId"
        Invoke-TfcApi -Uri "/runs/$RunId/actions/apply" -Method POST -Body $jsonBody
        Write-Output "Run $RunId has been applied"
    }
}
