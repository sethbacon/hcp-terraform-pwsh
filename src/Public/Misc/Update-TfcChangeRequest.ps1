<#
.SYNOPSIS
    Updates a change request
.DESCRIPTION
    Updates a specific change request
.PARAMETER ChangeRequestId
    The change request ID
.PARAMETER Status
    The new status for the change request
.PARAMETER Message
    An optional message for the change request update
.EXAMPLE
    Update-TfcChangeRequest -ChangeRequestId "cr-abc123" -Status "approved"
.OUTPUTS
    PSCustomObject representing the updated change request
#>
function Update-TfcChangeRequest {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ChangeRequestId,

        [Parameter(Mandatory = $false)]
        [string]$Status,

        [Parameter(Mandatory = $false)]
        [string]$Message
    )

    $attributes = @{}
    if ($PSBoundParameters.ContainsKey('Status')) { $attributes['status'] = $Status }
    if ($PSBoundParameters.ContainsKey('Message')) { $attributes['message'] = $Message }

    $body = @{
        data = @{
            type       = "change-requests"
            id         = $ChangeRequestId
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Updating change request: $ChangeRequestId"
    if ($PSCmdlet.ShouldProcess("Change request '$ChangeRequestId'", "Update change request")) {
        return Invoke-TfcApi -Uri "/change-requests/$ChangeRequestId" -Method PATCH -Body $body
    }
}
