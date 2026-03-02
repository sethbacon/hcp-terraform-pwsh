<#
.SYNOPSIS
    Creates a new team
.DESCRIPTION
    Creates a new team in a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The team name
.PARAMETER Visibility
    Team visibility: 'secret' (default), 'organization'
.PARAMETER OrganizationAccess
    Hashtable of organization-level permissions (manage-workspaces, manage-policies, etc.)
.EXAMPLE
    New-TfcTeam -Organization "my-org" -Name "developers"
.EXAMPLE
    New-TfcTeam -Organization "my-org" -Name "admins" -OrganizationAccess @{ "manage-workspaces" = $true }
.OUTPUTS
    PSCustomObject representing the created team
#>
function New-TfcTeam {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter()]
        [ValidateSet('secret', 'organization')]
        [string]$Visibility = 'secret',

        [Parameter()]
        [hashtable]$OrganizationAccess
    )

    $attributes = @{
        name = $Name
        visibility = $Visibility
    }

    if ($OrganizationAccess) {
        $attributes['organization-access'] = $OrganizationAccess
    }

    $body = @{
        data = @{
            type = "teams"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating team: $Name in organization: $Organization"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create team: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/teams" -Method POST -Body $body
    }
}
