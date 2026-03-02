<#
.SYNOPSIS
    Removes a project
.DESCRIPTION
    Deletes a project from Terraform Cloud
.PARAMETER ProjectId
    The project ID
.PARAMETER Force
    Skip confirmation prompt
.EXAMPLE
    Remove-TfcProject -ProjectId "prj-123"
.OUTPUTS
    None
#>
function Remove-TfcProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    if ($Force -or $PSCmdlet.ShouldProcess("Project '$ProjectId'", "Delete")) {
        Write-Verbose "Deleting project: $ProjectId"
        Invoke-TfcApi -Uri "/projects/$ProjectId" -Method DELETE
        Write-Output "Project '$ProjectId' has been deleted"
    }
}
