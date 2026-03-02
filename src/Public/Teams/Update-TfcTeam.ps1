<#
.SYNOPSIS
    Updates an existing team
.DESCRIPTION
    Updates properties of an existing team
.PARAMETER TeamId
    The team ID
.PARAMETER Name
    New name for the team (optional)
.PARAMETER Visibility
    New visibility setting (optional): 'secret', 'organization'
.PARAMETER OrganizationAccess
    Updated organization-level permissions (optional)
.EXAMPLE
    Update-TfcTeam -TeamId "team-abc123" -Name "new-name"
.EXAMPLE
    Update-TfcTeam -TeamId "team-abc123" -OrganizationAccess @{ "manage-policies" = $true }
.OUTPUTS
    PSCustomObject representing the updated team
#>
function Update-TfcTeam {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [ValidateSet('secret', 'organization')]
        [string]$Visibility,

        [Parameter()]
        [hashtable]$OrganizationAccess
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('Name')) {
        $attributes['name'] = $Name
    }

    if ($PSBoundParameters.ContainsKey('Visibility')) {
        $attributes['visibility'] = $Visibility
    }

    if ($OrganizationAccess) {
        $attributes['organization-access'] = $OrganizationAccess
    }

    if ($attributes.Count -eq 0) {
        Write-Error "At least one attribute must be specified for update"
        return
    }

    $body = @{
        data = @{
            type = "teams"
            id = $TeamId
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating team: $TeamId"
    if ($PSCmdlet.ShouldProcess("Team: $TeamId", "Update team")) {
        return Invoke-TfcApi -Uri "/teams/$TeamId" -Method PATCH -Body $body
    }
}
