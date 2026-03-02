<#
.SYNOPSIS
    Create a new stack deployment
.DESCRIPTION
    Triggers a new deployment for a stack
.PARAMETER StackId
    The ID of the stack
.PARAMETER Message
    Optional message describing the deployment
.EXAMPLE
    New-TfcStackDeployment -StackId "stack-123" -Message "Deploy production changes"
.OUTPUTS
    PSCustomObject representing the created deployment
#>
function New-TfcStackDeployment {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId,

        [Parameter(Mandatory = $false)]
        [string]$Message
    )

    try {
        Initialize-TfcConnection

        $attributes = @{}
        if ($Message) { $attributes['message'] = $Message }

        $body = @{
            data = @{
                type = "stack-deployments"
                attributes = $attributes
                relationships = @{
                    stack = @{
                        data = @{
                            type = "stacks"
                            id = $StackId
                        }
                    }
                }
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Stack: $StackId", "Create deployment")) {
            Write-Verbose "Creating deployment for stack: $StackId"
            return Invoke-TfcApi -Uri "/stack-deployments" -Method POST -Body $body
        }
    }
    catch {
        throw "Failed to create stack deployment: $($_.Exception.Message)"
    }
}
