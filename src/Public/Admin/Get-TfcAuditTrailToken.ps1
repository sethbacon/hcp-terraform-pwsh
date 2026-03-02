<#
.SYNOPSIS
    Gets audit trail tokens
.DESCRIPTION
    Retrieves all audit trail tokens for an organization (admin only)
.PARAMETER Organization
    The name of the organization
.EXAMPLE
    Get-TfcAuditTrailToken -Organization "my-org"
.OUTPUTS
    Array of PSCustomObjects representing audit trail tokens
#>
function Get-TfcAuditTrailToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Retrieving audit trail tokens for organization: $Organization"

    $result = Invoke-TfcApi -Uri "/organizations/$Organization/audit-trail-tokens"

    return $result.data
}
