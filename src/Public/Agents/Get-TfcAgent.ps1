<#
.SYNOPSIS
    Gets agents in an agent pool
.DESCRIPTION
    Retrieves agents registered to an agent pool
.PARAMETER AgentPoolId
    The agent pool ID
.EXAMPLE
    Get-TfcAgent -AgentPoolId "apool-abc123"
.OUTPUTS
    PSCustomObject representing agents in the pool
#>
function Get-TfcAgent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentPoolId
    )

    Write-Verbose "Getting agents for pool: $AgentPoolId"
    return Invoke-TfcApi -Uri "/agent-pools/$AgentPoolId/agents"
}
