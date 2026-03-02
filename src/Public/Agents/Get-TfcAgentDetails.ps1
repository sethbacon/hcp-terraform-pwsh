<#
.SYNOPSIS
    Gets details of an agent
.DESCRIPTION
    Retrieves details of a specific agent by ID
.PARAMETER AgentId
    The agent ID
.EXAMPLE
    Get-TfcAgentDetails -AgentId "agent-abc123"
.OUTPUTS
    PSCustomObject representing the agent details
#>
function Get-TfcAgentDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentId
    )

    Write-Verbose "Getting agent details: $AgentId"
    return Invoke-TfcApi -Uri "/agents/$AgentId"
}
