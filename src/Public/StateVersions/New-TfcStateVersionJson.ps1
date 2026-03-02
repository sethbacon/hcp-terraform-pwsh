<#
.SYNOPSIS
    Creates a new state version with JSON content
.DESCRIPTION
    Creates a new state version by uploading JSON state content
.PARAMETER WorkspaceId
    The ID of the workspace
.PARAMETER StateJson
    The JSON state content as a string or hashtable
.PARAMETER MD5Hash
    MD5 hash of the state content (auto-calculated if not provided)
.PARAMETER Serial
    Serial number for the state version (auto-incremented if not provided)
.PARAMETER Force
    Force creation without confirmation
.EXAMPLE
    New-TfcStateVersionJson -WorkspaceId "ws-123" -StateJson $stateContent
.EXAMPLE
    $state = Get-Content terraform.tfstate -Raw | ConvertFrom-Json
    New-TfcStateVersionJson -WorkspaceId "ws-123" -StateJson $state -Force
.OUTPUTS
    PSCustomObject representing the created state version
#>
function New-TfcStateVersionJson {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [object]$StateJson,

        [Parameter(Mandatory = $false)]
        [string]$MD5Hash,

        [Parameter(Mandatory = $false)]
        [int]$Serial,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    # Convert StateJson to string if it's a hashtable/object
    if ($StateJson -is [hashtable] -or $StateJson -is [PSCustomObject]) {
        $stateString = $StateJson | ConvertTo-Json -Depth 100 -Compress
    } else {
        $stateString = $StateJson
    }

    # Calculate MD5 hash if not provided
    if (-not $MD5Hash) {
        $md5 = [System.Security.Cryptography.MD5]::Create()
        $hash = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($stateString))
        $MD5Hash = [System.BitConverter]::ToString($hash).Replace("-", "").ToLower()
    }

    # Encode state as base64
    $stateBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($stateString))

    $body = @{
        data = @{
            type = 'state-versions'
            attributes = @{
                state = $stateBase64
                md5 = $MD5Hash
            }
        }
    }

    if ($Serial) {
        $body.data.attributes.serial = $Serial
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($Force -or $PSCmdlet.ShouldProcess("Workspace $WorkspaceId", "Create new state version")) {
        Write-Verbose "Creating state version for workspace: $WorkspaceId"
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/state-versions" -Method POST -Body $bodyJson
    }
}
