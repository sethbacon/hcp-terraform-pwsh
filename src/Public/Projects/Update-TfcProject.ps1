<#
.SYNOPSIS
    Updates a project
.DESCRIPTION
    Updates an existing project in Terraform Cloud
.PARAMETER ProjectId
    The project ID
.PARAMETER Name
    New name for the project
.PARAMETER Description
    New description for the project
.EXAMPLE
    Update-TfcProject -ProjectId "prj-123" -Name "new-name" -Description "Updated description"
.OUTPUTS
    PSCustomObject representing the updated project
#>
function Update-TfcProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    $attributes = @{}

    if ($Name) { $attributes['name'] = $Name }
    if ($Description) { $attributes['description'] = $Description }

    if ($attributes.Count -eq 0) {
        throw "At least one attribute (Name or Description) must be provided for update"
    }

    $body = @{
        data = @{
            type = "projects"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating project: $ProjectId"
    if ($PSCmdlet.ShouldProcess("Project: $ProjectId", "Update project")) {
        return Invoke-TfcApi -Uri "/projects/$ProjectId" -Method PATCH -Body $body
    }
}
