<#
.SYNOPSIS
    Updates a project
.DESCRIPTION
    Updates an existing project in Terraform Cloud, including project-level
    defaults that inherit to workspaces.
.PARAMETER ProjectId
    The project ID
.PARAMETER Name
    New name for the project
.PARAMETER Description
    New description for the project
.PARAMETER DefaultExecutionMode
    Updated default execution mode: 'remote', 'local', or 'agent'
.PARAMETER DefaultAgentPoolId
    Updated default agent pool ID (pass empty string to clear)
.PARAMETER AutoDestroyActivityDuration
    Updated auto-destroy inactivity duration (e.g., "14d")
.EXAMPLE
    Update-TfcProject -ProjectId "prj-123" -Name "new-name"
.EXAMPLE
    Update-TfcProject -ProjectId "prj-123" -DefaultExecutionMode "agent" -DefaultAgentPoolId "apool-abc123"
.OUTPUTS
    PSCustomObject representing the updated project
#>
function Update-TfcProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [ValidateSet('remote', 'local', 'agent')]
        [string]$DefaultExecutionMode,

        [Parameter(Mandatory = $false)]
        [string]$DefaultAgentPoolId,

        [Parameter(Mandatory = $false)]
        [string]$AutoDestroyActivityDuration
    )

    $attributes = @{}
    if ($PSBoundParameters.ContainsKey('Name')) { $attributes['name'] = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $attributes['description'] = $Description }
    if ($PSBoundParameters.ContainsKey('DefaultExecutionMode')) { $attributes['default-execution-mode'] = $DefaultExecutionMode }
    if ($PSBoundParameters.ContainsKey('AutoDestroyActivityDuration')) { $attributes['auto-destroy-activity-duration'] = $AutoDestroyActivityDuration }

    $relationships = @{}
    if ($PSBoundParameters.ContainsKey('DefaultAgentPoolId')) {
        if ([string]::IsNullOrEmpty($DefaultAgentPoolId)) {
            $relationships['default-agent-pool'] = @{ data = $null }
        } else {
            $relationships['default-agent-pool'] = @{
                data = @{ type = 'agent-pools'; id = $DefaultAgentPoolId }
            }
        }
    }

    if ($attributes.Count -eq 0 -and $relationships.Count -eq 0) {
        throw "At least one attribute must be provided for update"
    }

    $data = @{ type = "projects" }
    if ($attributes.Count -gt 0) { $data['attributes'] = $attributes }
    if ($relationships.Count -gt 0) { $data['relationships'] = $relationships }

    $body = @{ data = $data } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating project: $ProjectId"
    if ($PSCmdlet.ShouldProcess("Project: $ProjectId", "Update project")) {
        return Invoke-TfcApi -Uri "/projects/$ProjectId" -Method PATCH -Body $body
    }
}
