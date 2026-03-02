<#
.SYNOPSIS
    Deletes a reserved tag key
.DESCRIPTION
    Removes a specific reserved tag key
.PARAMETER ReservedTagId
    The reserved tag ID to delete
.EXAMPLE
    Remove-TfcReservedTagKey -ReservedTagId "rtag-abc123"
.OUTPUTS
    None
#>
function Remove-TfcReservedTagKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ReservedTagId
    )

    if ($PSCmdlet.ShouldProcess("Reserved tag $ReservedTagId", "Delete")) {
        Write-Verbose "Deleting reserved tag key: $ReservedTagId"
        return Invoke-TfcApi -Uri "/reserved-tags/$ReservedTagId" -Method DELETE
    }
}
