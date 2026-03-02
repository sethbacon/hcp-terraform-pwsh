<#
.SYNOPSIS
    Search for registry providers
.DESCRIPTION
    Searches the Terraform Registry for providers matching the query
.PARAMETER OrganizationName
    The name of the organization (for private registry search)
.PARAMETER Query
    Search query string
.PARAMETER PageSize
    Number of results per page (default: 20)
.PARAMETER PageNumber
    Page number to retrieve (default: 1)
.EXAMPLE
    Find-TfcRegistryProvider -OrganizationName "my-org" -Query "aws"
.EXAMPLE
    Find-TfcRegistryProvider -Query "custom-provider"
.OUTPUTS
    PSCustomObject representing search results
#>
function Find-TfcRegistryProvider {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OrganizationName,

        [Parameter(Mandatory = $true)]
        [string]$Query,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    try {
        Initialize-TfcConnection

        $queryString = "q=$([System.Uri]::EscapeDataString($Query))&page%5Bnumber%5D=$PageNumber&page%5Bsize%5D=$PageSize"

        if ($OrganizationName) {
            $uri = "/organizations/$OrganizationName/registry-providers/search?$queryString"
        }
        else {
            $uri = "/registry-providers/search?$queryString"
        }

        Write-Verbose "Searching for providers with query: $Query"
        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to search providers: $($_.Exception.Message)"
    }
}
