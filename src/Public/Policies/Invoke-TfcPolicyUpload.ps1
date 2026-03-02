<#
.SYNOPSIS
    Uploads policy code content
.DESCRIPTION
    Uploads or updates the code content for a Sentinel or OPA policy
.PARAMETER PolicyId
    The policy ID
.PARAMETER PolicyCode
    The policy code content
.EXAMPLE
    Invoke-TfcPolicyUpload -PolicyId "pol-123" -PolicyCode $code
.OUTPUTS
    None
#>
function Invoke-TfcPolicyUpload {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$PolicyCode
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Policy '$PolicyId'", "Upload code")) {
        Write-Verbose "Getting upload URL for policy: $PolicyId"
        $policy = Invoke-TfcApi -Uri "/policies/$PolicyId"

        if ($policy.data.attributes.'upload-url') {
            $uploadUri = $policy.data.attributes.'upload-url'
            Write-Verbose "Uploading policy code to: $uploadUri"
            Invoke-RestMethod -Uri $uploadUri -Method PUT -Body $PolicyCode -ContentType "application/octet-stream" | Out-Null
        }
        else {
            throw "No upload URL available for policy: $PolicyId"
        }
    }
}
