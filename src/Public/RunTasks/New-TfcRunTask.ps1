<#
.SYNOPSIS
    Creates a run task
.DESCRIPTION
    Creates a new run task in an organization. Optionally routes the run task
    through a self-hosted agent pool (requires HCP Terraform Premium plan and the
    private_run_tasks feature entitlement).
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The run task name
.PARAMETER Url
    The URL of the external service to call
.PARAMETER HmacKey
    Optional HMAC key for request signing
.PARAMETER Enabled
    Whether the task is enabled (default: true)
.PARAMETER Description
    Optional description
.PARAMETER AgentPoolId
    Optional agent pool ID — when set, requests for this run task are routed through
    the specified self-hosted agent pool (private run tasks)
.EXAMPLE
    New-TfcRunTask -Organization "my-org" -Name "security-scan" -Url "https://scanner.example.com/validate"
.EXAMPLE
    New-TfcRunTask -Organization "my-org" -Name "private-scan" -Url "https://internal.example.com/scan" -AgentPoolId "apool-abc123"
.OUTPUTS
    PSCustomObject representing the created run task
#>
function New-TfcRunTask {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$HmacKey,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled = $true,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string]$AgentPoolId
    )

    $attributes = @{
        name = $Name
        url = $Url
        enabled = $Enabled
    }

    if ($HmacKey) {
        $attributes['hmac-key'] = $HmacKey
    }

    if ($Description) {
        $attributes['description'] = $Description
    }

    $data = @{
        type = "tasks"
        attributes = $attributes
    }

    if ($AgentPoolId) {
        $data['relationships'] = @{
            'agent-pool' = @{
                data = @{ type = 'agent-pools'; id = $AgentPoolId }
            }
        }
    }

    $body = @{ data = $data } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating run task '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create run task: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/tasks" -Method POST -Body $body
    }
}
