<#
.SYNOPSIS
    Removes an agent pool
.DESCRIPTION
    Deletes an agent pool from an organization
.PARAMETER AgentPoolId
    The agent pool ID to delete
.EXAMPLE
    Remove-TfcAgentPool -AgentPoolId "apool-abc123"
.OUTPUTS
    None
#>
function Remove-TfcAgentPool {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentPoolId
    )

    if ($PSCmdlet.ShouldProcess("Agent Pool $AgentPoolId", "Delete")) {
        Write-Verbose "Deleting agent pool: $AgentPoolId"
        Invoke-TfcApi -Uri "/agent-pools/$AgentPoolId" -Method DELETE
        Write-Output "Agent pool '$AgentPoolId' has been deleted"
    }
}
