<#
.SYNOPSIS
    Create a new change request
.DESCRIPTION
    Creates a new change request for structured approval workflows
.PARAMETER WorkspaceId
    The ID of the workspace (format: ws-xxxxx)
.PARAMETER Message
    The message describing the change request
.PARAMETER ConfigurationVersionId
    The ID of the configuration version (format: cv-xxxxx)
.EXAMPLE
    New-TfcChangeRequest -WorkspaceId ws-abc123 -Message "Update production infrastructure" -ConfigurationVersionId cv-xyz789
#>
function New-TfcChangeRequest {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [string]$ConfigurationVersionId
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "change-requests"
            attributes = @{
                message = $Message
            }
        }
    }

    if ($ConfigurationVersionId) {
        $body.data.relationships = @{
            "configuration-version" = @{
                data = @{
                    type = "configuration-versions"
                    id = $ConfigurationVersionId
                }
            }
        }
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Create change request")) {
        Write-Verbose "Creating change request for workspace: $WorkspaceId"
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/change-requests" -Method POST -Body $bodyJson
    }
}
