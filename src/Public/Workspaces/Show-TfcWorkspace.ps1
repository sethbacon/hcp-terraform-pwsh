<#
.SYNOPSIS
    Shows detailed workspace information with relationships
.DESCRIPTION
    Retrieves detailed information about a workspace including optional relationships
.PARAMETER Organization
    The name of the organization
.PARAMETER WorkspaceName
    The name of the workspace
.PARAMETER Include
    Optional array of relationships to include (current-run, outputs, remote-state-consumers, etc.)
.EXAMPLE
    Show-TfcWorkspace -Organization "my-org" -WorkspaceName "my-workspace"
.EXAMPLE
    Show-TfcWorkspace -Organization "my-org" -WorkspaceName "my-workspace" -Include @('current-run', 'outputs')
.OUTPUTS
    PSCustomObject representing the workspace with included relationships
#>
function Show-TfcWorkspace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('organization', 'current-run', 'latest-run', 'outputs', 'remote-state-consumers', 'current-state-version', 'current-configuration-version', 'agent-pool', 'readme')]
        [string[]]$Include
    )

    $uri = "/organizations/$Organization/workspaces/$WorkspaceName"

    if ($Include) {
        $includeParam = $Include -join ','
        $uri += "?include=$includeParam"
        Write-Verbose "Retrieving workspace $WorkspaceName with relationships: $includeParam"
    } else {
        Write-Verbose "Retrieving workspace: $WorkspaceName"
    }

    return Invoke-TfcApi -Uri $uri
}
