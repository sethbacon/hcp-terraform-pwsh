<#
.SYNOPSIS
    Approve a change request
.DESCRIPTION
    Approves a change request to allow it to proceed
.PARAMETER ChangeRequestId
    The ID of the change request (format: chreq-xxxxx)
.PARAMETER Comment
    Optional comment for the approval
.EXAMPLE
    Approve-TfcChangeRequest -ChangeRequestId chreq-abc123 -Comment "Approved by team lead"
#>
function Approve-TfcChangeRequest {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ChangeRequestId,
        [Parameter(Mandatory = $false)]
        [string]$Comment
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "change-request-approvals"
            attributes = @{}
        }
    }

    if ($Comment) {
        $body.data.attributes.comment = $Comment
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Change Request: $ChangeRequestId", "Approve")) {
        Write-Verbose "Approving change request: $ChangeRequestId"
        return Invoke-TfcApi -Uri "/change-requests/$ChangeRequestId/actions/approve" -Method POST -Body $bodyJson
    }
}
