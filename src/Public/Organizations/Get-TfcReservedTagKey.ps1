<#
.SYNOPSIS
    Gets reserved tag keys
.DESCRIPTION
    Lists all reserved tag keys in an organization that cannot be used for workspace tagging
.PARAMETER Organization
    The name of the organization
.EXAMPLE
    Get-TfcReservedTagKey -Organization "my-org"
.OUTPUTS
    Array of PSCustomObjects representing reserved tag keys
#>
function Get-TfcReservedTagKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Retrieving reserved tag keys for organization: $Organization"

    $result = Invoke-TfcApi -Uri "/organizations/$Organization/reserved-tag-keys"

    return $result.data
}
