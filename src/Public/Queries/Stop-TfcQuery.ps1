<#
.SYNOPSIS
    Cancels a running query
.DESCRIPTION
    Cancels an in-progress query run
.PARAMETER QueryId
    The query run ID
.EXAMPLE
    Stop-TfcQuery -QueryId "qry-abc123"
.OUTPUTS
    None
#>
function Stop-TfcQuery {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$QueryId
    )

    Write-Verbose "Cancelling query: $QueryId"
    if ($PSCmdlet.ShouldProcess("Query: $QueryId", "Cancel query")) {
        Invoke-TfcApi -Uri "/queries/$QueryId/actions/cancel" -Method POST | Out-Null
        Write-Output "Cancel request sent for query '$QueryId'"
    }
}
