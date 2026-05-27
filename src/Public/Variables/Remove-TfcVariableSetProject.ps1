<#
.SYNOPSIS
    Removes a variable set from project(s)
.DESCRIPTION
    Removes a variable set assignment from one or more projects
.PARAMETER VariableSetId
    The variable set ID
.PARAMETER ProjectIds
    Array of project IDs to remove the variable set from
.EXAMPLE
    Remove-TfcVariableSetProject -VariableSetId "varset-abc123" -ProjectIds @("prj-123", "prj-456")
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcVariableSetProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,

        [Parameter(Mandatory = $true)]
        [string[]]$ProjectIds
    )

    if ($PSCmdlet.ShouldProcess("$($ProjectIds.Count) project(s)", "Remove variable set assignment")) {
        $projectData = $ProjectIds | ForEach-Object {
            @{
                type = "projects"
                id   = $_
            }
        }

        $body = @{
            data = $projectData
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Removing variable set $VariableSetId from $($ProjectIds.Count) project(s)"
        try {
            Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/projects" -Method DELETE -Body $body
            return $true
        }
        catch {
            Write-Error "Failed to remove variable set from projects: $_"
            return $false
        }
    }
}
