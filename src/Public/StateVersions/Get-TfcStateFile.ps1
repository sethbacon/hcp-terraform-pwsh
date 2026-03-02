<#
.SYNOPSIS
    Downloads the state file from a state version
.DESCRIPTION
    Downloads the raw Terraform state file content from a state version
.PARAMETER StateVersionId
    The ID of the state version
.PARAMETER OutputPath
    Optional path to save the state file
.EXAMPLE
    Get-TfcStateFile -StateVersionId "sv-123" -OutputPath "terraform.tfstate"
.EXAMPLE
    Get-TfcStateFile -StateVersionId "sv-123"
.OUTPUTS
    String content of the state file, or file path if saved
#>
function Get-TfcStateFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StateVersionId,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    Write-Verbose "Retrieving state file for state version: $StateVersionId"

    # Get state version to get download URL
    $stateVersion = Invoke-TfcApi -Uri "/state-versions/$StateVersionId"
    $downloadUrl = $stateVersion.data.attributes.'hosted-state-download-url'

    if (-not $downloadUrl) {
        Write-Error "No download URL available for state version $StateVersionId"
        return
    }

    # Download the state file
    $stateContent = Invoke-RestMethod -Uri $downloadUrl -Method GET

    if ($OutputPath) {
        $stateContent | Out-File -FilePath $OutputPath -Encoding utf8
        Write-Verbose "State file saved to: $OutputPath"
        return $OutputPath
    } else {
        return $stateContent
    }
}
