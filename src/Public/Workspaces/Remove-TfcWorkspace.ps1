<#
.SYNOPSIS
    Removes a workspace
.DESCRIPTION
    Deletes a workspace from Terraform Cloud
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The workspace name
.PARAMETER Force
    Skip confirmation prompt
.EXAMPLE
    Remove-TfcWorkspace -Organization "my-org" -Name "old-workspace"
.OUTPUTS
    None
#>
function Remove-TfcWorkspace {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    if ($Force -or $PSCmdlet.ShouldProcess("Workspace '$Organization/$Name'", "Delete")) {
        Write-Verbose "Deleting workspace '$Name' from organization '$Organization'"
        Invoke-TfcApi -Uri "/organizations/$Organization/workspaces/$Name" -Method DELETE
        Write-Output "Workspace '$Organization/$Name' has been deleted"
    }
}
