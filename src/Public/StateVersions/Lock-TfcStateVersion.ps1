<#
.SYNOPSIS
    Locks a state version
.DESCRIPTION
    Locks a state version to prevent modifications
.PARAMETER StateVersionId
    The ID of the state version to lock
.PARAMETER Reason
    Optional reason for locking the state version
.EXAMPLE
    Lock-TfcStateVersion -StateVersionId "sv-123" -Reason "Maintenance window"
.OUTPUTS
    PSCustomObject representing the locked state version
#>
function Lock-TfcStateVersion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StateVersionId,

        [Parameter(Mandatory = $false)]
        [string]$Reason
    )

    if ($PSCmdlet.ShouldProcess("State Version $StateVersionId", "Lock state version")) {
        $body = @{
            data = @{
                type = 'state-versions'
                id = $StateVersionId
                attributes = @{
                    locked = $true
                }
            }
        } | ConvertTo-Json -Depth 10

        if ($Reason) {
            Write-Verbose "Locking state version $StateVersionId (Reason: $Reason)"
        } else {
            Write-Verbose "Locking state version: $StateVersionId"
        }

        return Invoke-TfcApi -Uri "/state-versions/$StateVersionId" -Method PATCH -Body $body
    }
}
