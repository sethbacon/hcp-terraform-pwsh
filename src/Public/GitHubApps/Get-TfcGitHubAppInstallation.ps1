<#
.SYNOPSIS
    List GitHub App installations
.DESCRIPTION
    Retrieves all GitHub App installations for an organization
.PARAMETER OrganizationName
    The name of the organization
.EXAMPLE
    Get-TfcGitHubAppInstallation -OrganizationName my-org
#>
function Get-TfcGitHubAppInstallation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName
    )

    Initialize-TfcConnection
    Write-Verbose "Getting GitHub App installations for organization: $OrganizationName"
    return Invoke-TfcApi -Uri "/organizations/$OrganizationName/github-app-installations" -Method GET
}
