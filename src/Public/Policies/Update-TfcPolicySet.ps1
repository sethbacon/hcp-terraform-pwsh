<#
.SYNOPSIS
    Updates an existing policy set
.DESCRIPTION
    Updates a policy set's metadata or targeting
.PARAMETER PolicySetId
    The policy set ID
.PARAMETER Name
    Optional new name
.PARAMETER Description
    Optional new description
.PARAMETER Global
    Optional global setting
.PARAMETER Overridable
    Optional overridable setting
.EXAMPLE
    Update-TfcPolicySet -PolicySetId "polset-123" -Global
.OUTPUTS
    PSCustomObject representing the updated policy set
#>
function Update-TfcPolicySet {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PolicySetId,
        [Parameter(Mandatory = $false)]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [bool]$Global,
        [Parameter(Mandatory = $false)]
        [bool]$Overridable
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "policy-sets"
            attributes = @{}
        }
    }

    if ($Name) { $body.data.attributes.name = $Name }
    if ($Description) { $body.data.attributes.description = $Description }
    if ($PSBoundParameters.ContainsKey('Global')) { $body.data.attributes.global = $Global }
    if ($PSBoundParameters.ContainsKey('Overridable')) { $body.data.attributes.overridable = $Overridable }

    $jsonBody = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Policy Set '$PolicySetId'", "Update")) {
        Write-Verbose "Updating policy set: $PolicySetId"
        return Invoke-TfcApi -Uri "/policy-sets/$PolicySetId" -Method PATCH -Body $jsonBody
    }
}
