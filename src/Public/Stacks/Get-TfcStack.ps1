<#
.SYNOPSIS
    List stacks in an organization
.DESCRIPTION
    Retrieves a list of stacks for the specified organization
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER PageSize
    Number of results per page (default: 20, max: 100)
.PARAMETER PageNumber
    Page number to retrieve (default: 1)
.PARAMETER AllPages
    Retrieve all pages of results
.EXAMPLE
    Get-TfcStack -OrganizationName "my-org"
.EXAMPLE
    Get-TfcStack -OrganizationName "my-org" -AllPages
.OUTPUTS
    PSCustomObject representing stacks
#>
function Get-TfcStack {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    try {
        Initialize-TfcConnection

        $uri = "/organizations/$OrganizationName/stacks?page%5Bnumber%5D=$PageNumber&page%5Bsize%5D=$PageSize"

        Write-Verbose "Getting stacks for organization: $OrganizationName"

        if ($AllPages) {
            return Invoke-TfcApi -Uri $uri -Method GET -AllPages
        }

        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get stacks: $($_.Exception.Message)"
    }
}
