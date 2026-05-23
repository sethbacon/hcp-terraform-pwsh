<#
.SYNOPSIS
    Creates a new query run
.DESCRIPTION
    Creates an asynchronous query run against a workspace to retrieve information about
    workspace resources and configurations. Queries do not change infrastructure.
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER ConfigurationVersionId
    Optional configuration version to query against (defaults to the latest)
.PARAMETER Message
    Optional message describing the query
.EXAMPLE
    New-TfcQuery -WorkspaceId "ws-abc123" -Message "Inventory query"
.OUTPUTS
    PSCustomObject representing the created query run
#>
function New-TfcQuery {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [string]$ConfigurationVersionId,

        [Parameter(Mandatory = $false)]
        [string]$Message
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $attributes = @{}
    if ($Message) { $attributes['message'] = $Message }

    $relationships = @{
        workspace = @{
            data = @{ type = 'workspaces'; id = $WorkspaceId }
        }
    }
    if ($ConfigurationVersionId) {
        $relationships['configuration-version'] = @{
            data = @{ type = 'configuration-versions'; id = $ConfigurationVersionId }
        }
    }

    $body = @{
        data = @{
            type = 'queries'
            attributes = $attributes
            relationships = $relationships
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating query for workspace: $WorkspaceId"
    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Create query")) {
        return Invoke-TfcApi -Uri "/queries" -Method POST -Body $body
    }
}
