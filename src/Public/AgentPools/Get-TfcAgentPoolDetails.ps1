<#
.SYNOPSIS
    Gets details of an agent pool
.DESCRIPTION
    Retrieves details of a specific agent pool by ID
.PARAMETER AgentPoolId
    The agent pool ID
.EXAMPLE
    Get-TfcAgentPoolDetails -AgentPoolId "apool-abc123"
.OUTPUTS
    PSCustomObject representing the agent pool details
#>
function Get-TfcAgentPoolDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentPoolId
    )

    Write-Verbose "Getting agent pool details: $AgentPoolId"
    return Invoke-TfcApi -Uri "/agent-pools/$AgentPoolId"
}
