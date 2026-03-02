<#
.SYNOPSIS
    Creates a new state version
.DESCRIPTION
    Creates a new state version in a Terraform Cloud workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER StateData
    The state JSON data as a string
.PARAMETER MD5
    MD5 hash of the state data
.PARAMETER Serial
    The serial number for the state
.PARAMETER Lineage
    The lineage for the state
.PARAMETER Force
    Force push even if serial/lineage don't match
.EXAMPLE
    $stateJson = Get-Content ./terraform.tfstate -Raw
    New-TfcStateVersion -WorkspaceId "ws-123" -StateData $stateJson -MD5 "abc123..." -Serial 1
.OUTPUTS
    PSCustomObject representing the created state version
#>
function New-TfcStateVersion {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$StateData,

        [Parameter(Mandatory = $true)]
        [string]$MD5,

        [Parameter(Mandatory = $false)]
        [int]$Serial,

        [Parameter(Mandatory = $false)]
        [string]$Lineage,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    # Encode state data to base64
    $stateBytes = [System.Text.Encoding]::UTF8.GetBytes($StateData)
    $stateBase64 = [Convert]::ToBase64String($stateBytes)

    $attributes = @{
        state = $stateBase64
        md5 = $MD5
        force = $Force.IsPresent
    }

    if ($PSBoundParameters.ContainsKey('Serial')) {
        $attributes['serial'] = $Serial
    }

    if ($Lineage) {
        $attributes['lineage'] = $Lineage
    }

    $body = @{
        data = @{
            type = "state-versions"
            attributes = $attributes
            relationships = @{
                workspace = @{
                    data = @{
                        type = "workspaces"
                        id = $WorkspaceId
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating state version for workspace: $WorkspaceId"
    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Create state version")) {
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/state-versions" -Method POST -Body $body
    }
}
