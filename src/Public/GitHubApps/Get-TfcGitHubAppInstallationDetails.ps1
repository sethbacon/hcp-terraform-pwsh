<#
.SYNOPSIS
    Get detailed GitHub App installation information
.DESCRIPTION
    Retrieves detailed information about a specific GitHub App installation
.PARAMETER InstallationId
    The ID of the GitHub App installation (format: ghain-xxxxx)
.EXAMPLE
    Get-TfcGitHubAppInstallationDetails -InstallationId ghain-abc123
#>
function Get-TfcGitHubAppInstallationDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$InstallationId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for GitHub App installation: $InstallationId"
    return Invoke-TfcApi -Uri "/github-app-installations/$InstallationId" -Method GET
}
