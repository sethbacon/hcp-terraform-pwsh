<#
.SYNOPSIS
    Creates a reserved tag key
.DESCRIPTION
    Creates a new reserved tag key that cannot be used for workspace tagging
.PARAMETER Organization
    The name of the organization
.PARAMETER Key
    The tag key to reserve
.EXAMPLE
    New-TfcReservedTagKey -Organization "my-org" -Key "production"
.OUTPUTS
    PSCustomObject representing the created reserved tag key
#>
function New-TfcReservedTagKey {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Key
    )

    if ($PSCmdlet.ShouldProcess("Tag key '$Key'", "Reserve tag key")) {
        $body = @{
            data = @{
                type = 'reserved-tag-keys'
                attributes = @{
                    key = $Key
                }
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Reserving tag key '$Key' for organization: $Organization"

        return Invoke-TfcApi -Uri "/organizations/$Organization/reserved-tag-keys" -Method POST -Body $body
    }
}
