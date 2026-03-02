<#
.SYNOPSIS
    Creates a new project
.DESCRIPTION
    Creates a new project in a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The project name
.PARAMETER Description
    Optional description for the project
.EXAMPLE
    New-TfcProject -Organization "my-org" -Name "production" -Description "Production workspaces"
.OUTPUTS
    PSCustomObject representing the created project
#>
function New-TfcProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    $attributes = @{
        name = $Name
    }

    if ($Description) {
        $attributes['description'] = $Description
    }

    $body = @{
        data = @{
            type = "projects"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating project '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create project: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/projects" -Method POST -Body $body
    }
}
