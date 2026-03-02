<#
.SYNOPSIS
    Creates a workspace from a no-code module
.DESCRIPTION
    Creates a new workspace using a no-code module for self-service provisioning.
    Optionally allows setting variable values for the workspace.
.PARAMETER NoCodeModuleId
    The ID of the no-code module (format: ncm-xxxxx)
.PARAMETER Name
    The name for the new workspace
.PARAMETER Variables
    Optional hashtable of variable values to configure on the workspace
.EXAMPLE
    New-TfcNoCodeWorkspace -NoCodeModuleId "ncm-abc123" -Name "my-s3-bucket"
.EXAMPLE
    New-TfcNoCodeWorkspace -NoCodeModuleId "ncm-abc123" -Name "my-s3-bucket" -Variables @{bucket_name="my-bucket"; region="us-east-1"}
.OUTPUTS
    PSCustomObject representing the created workspace
#>
function New-TfcNoCodeWorkspace {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [hashtable]$Variables
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "workspaces"
            attributes = @{
                name = $Name
            }
        }
    }

    if ($Variables) {
        $variableArray = @()
        foreach ($key in $Variables.Keys) {
            $variableArray += @{
                type = "vars"
                attributes = @{
                    key   = $key
                    value = $Variables[$key]
                }
            }
        }
        $body.data.attributes.variables = $variableArray
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("No-Code Module: $NoCodeModuleId", "Create workspace: $Name")) {
        Write-Verbose "Creating no-code workspace '$Name' from module: $NoCodeModuleId"
        return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId/workspaces" -Method POST -Body $bodyJson
    }
}
