<#
.SYNOPSIS
    Associates agent pools with an IP allowlist
.DESCRIPTION
    Adds one or more agent pools to an IP allowlist so that the allowlist enforces access for those pools
.PARAMETER IPAllowListId
    The IP allowlist (CIDR range list) ID
.PARAMETER AgentPoolId
    Array of agent pool IDs to associate
.EXAMPLE
    Add-TfcIPAllowListAgentPool -IPAllowListId "ial-abc123" -AgentPoolId @("apool-xyz789")
.OUTPUTS
    None
#>
function Add-TfcIPAllowListAgentPool {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAllowListId,

        [Parameter(Mandatory = $true)]
        [string[]]$AgentPoolId
    )

    $data = foreach ($id in $AgentPoolId) {
        @{ type = 'agent-pools'; id = $id }
    }

    $body = @{
        data = @($data)
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Associating $($AgentPoolId.Count) agent pool(s) with IP allowlist: $IPAllowListId"
    if ($PSCmdlet.ShouldProcess("IP Allowlist: $IPAllowListId", "Add agent pools")) {
        Invoke-TfcApi -Uri "/cidr-range-lists/$IPAllowListId/relationships/agent-pools" -Method POST -Body $body | Out-Null
        Write-Output "Added $($AgentPoolId.Count) agent pool(s) to allowlist '$IPAllowListId'"
    }
}
