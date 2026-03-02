<#
.SYNOPSIS
    Handles pagination for API responses
.DESCRIPTION
    Processes paginated API responses and returns all results
#>
function Get-AllPages {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri,
        [hashtable]$Headers,
        [System.Security.SecureString]$Token
    )

    $allResults = @()
    $currentUri = $Uri

    do {
        $response = Invoke-RestMethod -Uri $currentUri -Headers $Headers -Authentication Bearer -Token $Token
        $allResults += $response.data
        $currentUri = $response.links.next
    } while ($currentUri)

    return @{
        data = $allResults
        meta = $response.meta
    }
}
