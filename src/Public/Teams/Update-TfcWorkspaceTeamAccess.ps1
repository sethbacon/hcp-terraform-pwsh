<#
.SYNOPSIS
    Updates team access to a workspace
.DESCRIPTION
    Updates permissions for a team's access to a workspace
.PARAMETER TeamWorkspaceId
    The team workspace relationship ID
.PARAMETER Access
    New access level
.PARAMETER Runs
    Custom permission for runs
.PARAMETER Variables
    Custom permission for variables
.PARAMETER StateVersions
    Custom permission for state
.PARAMETER SentinelMocks
    Custom permission for sentinel mocks
.PARAMETER WorkspaceLocking
    Custom permission for locking
.PARAMETER RunTasks
    Custom permission for run tasks
.EXAMPLE
    Update-TfcWorkspaceTeamAccess -TeamWorkspaceId "tws-abc123" -Access "plan"
.OUTPUTS
    PSCustomObject representing the updated team access
#>
function Update-TfcWorkspaceTeamAccess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamWorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'plan', 'write', 'admin', 'custom')]
        [string]$Access,

        [Parameter(Mandatory = $false)]
        [ValidateSet('read', 'plan', 'apply')]
        [string]$Runs,

        [Parameter(Mandatory = $false)]
        [ValidateSet('none', 'read', 'write')]
        [string]$Variables,

        [Parameter(Mandatory = $false)]
        [ValidateSet('none', 'read', 'read-outputs', 'write')]
        [string]$StateVersions,

        [Parameter(Mandatory = $false)]
        [ValidateSet('none', 'read')]
        [string]$SentinelMocks,

        [Parameter(Mandatory = $false)]
        [bool]$WorkspaceLocking,

        [Parameter(Mandatory = $false)]
        [bool]$RunTasks
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('Access')) { $attributes['access'] = $Access }
    if ($PSBoundParameters.ContainsKey('Runs')) { $attributes['runs'] = $Runs }
    if ($PSBoundParameters.ContainsKey('Variables')) { $attributes['variables'] = $Variables }
    if ($PSBoundParameters.ContainsKey('StateVersions')) { $attributes['state-versions'] = $StateVersions }
    if ($PSBoundParameters.ContainsKey('SentinelMocks')) { $attributes['sentinel-mocks'] = $SentinelMocks }
    if ($PSBoundParameters.ContainsKey('WorkspaceLocking')) { $attributes['workspace-locking'] = $WorkspaceLocking }
    if ($PSBoundParameters.ContainsKey('RunTasks')) { $attributes['run-tasks'] = $RunTasks }

    if ($attributes.Count -eq 0) {
        throw "At least one attribute must be specified for update"
    }

    $body = @{
        data = @{
            type = "team-workspaces"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Team Workspace: $TeamWorkspaceId", "Update team access")) {
        Write-Verbose "Updating team workspace access: $TeamWorkspaceId"
        return Invoke-TfcApi -Uri "/team-workspaces/$TeamWorkspaceId" -Method PATCH -Body $body
    }
}
