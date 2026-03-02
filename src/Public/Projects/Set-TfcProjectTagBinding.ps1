<#
.SYNOPSIS
    Sets tag bindings for a project
.DESCRIPTION
    Creates or updates tag bindings for a project. Each tag binding is a key-value pair.
.PARAMETER ProjectId
    The project ID
.PARAMETER TagBindings
    Array of hashtables with 'key' and 'value' properties representing tag bindings
.EXAMPLE
    Set-TfcProjectTagBinding -ProjectId "prj-abc123" -TagBindings @(@{key="env"; value="production"}, @{key="team"; value="platform"})
.OUTPUTS
    PSCustomObject representing the updated tag bindings
#>
function Set-TfcProjectTagBinding {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $true)]
        [hashtable[]]$TagBindings
    )

    Initialize-TfcConnection

    $tagBindingData = $TagBindings | ForEach-Object {
        @{
            type = "tag-bindings"
            attributes = @{
                key   = $_.key
                value = $_.value
            }
        }
    }

    $body = @{
        data = $tagBindingData
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Project: $ProjectId", "Set tag bindings")) {
        Write-Verbose "Setting tag bindings for project: $ProjectId"
        return Invoke-TfcApi -Uri "/projects/$ProjectId/tag-bindings" -Method PATCH -Body $body
    }
}
