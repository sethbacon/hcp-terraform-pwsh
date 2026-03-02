<#
.SYNOPSIS
    Sends an organization membership invitation
.DESCRIPTION
    Invites a user to join an organization via email
.PARAMETER Organization
    The name of the organization
.PARAMETER Email
    The email address of the user to invite
.PARAMETER TeamIds
    Optional array of team IDs to add the user to
.EXAMPLE
    Invoke-TfcOrganizationMembershipInvite -Organization "my-org" -Email "user@example.com"
.EXAMPLE
    Invoke-TfcOrganizationMembershipInvite -Organization "my-org" -Email "user@example.com" -TeamIds @("team-123", "team-456")
.OUTPUTS
    PSCustomObject representing the created invitation
#>
function Invoke-TfcOrganizationMembershipInvite {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[^@]+@[^@]+\.[^@]+$')]
        [string]$Email,

        [Parameter(Mandatory = $false)]
        [string[]]$TeamIds
    )

    if ($PSCmdlet.ShouldProcess("User $Email", "Send organization invitation")) {
        $body = @{
            data = @{
                type = 'organization-memberships'
                attributes = @{
                    email = $Email
                }
            }
        }

        if ($TeamIds -and $TeamIds.Count -gt 0) {
            $body.data.relationships = @{
                teams = @{
                    data = @($TeamIds | ForEach-Object {
                        @{
                            type = 'teams'
                            id = $_
                        }
                    })
                }
            }
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10

        Write-Verbose "Sending invitation to $Email for organization: $Organization"

        return Invoke-TfcApi -Uri "/organizations/$Organization/organization-memberships" -Method POST -Body $bodyJson
    }
}
