<#
.SYNOPSIS
    Creates a new policy
.DESCRIPTION
    Creates a Sentinel or OPA policy for compliance enforcement
.PARAMETER OrganizationName
    The organization name
.PARAMETER Name
    The policy name
.PARAMETER Description
    Optional policy description
.PARAMETER Kind
    Policy kind: sentinel or opa
.PARAMETER EnforcementLevel
    Enforcement level: advisory, soft-mandatory, or hard-mandatory
.PARAMETER PolicyCode
    The policy code content
.EXAMPLE
    New-TfcPolicy -OrganizationName "my-org" -Name "require-tags" -Kind "sentinel" -Enforcement "soft-mandatory" -PolicyCode $code
.OUTPUTS
    PSCustomObject representing the created policy
#>
function New-TfcPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $true)]
        [ValidateSet("sentinel", "opa")]
        [string]$Kind,
        [Parameter(Mandatory = $true)]
        [ValidateSet("advisory", "soft-mandatory", "hard-mandatory")]
        [string]$EnforcementLevel,
        [Parameter(Mandatory = $true)]
        [string]$PolicyCode
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "policies"
            attributes = @{
                name = $Name
                kind = $Kind
                "enforcement-level" = $EnforcementLevel
            }
        }
    }

    if ($Description) {
        $body.data.attributes.description = $Description
    }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Policy '$Name'", "Create")) {
        Write-Verbose "Creating policy: $Name in organization $OrganizationName"
        $policy = Invoke-TfcApi -Uri "/organizations/$OrganizationName/policies" -Method POST -Body $jsonBody

        # Upload policy code
        if ($policy.data.attributes.'upload-url') {
            $uploadUri = $policy.data.attributes.'upload-url'
            Write-Verbose "Uploading policy code to: $uploadUri"
            Invoke-RestMethod -Uri $uploadUri -Method PUT -Body $PolicyCode -ContentType "application/octet-stream" | Out-Null
        }

        return $policy
    }
}
