<#
.SYNOPSIS
    Deletes an IP allowlist
.DESCRIPTION
    Removes an IP allowlist and all of its CIDR range and agent pool associations
.PARAMETER IPAllowListId
    The IP allowlist ID
.EXAMPLE
    Remove-TfcIPAllowList -IPAllowListId "ial-abc123"
.OUTPUTS
    None
#>
function Remove-TfcIPAllowList {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAllowListId
    )

    Write-Verbose "Removing IP allowlist: $IPAllowListId"
    if ($PSCmdlet.ShouldProcess("IP Allowlist: $IPAllowListId", "Delete IP allowlist")) {
        Invoke-TfcApi -Uri "/cidr-range-lists/$IPAllowListId" -Method DELETE | Out-Null
        Write-Output "IP allowlist '$IPAllowListId' deleted"
    }
}
