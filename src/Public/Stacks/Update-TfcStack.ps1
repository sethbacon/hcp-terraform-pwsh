<#
.SYNOPSIS
    Update an existing stack
.DESCRIPTION
    Updates the configuration of an existing stack
.PARAMETER StackId
    The ID of the stack
.PARAMETER Name
    New name for the stack
.PARAMETER Description
    New description for the stack
.EXAMPLE
    Update-TfcStack -StackId "stack-123" -Description "Updated production stack"
.OUTPUTS
    PSCustomObject representing the updated stack
#>
function Update-TfcStack {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    try {
        Initialize-TfcConnection

        $attributes = @{}
        if ($Name) { $attributes['name'] = $Name }
        if ($Description) { $attributes['description'] = $Description }

        if ($attributes.Count -eq 0) {
            throw "At least one attribute must be specified for update"
        }

        $body = @{
            data = @{
                type = "stacks"
                attributes = $attributes
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Stack: $StackId", "Update stack")) {
            Write-Verbose "Updating stack: $StackId"
            return Invoke-TfcApi -Uri "/stacks/$StackId" -Method PATCH -Body $body
        }
    }
    catch {
        throw "Failed to update stack: $($_.Exception.Message)"
    }
}
