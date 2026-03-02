<#
.SYNOPSIS
    Gets variable sets for a project
.DESCRIPTION
    Retrieves variable sets assigned to a specific project
.PARAMETER ProjectId
    The project ID
.PARAMETER AllPages
    Switch to retrieve all pages of results
.PARAMETER PageSize
    Number of items per page (1-100, default 20)
.PARAMETER PageNumber
    Page number to retrieve (default 1)
.EXAMPLE
    Get-TfcProjectVariableSet -ProjectId "prj-abc123"
.EXAMPLE
    Get-TfcProjectVariableSet -ProjectId "prj-abc123" -AllPages
.OUTPUTS
    PSCustomObject representing the project's variable sets
#>
function Get-TfcProjectVariableSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$PageSize = 20,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1
    )

    $uri = "/projects/$ProjectId/varsets?page%5Bsize%5D=$PageSize&page%5Bnumber%5D=$PageNumber"
    Write-Verbose "Getting variable sets for project: $ProjectId"
    return Invoke-TfcApi -Uri $uri -AllPages:$AllPages
}
