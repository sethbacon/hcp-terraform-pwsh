<#
.SYNOPSIS
    Updates a CIDR range
.DESCRIPTION
    Updates the CIDR block value for an existing range
.PARAMETER CidrRangeId
    The CIDR range ID
.PARAMETER CidrRange
    The new CIDR block value (e.g., "192.168.2.0/24")
.EXAMPLE
    Update-TfcIPAllowListRange -CidrRangeId "cidr-abc123" -CidrRange "10.0.0.0/16"
.OUTPUTS
    PSCustomObject representing the updated CIDR range
#>
function Update-TfcIPAllowListRange {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CidrRangeId,

        [Parameter(Mandatory = $true)]
        [string]$CidrRange
    )

    $body = @{
        data = @{
            type = 'cidr-ranges'
            attributes = @{
                'cidr-range' = $CidrRange
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating CIDR range: $CidrRangeId"
    if ($PSCmdlet.ShouldProcess("CIDR Range: $CidrRangeId", "Update CIDR range")) {
        return Invoke-TfcApi -Uri "/cidr-ranges/$CidrRangeId" -Method PATCH -Body $body
    }
}
