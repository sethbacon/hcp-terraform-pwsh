<#
.SYNOPSIS
    Updates a workspace
.DESCRIPTION
    Updates an existing workspace in Terraform Cloud
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The workspace name
.PARAMETER NewName
    New name for the workspace (optional)
.PARAMETER TerraformVersion
    The Terraform version to use
.PARAMETER WorkingDirectory
    The working directory for Terraform operations
.PARAMETER Description
    Description for the workspace
.PARAMETER AutoApply
    Whether to automatically apply successful plans
.EXAMPLE
    Update-TfcWorkspace -Organization "my-org" -Name "my-workspace" -TerraformVersion "1.5.0"
.OUTPUTS
    PSCustomObject representing the updated workspace
#>
function Update-TfcWorkspace {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$NewName,

        [Parameter(Mandatory = $false)]
        [string]$TerraformVersion,

        [Parameter(Mandatory = $false)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [bool]$AutoApply
    )

    $attributes = @{}

    if ($NewName) { $attributes['name'] = $NewName }
    if ($TerraformVersion) { $attributes['terraform-version'] = $TerraformVersion }
    if ($WorkingDirectory) { $attributes['working-directory'] = $WorkingDirectory }
    if ($Description) { $attributes['description'] = $Description }
    if ($PSBoundParameters.ContainsKey('AutoApply')) { $attributes['auto-apply'] = $AutoApply }

    $body = @{
        data = @{
            type = "workspaces"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating workspace '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Workspace: $Name", "Update workspace")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$Name" -Method PATCH -Body $body
    }
}
