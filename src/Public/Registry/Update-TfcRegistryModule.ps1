<#
.SYNOPSIS
    Updates a private registry module
.DESCRIPTION
    Updates settings for a private registry module, including VCS repository and test configuration
.PARAMETER Organization
    The organization name
.PARAMETER Namespace
    The namespace of the module
.PARAMETER Name
    The name of the module
.PARAMETER Provider
    The provider name
.PARAMETER VcsRepo
    Optional hashtable for VCS repository settings (e.g., @{identifier="org/repo"; branch="main"})
.PARAMETER TestConfig
    Optional hashtable for test configuration (e.g., @{tests-enabled=$true})
.EXAMPLE
    Update-TfcRegistryModule -Organization "my-org" -Namespace "my-org" -Name "vpc" -Provider "aws" -VcsRepo @{identifier="my-org/terraform-aws-vpc"; branch="main"}
.EXAMPLE
    Update-TfcRegistryModule -Organization "my-org" -Namespace "my-org" -Name "vpc" -Provider "aws" -TestConfig @{"tests-enabled"=$true}
.OUTPUTS
    PSCustomObject representing the updated module
#>
function Update-TfcRegistryModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Namespace,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Provider,

        [Parameter(Mandatory = $false)]
        [hashtable]$VcsRepo,

        [Parameter(Mandatory = $false)]
        [hashtable]$TestConfig
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "registry-modules"
            attributes = @{}
        }
    }

    if ($PSBoundParameters.ContainsKey('VcsRepo')) {
        $body.data.attributes.'vcs-repo' = $VcsRepo
    }

    if ($PSBoundParameters.ContainsKey('TestConfig')) {
        $body.data.attributes.'test-config' = $TestConfig
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Module: $Namespace/$Name/$Provider", "Update registry module")) {
        Write-Verbose "Updating registry module: $Namespace/$Name/$Provider"
        return Invoke-TfcApi -Uri "/organizations/$Organization/registry-modules/private/$Namespace/$Name/$Provider" -Method PATCH -Body $bodyJson
    }
}
