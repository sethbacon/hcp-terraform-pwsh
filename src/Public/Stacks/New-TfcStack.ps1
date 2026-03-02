<#
.SYNOPSIS
    Create a new stack
.DESCRIPTION
    Creates a new Terraform stack for orchestrating multiple workspaces
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER Name
    The name of the stack
.PARAMETER Description
    Optional description of the stack
.PARAMETER VcsRepoIdentifier
    VCS repository identifier (e.g., "org/repo")
.PARAMETER OAuthTokenId
    OAuth token ID for VCS integration
.PARAMETER ProjectId
    Optional project ID to associate with the stack
.EXAMPLE
    New-TfcStack -OrganizationName "my-org" -Name "production-stack" -Description "Production infrastructure"
.OUTPUTS
    PSCustomObject representing the created stack
#>
function New-TfcStack {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string]$VcsRepoIdentifier,

        [Parameter(Mandatory = $false)]
        [string]$OAuthTokenId,

        [Parameter(Mandatory = $false)]
        [string]$ProjectId
    )

    try {
        Initialize-TfcConnection

        $attributes = @{
            name = $Name
        }

        if ($Description) { $attributes['description'] = $Description }

        $relationships = @{}

        if ($VcsRepoIdentifier -and $OAuthTokenId) {
            $attributes['vcs-repo'] = @{
                identifier = $VcsRepoIdentifier
                'oauth-token-id' = $OAuthTokenId
            }
        }

        if ($ProjectId) {
            $relationships['project'] = @{
                data = @{
                    type = "projects"
                    id = $ProjectId
                }
            }
        }

        $body = @{
            data = @{
                type = "stacks"
                attributes = $attributes
            }
        }

        if ($relationships.Count -gt 0) {
            $body.data['relationships'] = $relationships
        }

        $jsonBody = $body | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Organization: $OrganizationName", "Create stack: $Name")) {
            Write-Verbose "Creating stack: $Name in organization: $OrganizationName"
            return Invoke-TfcApi -Uri "/organizations/$OrganizationName/stacks" -Method POST -Body $jsonBody
        }
    }
    catch {
        throw "Failed to create stack: $($_.Exception.Message)"
    }
}
