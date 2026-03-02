<#
.SYNOPSIS
    Updates a reserved tag key
.DESCRIPTION
    Updates a specific reserved tag key
.PARAMETER ReservedTagId
    The reserved tag ID
.PARAMETER Key
    The new key name
.EXAMPLE
    Update-TfcReservedTagKey -ReservedTagId "rtag-abc123" -Key "new-key-name"
.OUTPUTS
    PSCustomObject representing the updated reserved tag
#>
function Update-TfcReservedTagKey {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ReservedTagId,

        [Parameter(Mandatory = $true)]
        [string]$Key
    )

    $body = @{
        data = @{
            type       = "reserved-tags"
            id         = $ReservedTagId
            attributes = @{
                key = $Key
            }
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Updating reserved tag key: $ReservedTagId"
    if ($PSCmdlet.ShouldProcess("Reserved tag '$ReservedTagId'", "Update reserved tag key")) {
        return Invoke-TfcApi -Uri "/reserved-tags/$ReservedTagId" -Method PATCH -Body $body
    }
}
