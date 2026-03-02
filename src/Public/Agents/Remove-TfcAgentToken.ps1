<#
.SYNOPSIS
    Removes an agent token
.DESCRIPTION
    Deletes an agent authentication token
.PARAMETER AgentTokenId
    The agent token ID to delete
.EXAMPLE
    Remove-TfcAgentToken -AgentTokenId "at-abc123"
.OUTPUTS
    None
#>
function Remove-TfcAgentToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentTokenId
    )

    if ($PSCmdlet.ShouldProcess("Agent Token $AgentTokenId", "Delete")) {
        Write-Verbose "Deleting agent token: $AgentTokenId"
        Invoke-TfcApi -Uri "/authentication-tokens/$AgentTokenId" -Method DELETE
        Write-Output "Agent token '$AgentTokenId' has been deleted"
    }
}
