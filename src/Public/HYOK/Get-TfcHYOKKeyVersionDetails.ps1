<#
.SYNOPSIS
    Gets details of a HYOK key version
.DESCRIPTION
    Retrieves details of a specific HYOK customer key version
.PARAMETER KeyVersionId
    The HYOK customer key version ID
.EXAMPLE
    Get-TfcHYOKKeyVersionDetails -KeyVersionId "hyokkv-abc123"
.OUTPUTS
    PSCustomObject representing the key version details
#>
function Get-TfcHYOKKeyVersionDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$KeyVersionId
    )

    Write-Verbose "Getting HYOK key version details: $KeyVersionId"
    return Invoke-TfcApi -Uri "/hyok-customer-key-versions/$KeyVersionId"
}
