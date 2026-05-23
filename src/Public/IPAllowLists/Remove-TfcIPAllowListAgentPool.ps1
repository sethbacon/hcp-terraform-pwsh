<#
.SYNOPSIS
    Removes agent pool associations from an IP allowlist
.DESCRIPTION
    Detaches one or more agent pools from an IP allowlist
.PARAMETER IPAllowListId
    The IP allowlist (CIDR range list) ID
.PARAMETER AgentPoolId
    Array of agent pool IDs to detach
.EXAMPLE
    Remove-TfcIPAllowListAgentPool -IPAllowListId "ial-abc123" -AgentPoolId @("apool-xyz789")
.OUTPUTS
    None
#>
function Remove-TfcIPAllowListAgentPool {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

    Write-Verbose "Removing $($AgentPoolId.Count) agent pool association(s) from IP allowlist: $IPAllowListId"
    if ($PSCmdlet.ShouldProcess("IP Allowlist: $IPAllowListId", "Remove agent pools")) {
        Invoke-TfcApi -Uri "/cidr-range-lists/$IPAllowListId/relationships/agent-pools" -Method DELETE -Body $body | Out-Null
        Write-Output "Removed $($AgentPoolId.Count) agent pool(s) from allowlist '$IPAllowListId'"
    }
}
