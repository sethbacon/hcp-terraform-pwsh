<#
.SYNOPSIS
    Updates an existing policy
.DESCRIPTION
    Updates a Sentinel or OPA policy's metadata or enforcement level
.PARAMETER PolicyId
    The policy ID
.PARAMETER Name
    Optional new policy name
.PARAMETER Description
    Optional new description
.PARAMETER EnforcementLevel
    Optional new enforcement level
.EXAMPLE
    Update-TfcPolicy -PolicyId "pol-123" -EnforcementLevel "hard-mandatory"
.OUTPUTS
    PSCustomObject representing the updated policy
#>
function Update-TfcPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicyId,
        [Parameter(Mandatory = $false)]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [ValidateSet("advisory", "soft-mandatory", "hard-mandatory")]
        [string]$EnforcementLevel
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "policies"
            attributes = @{}
        }
    }

    if ($Name) { $body.data.attributes.name = $Name }
    if ($Description) { $body.data.attributes.description = $Description }
    if ($EnforcementLevel) { $body.data.attributes."enforcement-level" = $EnforcementLevel }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Policy '$PolicyId'", "Update")) {
        Write-Verbose "Updating policy: $PolicyId"
        return Invoke-TfcApi -Uri "/policies/$PolicyId" -Method PATCH -Body $jsonBody
    }
}
