<#
.SYNOPSIS
    Deletes a HYOK configuration
.DESCRIPTION
    Removes a Hold Your Own Key (HYOK) configuration
.PARAMETER ConfigurationId
    The ID of the HYOK configuration to delete
.PARAMETER Force
    Skip confirmation prompt
.EXAMPLE
    Remove-TfcHYOKConfiguration -ConfigurationId "hyokc-abc123"
.EXAMPLE
    Remove-TfcHYOKConfiguration -ConfigurationId "hyokc-abc123" -Force
.OUTPUTS
    None
#>
function Remove-TfcHYOKConfiguration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationId,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    if ($Force -or $PSCmdlet.ShouldProcess("HYOK Configuration: $ConfigurationId", "Delete HYOK configuration")) {
        Write-Verbose "Deleting HYOK configuration: $ConfigurationId"
        Invoke-TfcApi -Uri "/hyok-configurations/$ConfigurationId" -Method DELETE
        Write-Output "HYOK configuration '$ConfigurationId' has been deleted"
    }
}
