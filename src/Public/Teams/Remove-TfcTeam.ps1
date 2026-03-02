<#
.SYNOPSIS
    Removes a team
.DESCRIPTION
    Deletes a team from Terraform Cloud
.PARAMETER TeamId
    The team ID to delete
.EXAMPLE
    Remove-TfcTeam -TeamId "team-abc123"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcTeam {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamId
    )

    if ($PSCmdlet.ShouldProcess($TeamId, "Delete team")) {
        Write-Verbose "Deleting team: $TeamId"
        try {
            Invoke-TfcApi -Uri "/teams/$TeamId" -Method DELETE | Out-Null
            return $true
        }
        catch {
            Write-Error "Failed to delete team: $_"
            return $false
        }
    }
}
