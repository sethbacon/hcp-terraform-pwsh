<#
.SYNOPSIS
    List admin users
.DESCRIPTION
    Retrieves all admin users in Terraform Cloud (requires admin access)
.EXAMPLE
    Get-TfcAdminUser
#>
function Get-TfcAdminUser {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Email,
        [Parameter(Mandatory = $false)]
        [string]$Username
    )

    Initialize-TfcConnection

    $uri = "/admin/users"
    $queryParams = @()

    if ($Email) {
        $queryParams += "filter[email]=$Email"
    }

    if ($Username) {
        $queryParams += "filter[username]=$Username"
    }

    if ($queryParams.Count -gt 0) {
        $uri += "?" + ($queryParams -join "&")
    }

    Write-Verbose "Getting admin users"
    return Invoke-TfcApi -Uri $uri -Method GET
}
