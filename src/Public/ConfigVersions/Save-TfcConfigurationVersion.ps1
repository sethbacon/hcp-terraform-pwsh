<#
.SYNOPSIS
    Downloads a configuration version
.DESCRIPTION
    Downloads the configuration files for a configuration version and saves them to disk
.PARAMETER ConfigurationVersionId
    The configuration version ID
.PARAMETER OutputPath
    The path where the configuration tarball will be saved
.EXAMPLE
    Save-TfcConfigurationVersion -ConfigurationVersionId "cv-abc123" -OutputPath "./config.tar.gz"
.OUTPUTS
    None. Saves the configuration tarball to the specified path.
#>
function Save-TfcConfigurationVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationVersionId,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )

    Initialize-TfcConnection

    try {
        Write-Verbose "Downloading configuration version: $ConfigurationVersionId"
        $downloadUrl = "$($env:TFE_HOSTNAME)/api/v2/configuration-versions/$ConfigurationVersionId/download"

        $authHeaders = @{
            'Authorization' = "Bearer $($env:TFE_TOKEN)"
            'Content-Type'  = 'application/json'
        }

        Invoke-WebRequest -Uri $downloadUrl -OutFile $OutputPath -Headers $authHeaders -ErrorAction Stop
        Write-Output "Configuration version successfully downloaded to: $OutputPath"
    }
    catch {
        if ($_.Exception.Message -like "*404*") {
            Write-Error "Configuration version not found: $ConfigurationVersionId"
        }
        elseif ($_.Exception.Message -like "*401*") {
            Write-Error "Authentication failed. Please check your TFE_TOKEN environment variable."
        }
        else {
            Write-Error "Failed to download configuration version: $($_.Exception.Message)"
        }
    }
}
