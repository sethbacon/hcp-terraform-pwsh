<#
.SYNOPSIS
    Discards a run
.DESCRIPTION
    Discards a run that is awaiting confirmation
.PARAMETER RunId
    The run ID to discard
.PARAMETER Comment
    Optional comment for the discard action
.EXAMPLE
    Deny-TfcRun -RunId "run-123" -Comment "Changes not approved"
.OUTPUTS
    None
#>
function Deny-TfcRun {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,

        [Parameter(Mandatory = $false)]
        [string]$Comment
    )

    if ($PSCmdlet.ShouldProcess("Run $RunId", "Discard")) {
        $body = @{}
        if ($Comment) {
            $body['comment'] = $Comment
        }

        $jsonBody = $body | ConvertTo-Json
        Write-Verbose "Discarding run: $RunId"
        Invoke-TfcApi -Uri "/runs/$RunId/actions/discard" -Method POST -Body $jsonBody
        Write-Output "Run $RunId has been discarded"
    }
}
