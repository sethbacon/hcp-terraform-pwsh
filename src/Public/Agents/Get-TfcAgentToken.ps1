<#
.SYNOPSIS
    Gets agent tokens for an agent pool
.DESCRIPTION
    Retrieves authentication tokens for agents
.PARAMETER AgentPoolId
    The agent pool ID
.EXAMPLE
    Get-TfcAgentToken -AgentPoolId "apool-abc123"
.OUTPUTS
    PSCustomObject representing agent tokens
#>
function Get-TfcAgentToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentPoolId
    )

    Write-Verbose "Getting agent tokens for pool: $AgentPoolId"
    return Invoke-TfcApi -Uri "/agent-pools/$AgentPoolId/authentication-tokens"
}
