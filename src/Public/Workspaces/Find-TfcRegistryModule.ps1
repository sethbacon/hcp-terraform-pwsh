<#
.SYNOPSIS
    Search for registry modules
.DESCRIPTION
    Searches the Terraform Registry for modules matching the query
.PARAMETER OrganizationName
    The name of the organization (for private registry search)
.PARAMETER Query
    Search query string
.PARAMETER Provider
    Filter by provider (e.g., "aws", "azurerm")
.PARAMETER Verified
    Filter to verified modules only
.PARAMETER PageSize
    Number of results per page (default: 20)
.PARAMETER PageNumber
    Page number to retrieve (default: 1)
.EXAMPLE
    Find-TfcRegistryModule -OrganizationName "my-org" -Query "vpc"
.EXAMPLE
    Find-TfcRegistryModule -Query "vpc" -Provider "aws" -Verified
.OUTPUTS
    PSCustomObject representing search results
#>
function Find-TfcRegistryModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OrganizationName,

        [Parameter(Mandatory = $true)]
        [string]$Query,

        [Parameter(Mandatory = $false)]
        [string]$Provider,

        [Parameter(Mandatory = $false)]
        [switch]$Verified,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    try {
        Initialize-TfcConnection

        $queryParams = @(
            "q=$([System.Uri]::EscapeDataString($Query))"
            "page%5Bnumber%5D=$PageNumber"
            "page%5Bsize%5D=$PageSize"
        )

        if ($Provider) {
            $queryParams += "filter%5Bprovider%5D=$Provider"
        }

        if ($Verified) {
            $queryParams += "filter%5Bverified%5D=true"
        }

        $queryString = $queryParams -join "&"

        if ($OrganizationName) {
            $uri = "/organizations/$OrganizationName/registry-modules/search?$queryString"
        }
        else {
            $uri = "/registry-modules/search?$queryString"
        }

        Write-Verbose "Searching for modules with query: $Query"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to search modules: $($_.Exception.Message)"
    }
}
