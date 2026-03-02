<#
.SYNOPSIS
    Archives a configuration version
.DESCRIPTION
    Triggers the archive action on a configuration version, making it read-only
.PARAMETER ConfigurationVersionId
    The configuration version ID to archive
.EXAMPLE
    Invoke-TfcConfigurationVersionArchive -ConfigurationVersionId "cv-abc123"
.OUTPUTS
    Boolean indicating success
#>
function Invoke-TfcConfigurationVersionArchive {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationVersionId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Configuration Version: $ConfigurationVersionId", "Archive")) {
        Write-Verbose "Archiving configuration version: $ConfigurationVersionId"
        try {
            Invoke-TfcApi -Uri "/configuration-versions/$ConfigurationVersionId/actions/archive" -Method POST | Out-Null
            return $true
        }
        catch {
            Write-Error "Failed to archive configuration version: $_"
            return $false
        }
    }
}
