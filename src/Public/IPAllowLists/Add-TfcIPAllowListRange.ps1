<#
.SYNOPSIS
    Adds CIDR ranges to an IP allowlist
.DESCRIPTION
    Adds one or more CIDR ranges (e.g., "192.168.1.0/24") to an existing IP allowlist
.PARAMETER IPAllowListId
    The IP allowlist (CIDR range list) ID
.PARAMETER CidrRange
    Array of CIDR range strings to add (e.g., @("192.168.1.0/24", "10.0.0.0/8"))
.EXAMPLE
    Add-TfcIPAllowListRange -IPAllowListId "ial-abc123" -CidrRange @("192.168.1.0/24")
.OUTPUTS
    PSCustomObject representing the added CIDR ranges
#>
function Add-TfcIPAllowListRange {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAllowListId,

        [Parameter(Mandatory = $true)]
        [string[]]$CidrRange
    )

    $data = foreach ($range in $CidrRange) {
        @{
            type = 'cidr-ranges'
            attributes = @{ 'cidr-range' = $range }
        }
    }

    $body = @{
        data = @($data)
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Adding $($CidrRange.Count) CIDR range(s) to IP allowlist: $IPAllowListId"
    if ($PSCmdlet.ShouldProcess("IP Allowlist: $IPAllowListId", "Add CIDR ranges")) {
        return Invoke-TfcApi -Uri "/cidr-range-lists/$IPAllowListId/relationships/cidr-ranges" -Method POST -Body $body
    }
}
