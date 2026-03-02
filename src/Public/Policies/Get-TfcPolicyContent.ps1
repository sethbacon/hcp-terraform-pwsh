<#
.SYNOPSIS
    Gets policy content (code)
.DESCRIPTION
    Downloads the policy code/content for a specific policy
.PARAMETER PolicyId
    The ID of the policy to download content for
.PARAMETER OutputPath
    Optional file path to save the downloaded policy content
.EXAMPLE
    Get-TfcPolicyContent -PolicyId "pol-123"
.EXAMPLE
    Get-TfcPolicyContent -PolicyId "pol-123" -OutputPath "./policy.sentinel"
.OUTPUTS
    String containing policy content, or file path if OutputPath specified
#>
function Get-TfcPolicyContent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyId,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    Write-Verbose "Downloading policy content for: $PolicyId"
    $response = Invoke-TfcApi -Uri "/policies/$PolicyId/download"

    if ($OutputPath) {
        $response | Out-File -FilePath $OutputPath -Encoding UTF8 -Force
        Write-Verbose "Policy content saved to: $OutputPath"
        return $OutputPath
    }
    else {
        return $response
    }
}
