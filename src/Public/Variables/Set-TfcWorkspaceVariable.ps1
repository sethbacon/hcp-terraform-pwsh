<#
.SYNOPSIS
    Sets a variable in a workspace
.DESCRIPTION
    Creates or updates a variable in a Terraform Cloud workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER Key
    The variable name/key
.PARAMETER Value
    The variable value
.PARAMETER Category
    The variable category (terraform or env)
.PARAMETER HCL
    Whether the variable should be parsed as HCL
.PARAMETER Sensitive
    Whether the variable is sensitive
.PARAMETER Description
    Optional description for the variable
.EXAMPLE
    Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-east-1" -Category "terraform"
.EXAMPLE
    Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "API_KEY" -Value "secret" -Category "env" -Sensitive
.OUTPUTS
    PSCustomObject representing the created/updated variable
#>
function Set-TfcWorkspaceVariable {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [string]$Value,

        [Parameter(Mandatory = $true)]
        [ValidateSet('terraform', 'env')]
        [string]$Category,

        [Parameter(Mandatory = $false)]
        [switch]$HCL,

        [Parameter(Mandatory = $false)]
        [switch]$Sensitive,

        [Parameter(Mandatory = $false)]
        [string]$Description = ""
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    $body = @{
        data = @{
            type = "vars"
            attributes = @{
                key = $Key
                value = $Value
                category = $Category
                hcl = $HCL.IsPresent
                sensitive = $Sensitive.IsPresent
                description = $Description
            }
            relationships = @{
                workspace = @{
                    data = @{
                        id = $WorkspaceId
                        type = "workspaces"
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Create variable: $Key")) {
        Write-Verbose "Setting variable '$Key' in workspace: $WorkspaceId"
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/vars" -Method POST -Body $body
    }
}
