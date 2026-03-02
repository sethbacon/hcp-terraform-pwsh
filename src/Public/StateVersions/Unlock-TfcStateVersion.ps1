<#
.SYNOPSIS
    Unlocks a state version
.DESCRIPTION
    Unlocks a state version to allow modifications
.PARAMETER StateVersionId
    The ID of the state version to unlock
.EXAMPLE
    Unlock-TfcStateVersion -StateVersionId "sv-123"
.OUTPUTS
    PSCustomObject representing the unlocked state version
#>
function Unlock-TfcStateVersion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StateVersionId
    )

    if ($PSCmdlet.ShouldProcess("State Version $StateVersionId", "Unlock state version")) {
        $body = @{
            data = @{
                type = 'state-versions'
                id = $StateVersionId
                attributes = @{
                    locked = $false
                }
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Unlocking state version: $StateVersionId"

        return Invoke-TfcApi -Uri "/state-versions/$StateVersionId" -Method PATCH -Body $body
    }
}
