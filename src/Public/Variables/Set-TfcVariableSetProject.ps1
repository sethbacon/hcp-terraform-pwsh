<#
.SYNOPSIS
    Assigns a variable set to project(s)
.DESCRIPTION
    Adds a variable set to one or more projects
.PARAMETER VariableSetId
    The variable set ID
.PARAMETER ProjectIds
    Array of project IDs to assign the variable set to
.EXAMPLE
    Set-TfcVariableSetProject -VariableSetId "varset-abc123" -ProjectIds @("prj-123", "prj-456")
.OUTPUTS
    Boolean indicating success
#>
function Set-TfcVariableSetProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,

        [Parameter(Mandatory = $true)]
        [string[]]$ProjectIds
    )

    $projectData = $ProjectIds | ForEach-Object {
        @{
            type = "projects"
            id   = $_
        }
    }

    $body = @{
        data = $projectData
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Assigning variable set $VariableSetId to $($ProjectIds.Count) project(s)"
    try {
        Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/projects" -Method POST -Body $body
        return $true
    }
    catch {
        Write-Error "Failed to assign variable set to projects: $_"
        return $false
    }
}
