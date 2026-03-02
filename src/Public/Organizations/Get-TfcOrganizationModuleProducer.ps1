<#
.SYNOPSIS
    Gets organization module producers
.DESCRIPTION
    Lists all registry module producers configured for an organization
.PARAMETER Organization
    The name of the organization
.EXAMPLE
    Get-TfcOrganizationModuleProducer -Organization "my-org"
.OUTPUTS
    Array of PSCustomObjects representing module producers
#>
function Get-TfcOrganizationModuleProducer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Retrieving module producers for organization: $Organization"

    $result = Invoke-TfcApi -Uri "/organizations/$Organization/registry-module-producers"

    return $result.data
}
