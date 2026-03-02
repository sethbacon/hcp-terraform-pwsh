<#
.SYNOPSIS
    Gets registry modules
.DESCRIPTION
    Retrieves registry modules from a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    Optional module name to get a specific module
.PARAMETER Provider
    Optional provider name (required with Name)
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcRegistryModule -Organization "my-org"
.EXAMPLE
    Get-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
.OUTPUTS
    PSCustomObject representing registry modules
#>
function Get-TfcRegistryModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Provider,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    if ($Name -and $Provider) {
        Write-Verbose "Getting registry module '$Name' with provider '$Provider' from organization: $Organization"
        return Invoke-TfcApi -Uri "/organizations/$Organization/registry-modules/private/$Organization/$Name/$Provider"
    }
    elseif ($Name -or $Provider) {
        throw "Both Name and Provider must be specified together to get a specific module"
    }
    else {
        $uri = "/organizations/$Organization/registry-modules?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
        Write-Verbose "Getting registry modules for organization: $Organization"
        return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
    }
}
