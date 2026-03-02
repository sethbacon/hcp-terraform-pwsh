<#
.SYNOPSIS
    Gets registry providers
.DESCRIPTION
    Retrieves registry providers from a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    Optional provider name to get a specific provider
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcRegistryProvider -Organization "my-org"
.EXAMPLE
    Get-TfcRegistryProvider -Organization "my-org" -Name "aws"
.OUTPUTS
    PSCustomObject representing registry providers
#>
function Get-TfcRegistryProvider {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    if ($Name) {
        Write-Verbose "Getting registry provider '$Name' from organization: $Organization"
        return Invoke-TfcApi -Uri "/organizations/$Organization/registry-providers/private/$Organization/$Name"
    }
    else {
        $uri = "/organizations/$Organization/registry-providers?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
        Write-Verbose "Getting registry providers for organization: $Organization"
        return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
    }
}
