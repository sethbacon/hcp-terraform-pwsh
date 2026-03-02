<#
.SYNOPSIS
    Reject a change request
.DESCRIPTION
    Rejects a change request to prevent it from proceeding
.PARAMETER ChangeRequestId
    The ID of the change request (format: chreq-xxxxx)
.PARAMETER Comment
    Optional comment for the rejection
.EXAMPLE
    Deny-TfcChangeRequest -ChangeRequestId chreq-abc123 -Comment "Does not meet security requirements"
#>
function Deny-TfcChangeRequest {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ChangeRequestId,
        [Parameter(Mandatory = $false)]
        [string]$Comment
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "change-request-rejections"
            attributes = @{}
        }
    }

    if ($Comment) {
        $body.data.attributes.comment = $Comment
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Change Request: $ChangeRequestId", "Reject")) {
        Write-Verbose "Rejecting change request: $ChangeRequestId"
        return Invoke-TfcApi -Uri "/change-requests/$ChangeRequestId/actions/reject" -Method POST -Body $bodyJson
    }
}
