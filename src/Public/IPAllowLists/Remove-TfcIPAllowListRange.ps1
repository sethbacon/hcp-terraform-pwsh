<#
.SYNOPSIS
    Deletes a CIDR range
.DESCRIPTION
    Removes a CIDR range from its IP allowlist
.PARAMETER CidrRangeId
    The CIDR range ID
.EXAMPLE
    Remove-TfcIPAllowListRange -CidrRangeId "cidr-abc123"
.OUTPUTS
    None
#>
function Remove-TfcIPAllowListRange {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CidrRangeId
    )

    Write-Verbose "Removing CIDR range: $CidrRangeId"
    if ($PSCmdlet.ShouldProcess("CIDR Range: $CidrRangeId", "Delete CIDR range")) {
        Invoke-TfcApi -Uri "/cidr-ranges/$CidrRangeId" -Method DELETE | Out-Null
        Write-Output "CIDR range '$CidrRangeId' deleted"
    }
}
