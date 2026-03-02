<#
.SYNOPSIS
    Lists comments on a change request
.DESCRIPTION
    Retrieves comments for a specific change request
.PARAMETER ChangeRequestId
    The change request ID
.EXAMPLE
    Get-TfcChangeRequestComment -ChangeRequestId "cr-abc123"
.OUTPUTS
    PSCustomObject representing change request comments
#>
function Get-TfcChangeRequestComment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ChangeRequestId
    )

    Write-Verbose "Getting comments for change request: $ChangeRequestId"
    return Invoke-TfcApi -Uri "/change-requests/$ChangeRequestId/comments"
}
