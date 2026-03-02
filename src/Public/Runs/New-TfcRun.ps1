<#
.SYNOPSIS
    Creates a new run
.DESCRIPTION
    Creates a new run in a Terraform Cloud workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER Message
    Optional message for the run
.PARAMETER IsDestroy
    Whether this is a destroy run
.PARAMETER AutoApply
    Whether to auto-apply this run
.PARAMETER ConfigurationVersionId
    Optional configuration version ID
.EXAMPLE
    New-TfcRun -WorkspaceId "ws-123" -Message "Deploy new infrastructure"
.EXAMPLE
    New-TfcRun -WorkspaceId "ws-123" -IsDestroy -Message "Destroy test environment"
.OUTPUTS
    PSCustomObject representing the created run
#>
function New-TfcRun {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [switch]$IsDestroy,

        [Parameter(Mandatory = $false)]
        [switch]$AutoApply,

        [Parameter(Mandatory = $false)]
        [string]$ConfigurationVersionId,

        [Parameter(Mandatory = $false)]
        [string[]]$TargetAddrs
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $attributes = @{
        'is-destroy' = $IsDestroy.IsPresent
        'auto-apply' = $AutoApply.IsPresent
    }

    if ($Message) {
        $attributes['message'] = $Message
    }

    if ($TargetAddrs) {
        $attributes['target-addrs'] = $TargetAddrs
    }

    $relationships = @{
        workspace = @{
            data = @{
                type = "workspaces"
                id = $WorkspaceId
            }
        }
    }

    if ($ConfigurationVersionId) {
        $relationships['configuration-version'] = @{
            data = @{
                type = "configuration-versions"
                id = $ConfigurationVersionId
            }
        }
    }

    $body = @{
        data = @{
            type = "runs"
            attributes = $attributes
            relationships = $relationships
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating run for workspace: $WorkspaceId"
    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Create run")) {
        return Invoke-TfcApi -Uri "/runs" -Method POST -Body $body
    }
}
