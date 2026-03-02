<#
.SYNOPSIS
    Gets run tasks for an organization
.DESCRIPTION
    Retrieves run tasks configured in an organization
.PARAMETER Organization
    The organization name
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcRunTask -Organization "my-org"
.OUTPUTS
    PSCustomObject representing run tasks
#>
function Get-TfcRunTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $false)]
        [switch]$AllPages
    )

    Write-Verbose "Getting run tasks for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/tasks" -AllPages:$AllPages
}
