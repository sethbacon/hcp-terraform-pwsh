<#
.SYNOPSIS
    Gets the current state version for a workspace
.DESCRIPTION
    Retrieves the current state version from a Terraform Cloud workspace and optionally downloads the state file
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER OutputPath
    Optional path to save the state file
.EXAMPLE
    Get-TfcCurrentStateVersion -WorkspaceId "ws-123"
.EXAMPLE
    Get-TfcCurrentStateVersion -WorkspaceId "ws-123" -OutputPath "./terraform.tfstate"
.OUTPUTS
    PSCustomObject representing the state version, and optionally saves state file to disk
#>
function Get-TfcCurrentStateVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    try {
        Write-Verbose "Fetching current state version for workspace: $WorkspaceId"
        $response = Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/current-state-version"

        if ($null -eq $response.data) {
            throw "No state version found for workspace $WorkspaceId. Make sure the workspace exists and has a current state."
        }

        if ($OutputPath) {
            $attributes = $response.data.attributes
            $downloadUrl = $attributes."hosted-state-download-url"

            if ([string]::IsNullOrEmpty($downloadUrl)) {
                throw "No download URL available for the state file."
            }

            Write-Verbose "Downloading state file to: $OutputPath"
            Initialize-TfcConnection

            $authHeaders = @{
                'Authorization' = "Bearer $($env:TFE_TOKEN)"
                'Content-Type' = 'application/json'
            }

            Invoke-WebRequest -Uri $downloadUrl -OutFile $OutputPath -Headers $authHeaders -ErrorAction Stop
            Write-Output "State file successfully downloaded to: $OutputPath"
        }

        return $response
    }
    catch {
        if ($_.Exception.Message -like "*404*") {
            Write-Error @"
Unable to fetch state version. Please verify:
1. The workspace ID is correct: $WorkspaceId
2. You have access to this workspace
3. The workspace exists and has a current state
"@
        }
        elseif ($_.Exception.Message -like "*401*") {
            Write-Error "Authentication failed. Please check your TFE_TOKEN environment variable."
        }
        elseif ($_.Exception.Message -like "*403*") {
            Write-Error "Access denied. Your API token does not have permission to access this workspace."
        }
        else {
            Write-Error $_.Exception.Message
        }
    }
}
