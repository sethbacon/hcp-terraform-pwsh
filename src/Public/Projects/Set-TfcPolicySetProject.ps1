<#
.SYNOPSIS
    Sets project targeting for a policy set
.DESCRIPTION
    Attaches a policy set to specific projects
.PARAMETER PolicySetId
    The policy set ID
.PARAMETER ProjectIds
    Array of project IDs to target
.EXAMPLE
    Set-TfcPolicySetProject -PolicySetId "polset-123" -ProjectIds @("prj-1", "prj-2")
.OUTPUTS
    None
#>
function Set-TfcPolicySetProject {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,
        [Parameter(Mandatory = $true)]
        [string[]]$ProjectIds
    )

    Initialize-TfcConnection

    $relationships = $ProjectIds | ForEach-Object {
        @{
            type = "projects"
            id = $_
        }
    }

    $body = @{
        data = $relationships
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Policy Set '$PolicySetId'", "Set projects")) {
        Write-Verbose "Attaching policy set to $($ProjectIds.Count) projects"
        Invoke-TfcApi -Uri "/policy-sets/$PolicySetId/relationships/projects" -Method POST -Body $body | Out-Null
        return $true
    }
}
