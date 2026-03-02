<#
.SYNOPSIS
    Creates a new OAuth client
.DESCRIPTION
    Creates a new OAuth client for VCS integration in Terraform Cloud
.PARAMETER Organization
    The organization name to create the OAuth client in
.PARAMETER ServiceProvider
    The VCS service provider (e.g., 'github', 'gitlab', 'bitbucket', 'azure_devops')
.PARAMETER HttpUrl
    The HTTP URL of the VCS provider
.PARAMETER ApiUrl
    The API URL of the VCS provider
.PARAMETER Key
    OAuth application key/client ID
.PARAMETER Secret
    OAuth application secret
.PARAMETER Name
    Optional display name for the OAuth client
.EXAMPLE
    New-TfcOAuthClient -Organization "my-org" -ServiceProvider "github" -HttpUrl "https://github.com" -ApiUrl "https://api.github.com" -Key "clientid" -Secret "secret"
.OUTPUTS
    PSCustomObject representing the created OAuth client
#>
function New-TfcOAuthClient {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [ValidateSet('github', 'github_enterprise', 'gitlab_hosted', 'gitlab_community_edition', 'gitlab_enterprise_edition',
                     'bitbucket_hosted', 'bitbucket_server', 'azure_devops_server', 'azure_devops_services')]
        [string]$ServiceProvider,

        [Parameter(Mandatory = $true)]
        [string]$HttpUrl,

        [Parameter(Mandatory = $true)]
        [string]$ApiUrl,

        [Parameter(Mandatory = $false)]
        [string]$Key,

        [Parameter(Mandatory = $false)]
        [string]$Secret,

        [Parameter(Mandatory = $false)]
        [string]$Name
    )

    if ($PSCmdlet.ShouldProcess("Organization $Organization", "Create OAuth client for $ServiceProvider")) {
        $attributes = @{
            'service-provider' = $ServiceProvider
            'http-url' = $HttpUrl
            'api-url' = $ApiUrl
        }

        if ($Key) { $attributes['key'] = $Key }
        if ($Secret) { $attributes['secret'] = $Secret }
        if ($Name) { $attributes['name'] = $Name }

        $body = @{
            data = @{
                type = 'oauth-clients'
                attributes = $attributes
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Creating OAuth client for $ServiceProvider in organization $Organization"
        return Invoke-TfcApi -Uri "/organizations/$Organization/oauth-clients" -Method POST -Body $body
    }
}
