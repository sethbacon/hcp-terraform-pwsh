<#
.SYNOPSIS
    Creates a new workspace
.DESCRIPTION
    Creates a new workspace in a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The workspace name
.PARAMETER TerraformVersion
    The Terraform version to use (default: "latest")
.PARAMETER WorkingDirectory
    The working directory for Terraform operations
.PARAMETER Description
    Optional description for the workspace
.PARAMETER AutoApply
    Whether to automatically apply successful plans
.PARAMETER VcsRepo
    VCS repository configuration (hashtable with repo-identifier, branch, etc.)
.EXAMPLE
    New-TfcWorkspace -Organization "my-org" -Name "new-workspace"
.EXAMPLE
    New-TfcWorkspace -Organization "my-org" -Name "new-workspace" -AutoApply -TerraformVersion "1.5.0"
.OUTPUTS
    PSCustomObject representing the created workspace
#>
function New-TfcWorkspace {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$TerraformVersion = "latest",

        [Parameter(Mandatory = $false)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [switch]$AutoApply,

        [Parameter(Mandatory = $false)]
        [hashtable]$VcsRepo
    )

    $attributes = @{
        name = $Name
        'terraform-version' = $TerraformVersion
        'auto-apply' = $AutoApply.IsPresent
    }

    if ($WorkingDirectory) {
        $attributes['working-directory'] = $WorkingDirectory
    }

    if ($Description) {
        $attributes['description'] = $Description
    }

    if ($VcsRepo) {
        $attributes['vcs-repo'] = $VcsRepo
    }

    $body = @{
        data = @{
            type = "workspaces"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating workspace '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create workspace: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/workspaces" -Method Post -Body $body
    }
}
