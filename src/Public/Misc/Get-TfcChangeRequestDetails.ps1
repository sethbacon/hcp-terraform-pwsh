<#
.SYNOPSIS
    Get detailed change request information
.DESCRIPTION
    Retrieves detailed information about a specific change request
.PARAMETER ChangeRequestId
    The ID of the change request (format: chreq-xxxxx)
.EXAMPLE
    Get-TfcChangeRequestDetails -ChangeRequestId chreq-abc123
#>
function Get-TfcChangeRequestDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ChangeRequestId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for change request: $ChangeRequestId"
    return Invoke-TfcApi -Uri "/change-requests/$ChangeRequestId" -Method GET
}
