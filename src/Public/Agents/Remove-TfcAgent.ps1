<#
.SYNOPSIS
    Deletes an agent
.DESCRIPTION
    Removes a specific agent by ID
.PARAMETER AgentId
    The agent ID to delete
.EXAMPLE
    Remove-TfcAgent -AgentId "agent-abc123"
.OUTPUTS
    None
#>
function Remove-TfcAgent {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentId
    )

    if ($PSCmdlet.ShouldProcess("Agent $AgentId", "Delete")) {
        Write-Verbose "Deleting agent: $AgentId"
        return Invoke-TfcApi -Uri "/agents/$AgentId" -Method DELETE
    }
}
