<#
.SYNOPSIS
    Creates an agent token
.DESCRIPTION
    Creates a new authentication token for agents to register with a pool
.PARAMETER AgentPoolId
    The agent pool ID
.PARAMETER Description
    Description for the token
.EXAMPLE
    New-TfcAgentToken -AgentPoolId "apool-abc123" -Description "Production agent token"
.OUTPUTS
    PSCustomObject representing the created token (includes token value)
#>
function New-TfcAgentToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentPoolId,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    $body = @{
        data = @{
            type = "authentication-tokens"
            attributes = @{
                description = $Description
            }
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Agent Pool: $AgentPoolId", "Create agent token")) {
        Write-Verbose "Creating agent token for pool: $AgentPoolId"
        $result = Invoke-TfcApi -Uri "/agent-pools/$AgentPoolId/authentication-tokens" -Method POST -Body $body

        Write-Warning "Save the token value from the response - it will not be shown again!"
        return $result
    }
}
