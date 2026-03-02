<#
.SYNOPSIS
    Removes projects from a policy set
.DESCRIPTION
    Detaches one or more projects from a policy set
.PARAMETER PolicySetId
    The policy set ID
.PARAMETER ProjectIds
    Array of project IDs to remove
.EXAMPLE
    Remove-TfcPolicySetProject -PolicySetId "polset-abc123" -ProjectIds @("prj-abc123")
.OUTPUTS
    None
#>
function Remove-TfcPolicySetProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,

        [Parameter(Mandatory = $true)]
        [string[]]$ProjectIds
    )

    if ($PSCmdlet.ShouldProcess("Policy set $PolicySetId", "Remove projects")) {
        $body = @{
            data = @($ProjectIds | ForEach-Object {
                @{ type = "projects"; id = $_ }
            })
        } | ConvertTo-Json -Depth 5

        Write-Verbose "Removing projects from policy set: $PolicySetId"
        return Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/relationships/projects" -Method DELETE -Body $body
    }
}
