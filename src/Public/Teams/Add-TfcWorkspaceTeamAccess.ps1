<#
.SYNOPSIS
    Adds team access to a workspace
.DESCRIPTION
    Grants a team access to a workspace with specified permissions
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER TeamId
    The team ID to grant access
.PARAMETER Access
    Access level: 'read', 'plan', 'write', 'admin', or 'custom'
.PARAMETER Runs
    Custom permission for runs: 'read', 'plan', or 'apply'
.PARAMETER Variables
    Custom permission for variables: 'none', 'read', or 'write'
.PARAMETER StateVersions
    Custom permission for state: 'none', 'read', 'read-outputs', or 'write'
.PARAMETER SentinelMocks
    Custom permission for sentinel mocks: 'none' or 'read'
.PARAMETER WorkspaceLocking
    Custom permission for locking: true or false
.PARAMETER RunTasks
    Custom permission for run tasks: true or false
.EXAMPLE
    Add-TfcWorkspaceTeamAccess -WorkspaceId "ws-123" -TeamId "team-abc" -Access "write"
.EXAMPLE
    Add-TfcWorkspaceTeamAccess -WorkspaceId "ws-123" -TeamId "team-abc" -Access "custom" -Runs "plan" -Variables "read" -StateVersions "read"
.OUTPUTS
    PSCustomObject representing the team access
#>
function Add-TfcWorkspaceTeamAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$TeamId,

        [Parameter(Mandatory = $true)]
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

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $attributes = @{
        access = $Access
    }

    if ($Access -eq 'custom') {
        if ($PSBoundParameters.ContainsKey('Runs')) { $attributes['runs'] = $Runs }
        if ($PSBoundParameters.ContainsKey('Variables')) { $attributes['variables'] = $Variables }
        if ($PSBoundParameters.ContainsKey('StateVersions')) { $attributes['state-versions'] = $StateVersions }
        if ($PSBoundParameters.ContainsKey('SentinelMocks')) { $attributes['sentinel-mocks'] = $SentinelMocks }
        if ($PSBoundParameters.ContainsKey('WorkspaceLocking')) { $attributes['workspace-locking'] = $WorkspaceLocking }
        if ($PSBoundParameters.ContainsKey('RunTasks')) { $attributes['run-tasks'] = $RunTasks }
    }

    $body = @{
        data = @{
            type = "team-workspaces"
            attributes = $attributes
            relationships = @{
                workspace = @{
                    data = @{
                        type = "workspaces"
                        id = $WorkspaceId
                    }
                }
                team = @{
                    data = @{
                        type = "teams"
                        id = $TeamId
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Adding team $TeamId access to workspace $WorkspaceId"
    return Invoke-TfcApi -Uri "/team-workspaces" -Method POST -Body $body
}
