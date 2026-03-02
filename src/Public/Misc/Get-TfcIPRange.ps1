<#
.SYNOPSIS
    Get Terraform Cloud IP ranges
.DESCRIPTION
    Retrieves the IP ranges used by Terraform Cloud for network configuration
.EXAMPLE
    Get-TfcIPRange
#>
function Get-TfcIPRange {
    [CmdletBinding()]
    param()

    Initialize-TfcConnection
    Write-Verbose "Getting Terraform Cloud IP ranges"
    return Invoke-TfcApi -Uri "/meta/ip-ranges" -Method GET
}
