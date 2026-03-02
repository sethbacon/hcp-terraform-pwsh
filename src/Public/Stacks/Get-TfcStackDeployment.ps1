<#
.SYNOPSIS
    List stack deployments
.DESCRIPTION
    Retrieves deployments for a specific stack
.PARAMETER StackId
    The ID of the stack
.PARAMETER PageSize
    Number of results per page (default: 20)
.PARAMETER PageNumber
    Page number to retrieve (default: 1)
.PARAMETER AllPages
    Retrieve all pages of results
.EXAMPLE
    Get-TfcStackDeployment -StackId "stack-123"
.OUTPUTS
    PSCustomObject representing stack deployments
#>
function Get-TfcStackDeployment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    try {
        Initialize-TfcConnection

        $uri = "/stacks/$StackId/deployments?page%5Bnumber%5D=$PageNumber&page%5Bsize%5D=$PageSize"

        Write-Verbose "Getting deployments for stack: $StackId"

        if ($AllPages) {
            return Invoke-TfcApi -Uri $uri -Method GET -AllPages
        }

        return Invoke-TfcApi -Uri $uri -Method GET
    }
    catch {
        throw "Failed to get stack deployments: $($_.Exception.Message)"
    }
}
