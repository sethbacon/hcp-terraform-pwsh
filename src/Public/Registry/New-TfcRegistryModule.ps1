<#
.SYNOPSIS
    Creates a registry module from VCS
.DESCRIPTION
    Creates a new registry module in Terraform Cloud from a VCS repository
.PARAMETER Organization
    The organization name
.PARAMETER VcsRepoIdentifier
    The VCS repository identifier (e.g., "org/repo")
.PARAMETER OAuthTokenId
    The OAuth token ID for VCS authentication
.EXAMPLE
    New-TfcRegistryModule -Organization "my-org" -VcsRepoIdentifier "myorg/terraform-aws-vpc" -OAuthTokenId "ot-abc123"
.OUTPUTS
    PSCustomObject representing the created registry module
#>
function New-TfcRegistryModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$VcsRepoIdentifier,

        [Parameter(Mandatory = $true)]
        [string]$OAuthTokenId
    )

    $body = @{
        data = @{
            type = "registry-modules"
            attributes = @{
                "vcs-repo" = @{
                    identifier = $VcsRepoIdentifier
                    "oauth-token-id" = $OAuthTokenId
                    "display-identifier" = $VcsRepoIdentifier
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating registry module from VCS: $VcsRepoIdentifier"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create registry module: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/registry-modules" -Method POST -Body $body
    }
}
