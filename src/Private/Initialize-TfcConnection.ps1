<#
.SYNOPSIS
    Initializes the Terraform Cloud API connection
.DESCRIPTION
    Sets up the authentication token and headers for Terraform Cloud API calls
#>
function Initialize-TfcConnection {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Tokens from environment variables and credential files are inherently plaintext')]
    [CmdletBinding()]
    param()

    if (-not $script:TfcToken) {
        # Check for token in environment variables
        if ($env:TFE_TOKEN) {
            $script:TfcToken = ConvertTo-SecureString $env:TFE_TOKEN -AsPlainText -Force
            Write-Verbose "Using TFE_TOKEN environment variable"
        }
        elseif (Test-Path ~/.terraform.d/credentials.tfrc.json) {
            try {
                $credentials = Get-Content ~/.terraform.d/credentials.tfrc.json | ConvertFrom-Json
                $token = $credentials.credentials."app.terraform.io".token
                $script:TfcToken = ConvertTo-SecureString $token -AsPlainText -Force
                Write-Verbose "Using token from ~/.terraform.d/credentials.tfrc.json"
            }
            catch {
                throw "Failed to read token from ~/.terraform.d/credentials.tfrc.json: $($_.Exception.Message)"
            }
        }
        else {
            throw "No Terraform Cloud token found. Please set TFE_TOKEN environment variable or configure ~/.terraform.d/credentials.tfrc.json"
        }
    }
}
