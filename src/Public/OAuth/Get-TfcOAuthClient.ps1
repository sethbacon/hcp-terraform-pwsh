<#
.SYNOPSIS
    Gets OAuth clients for an organization
.DESCRIPTION
    Retrieves VCS providers (OAuth clients) for a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.EXAMPLE
    Get-TfcOAuthClient -Organization "my-org"
.OUTPUTS
    PSCustomObject representing the organization's OAuth clients
#>
function Get-TfcOAuthClient {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Getting OAuth clients for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/oauth-clients"
}
