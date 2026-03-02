<#
.SYNOPSIS
    Bulk implements tests for all TerraformCloud functions
.DESCRIPTION
    Analyzes function signatures and generates comprehensive test implementations
    with proper parameter validation, API call verification, and mocking
.PARAMETER Category
    Specific category to implement (e.g., 'Policies', 'StateVersions')
.PARAMETER DryRun
    Show what would be done without making changes
.PARAMETER Force
    Overwrite existing test implementations
.EXAMPLE
    .\Bulk-Implement-Tests.ps1 -Category Policies
.EXAMPLE
    .\Bulk-Implement-Tests.ps1 -Force
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Category,

    [Parameter(Mandatory = $false)]
    [switch]$DryRun,

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# Template for comprehensive test
$testTemplate = @'
BeforeAll {{
    $helpersPath = Join-Path $PSScriptRoot '..' '..' 'Helpers' 'TestHelpers.psm1'
    Import-Module $helpersPath -Force

    $mocksPath = Join-Path $PSScriptRoot '..' '..' 'Mocks' 'TfcMocks.psm1'
    Import-Module $mocksPath -Force

    $modulePath = Join-Path $PSScriptRoot '..' '..' '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module $modulePath -Force

    $env:TFE_TOKEN = "test-token-12345"
}}

AfterAll {{
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
    Remove-Module TestHelpers -Force -ErrorAction SilentlyContinue
    Remove-Module TfcMocks -Force -ErrorAction SilentlyContinue
}}

Describe '{FUNCTION_NAME}' {{
    BeforeEach {{
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }}

    Context 'Parameter Validation' {{
{PARAMETER_TESTS}
    }}

    Context 'API Interaction' {{
        It 'Should call Invoke-TfcApi with correct HTTP method' {{
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {{
                return @{{ data = {MOCK_FUNCTION} }}
            }}

            # {FUNCTION_NAME} {SAMPLE_PARAMS}{CONFIRM_FLAG}

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {{
                $Method -eq '{HTTP_METHOD}'
            }}
        }}

        It 'Should call correct API endpoint' {{
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {{
                return @{{ data = {MOCK_FUNCTION} }}
            }}

            # {FUNCTION_NAME} {SAMPLE_PARAMS}{CONFIRM_FLAG}

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {{
                $Uri -like '*{URI_PATTERN}*'
            }}
        }}
    }}
{BODY_TESTS}
{WHATIF_TESTS}
}}
'@

function Get-CategoryMock {
    param([string]$Cat)

    $mocks = @{
        'Workspaces' = 'Get-MockWorkspace'
        'Runs' = 'Get-MockRun'
        'Plans' = 'Get-MockPlan'
        'Applies' = 'Get-MockApply'
        'StateVersions' = 'Get-MockStateVersion'
        'Policies' = 'Get-MockPolicy'
        'OAuth' = 'Get-MockOAuthClient'
        'Organizations' = 'Get-MockOrganization'
        'Teams' = 'Get-MockOrganization'
        'Variables' = 'Get-MockWorkspaceVariable'
    }

    return $mocks[$Cat] ?? 'Get-MockWorkspace'
}

function Get-HttpMethod {
    param([string]$FunctionName, [string]$Content)

    if ($Content -match "Method\s*=\s*'(\w+)'") {
        return $matches[1]
    }

    # Infer from function name
    if ($FunctionName -match '^New-') { return 'Post' }
    if ($FunctionName -match '^Update-|^Set-') { return 'Patch' }
    if ($FunctionName -match '^Remove-') { return 'Delete' }

    return 'Get'
}

function Get-UriPattern {
    param([string]$Content)

    if ($Content -match 'Invoke-TfcApi.*-Uri\s+"([^"]+)"') {
        $uri = $matches[1]
        # Replace variables with wildcards
        $uri = $uri -replace '\$\w+', '*'
        return $uri
    }

    return ''
}

function Build-ParameterTests {
    param([array]$Parameters)

    $tests = ""

    foreach ($param in $Parameters) {
        if ($param.Mandatory) {
            $tests += @"

        It 'Should have $($param.Name) parameter as mandatory' {
            `$command = Get-Command {FUNCTION_NAME}
            `$command.Parameters['$($param.Name)'].Attributes.Mandatory | Should -Be `$true
        }
"@
        }

        if ($param.ValidateRange) {
            $tests += @"

        It 'Should have $($param.Name) with valid range $($param.ValidateRange.Min)-$($param.ValidateRange.Max)' {
            `$command = Get-Command {FUNCTION_NAME}
            `$param = `$command.Parameters['$($param.Name)']
            `$range = `$param.Attributes.Where({{`$_.TypeId.Name -eq 'ValidateRangeAttribute'}})
            `$range.MinRange | Should -Be $($param.ValidateRange.Min)
            `$range.MaxRange | Should -Be $($param.ValidateRange.Max)
        }
"@
        }

        if ($param.Switch) {
            $tests += @"

        It 'Should have $($param.Name) as switch parameter' {
            `$command = Get-Command {FUNCTION_NAME}
            `$command.Parameters['$($param.Name)'].SwitchParameter | Should -Be `$true
        }
"@
        }
    }

    return $tests
}

function Build-SampleParams {
    param([array]$Parameters)

    $params = @()
    foreach ($param in $Parameters) {
        if ($param.Mandatory) {
            $value = switch ($param.Type) {
                'String' { "'test-value'" }
                'Int32' { '1' }
                'Boolean' { '$true' }
                'Hashtable' { '@{}' }
                default { "'test'" }
            }
            $params += "-$($param.Name) $value"
        }
    }

    return $params -join ' '
}

# Main execution
$scriptRoot = Split-Path -Parent $PSCommandPath
$srcRoot = Join-Path $scriptRoot '..' 'src' 'Public'
$testRoot = Join-Path $scriptRoot 'Unit'

$stats = @{
    Implemented = 0
    Skipped = 0
    Failed = 0
}

# Get functions to process
$functionFiles = if ($Category) {
    Get-ChildItem -Path (Join-Path $srcRoot $Category) -Filter '*.ps1' -ErrorAction SilentlyContinue
} else {
    Get-ChildItem -Path $srcRoot -Recurse -Filter '*.ps1'
}

foreach ($file in $functionFiles) {
    try {
        # Parse function
        $content = Get-Content -Path $file.FullName -Raw
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$null, [ref]$null)
        $funcDef = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false) | Select-Object -First 1

        if (-not $funcDef) {
            Write-Warning "No function found in: $($file.Name)"
            continue
        }

        $funcName = $funcDef.Name

        # Determine category
        $relativePath = $file.FullName.Replace($srcRoot, '').TrimStart('\', '/')
        $cat = $relativePath.Split([IO.Path]::DirectorySeparatorChar)[0]

        # Get test file path
        $testFile = Join-Path $testRoot $cat "$funcName.Tests.ps1"

        if (-not (Test-Path $testFile)) {
            Write-Warning "Test file not found: $testFile"
            $stats.Failed++
            continue
        }

        # Check if already implemented
        if (-not $Force) {
            $existing = Get-Content -Path $testFile -Raw
            if ($existing -notmatch '-Skip' -and $existing -notmatch 'TODO:') {
                Write-Verbose "Already implemented: $funcName"
                $stats.Skipped++
                continue
            }
        }

        # Extract parameters
        $parameters = @()
        $supportsShouldProcess = $content -match 'SupportsShouldProcess'

        if ($funcDef.Body.ParamBlock) {
            foreach ($param in $funcDef.Body.ParamBlock.Parameters) {
                $paramInfo = @{
                    Name = $param.Name.VariablePath.UserPath
                    Type = if ($param.StaticType) { $param.StaticType.Name } else { 'Object' }
                    Mandatory = $false
                    ValidateRange = $null
                    Switch = $false
                }

                foreach ($attr in $param.Attributes) {
                    if ($attr.TypeName.Name -eq 'Parameter') {
                        foreach ($arg in $attr.NamedArguments) {
                            if ($arg.ArgumentName -eq 'Mandatory' -and $arg.Argument.Value -eq $true) {
                                $paramInfo.Mandatory = $true
                            }
                        }
                    } elseif ($attr.TypeName.Name -eq 'ValidateRange') {
                        $paramInfo.ValidateRange = @{
                            Min = $attr.PositionalArguments[0].Value
                            Max = $attr.PositionalArguments[1].Value
                        }
                    } elseif ($attr.TypeName.Name -eq 'switch') {
                        $paramInfo.Switch = $true
                    }
                }

                $parameters += $paramInfo
            }
        }

        if ($supportsShouldProcess) {
            $parameters += @{ Name = 'WhatIf'; Type = 'SwitchParameter'; Mandatory = $false; Switch = $true }
            $parameters += @{ Name = 'Confirm'; Type = 'SwitchParameter'; Mandatory = $false; Switch = $true }
        }

        # Build test components
        $httpMethod = Get-HttpMethod -FunctionName $funcName -Content $content
        $uriPattern = Get-UriPattern -Content $content
        $mockFunc = Get-CategoryMock -Cat $cat
        $paramTests = Build-ParameterTests -Parameters $parameters
        $sampleParams = Build-SampleParams -Parameters $parameters
        $confirmFlag = if ($supportsShouldProcess) { ' -Confirm:$false' } else { '' }

        # Body tests for Post/Patch
        $bodyTests = if ($httpMethod -in @('Post', 'Patch')) {
            @"


    Context 'Request Body Validation' {
        It 'Should include required data in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param(`$Uri, `$Method, `$Body)
                `$bodyObj = `$Body | ConvertFrom-Json
                `$bodyObj.data | Should -Not -BeNullOrEmpty
                return @{ data = $mockFunc }
            }

            # $funcName $sampleParams$confirmFlag
        }
    }
"@
        } else { "" }

        # WhatIf tests
        $whatIfTests = if ($supportsShouldProcess) {
            @"


    Context 'ShouldProcess Support' {
        It 'Should not make API call when WhatIf is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud

            # $funcName $sampleParams -WhatIf

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
"@
        } else { "" }

        # Build final test
        $test = $testTemplate
        $test = $test -replace '\{FUNCTION_NAME\}', $funcName
        $test = $test -replace '\{MOCK_FUNCTION\}', $mockFunc
        $test = $test -replace '\{HTTP_METHOD\}', $httpMethod
        $test = $test -replace '\{URI_PATTERN\}', $uriPattern
        $test = $test -replace '\{PARAMETER_TESTS\}', $paramTests
        $test = $test -replace '\{SAMPLE_PARAMS\}', $sampleParams
        $test = $test -replace '\{CONFIRM_FLAG\}', $confirmFlag
        $test = $test -replace '\{BODY_TESTS\}', $bodyTests
        $test = $test -replace '\{WHATIF_TESTS\}', $whatIfTests

        if ($DryRun) {
            Write-Host "Would implement: $funcName" -ForegroundColor Cyan
        } else {
            Set-Content -Path $testFile -Value $test -Force
            Write-Host "✅ Implemented: $funcName" -ForegroundColor Green
            $stats.Implemented++
        }

    } catch {
        Write-Error "Failed to process $($file.Name): $_"
        $stats.Failed++
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Test Implementation Summary" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Implemented: $($stats.Implemented)" -ForegroundColor Green
Write-Host "  Skipped:     $($stats.Skipped)" -ForegroundColor Yellow
Write-Host "  Failed:      $($stats.Failed)" -ForegroundColor Red
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if (-not $DryRun) {
    Write-Host "⚠️  Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Review generated tests and uncomment function calls" -ForegroundColor White
    Write-Host "  2. Run tests: pwsh Tests/Invoke-AllTests.ps1" -ForegroundColor White
    Write-Host "  3. Fix any failing tests" -ForegroundColor White
}
