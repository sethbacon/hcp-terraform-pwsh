<#
.SYNOPSIS
    Gets comments on a run
.DESCRIPTION
    Retrieves comments added to a Terraform run for collaboration
.PARAMETER RunId
    The run ID
.PARAMETER CommentId
    Optional specific comment ID
.EXAMPLE
    Get-TfcComment -RunId "run-123"
.OUTPUTS
    PSCustomObject representing comments
#>
function Get-TfcComment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$RunId,
        [Parameter(Mandatory = $false)]
        [string]$CommentId
    )

    Initialize-TfcConnection

    if ($CommentId) {
        Write-Verbose "Getting comment: $CommentId"
        return Invoke-TfcApi -Uri "/comments/$CommentId"
    }

    if ($RunId) {
        Write-Verbose "Getting comments for run: $RunId"
        return Invoke-TfcApi -Uri "/runs/$RunId/comments"
    }

    throw "Either RunId or CommentId must be specified"
}
