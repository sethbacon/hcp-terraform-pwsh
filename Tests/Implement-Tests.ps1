<#
.SYNOPSIS
    Implements comprehensive tests for TerraformCloud module functions
.DESCRIPTION
    This script generates comprehensive test implementations based on function analysis.
    It creates tests for parameter validation, API calls, request bodies, and error handling.
.PARAMETER Category
    Specific category to implement tests for (e.g., 'Workspaces', 'Runs')
.PARAMETER FunctionName
    Specific function to implement tests for
.PARAMETER Force
    Overwrite existing test implementations
.EXAMPLE
    .\Implement-Tests.ps1 -Category Workspaces
.EXAMPLE
    .\Implement-Tests.ps1 -FunctionName Get-TfcRun -Force
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Category,

    [Parameter(Mandatory = $false)]
    [string]$FunctionName,

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# Get script directory
$scriptRoot = Split-Path -Parent $PSCommandPath
$srcRoot = Join-Path $scriptRoot '..' 'src' 'Public'
$testRoot = Join-Path $scriptRoot 'Unit'

function Get-FunctionInfo {
    param([string]$FilePath)

    $content = Get-Content -Path $FilePath -Raw
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$null, [ref]$null)

    $functionDef = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false) | Select-Object -First 1

    if (-not $functionDef) { return $null }

    $info = @{
        Name = $functionDef.Name
        Parameters = @()
        SupportsShouldProcess = $false
        HttpMethod = 'Get'
    }

    # Check for SupportsShouldProcess
    if ($content -match '\[CmdletBinding\([^\)]*SupportsShouldProcess') {
        $info.SupportsShouldProcess = $true
    }

    # Determine HTTP method from function content
    if ($content -match "Method\s*=\s*'Post'") {
        $info.HttpMethod = 'Post'
    } elseif ($content -match "Method\s*=\s*'Patch'") {
        $info.HttpMethod = 'Patch'
    } elseif ($content -match "Method\s*=\s*'Delete'") {
        $info.HttpMethod = 'Delete'
    }

    # Extract parameters
    $paramBlock = $functionDef.Body.ParamBlock
    if ($paramBlock) {
        foreach ($param in $paramBlock.Parameters) {
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

            $info.Parameters += $paramInfo
        }
    }

    return $info
}

function Get-CategoryMockFunction {
    param([string]$Category)

    $mockMap = @{
        'Workspaces' = 'Get-MockWorkspace'
        'Runs' = 'Get-MockRun'
        'StateVersions' = 'Get-MockStateVersion'
        'Policies' = 'Get-MockPolicy'
        'OAuth' = 'Get-MockOAuthClient'
        'Organizations' = 'Get-MockOrganization'
        'Teams' = 'Get-MockOrganization'
        'Variables' = 'Get-MockWorkspaceVariable'
    }

    if ($mockMap.ContainsKey($Category)) {
        return $mockMap[$Category]
    }

    return 'Get-MockWorkspace'
}

function New-TestImplementation {
    param(
        [object]$FunctionInfo,
        [string]$Category
    )

    $mockFunction = Get-CategoryMockFunction -Category $Category
    $funcName = $FunctionInfo.Name

    $test = @"
Describe '$funcName' {
    BeforeEach {
        Mock Invoke-TfcApi -ModuleName TerraformCloud
    }

    Context 'Parameter Validation' {
"@

    # Add parameter validation tests
    foreach ($param in $FunctionInfo.Parameters) {
        if ($param.Mandatory) {
            $test += @"

        It 'Should have $($param.Name) parameter as mandatory' {
            `$command = Get-Command $funcName
            `$command.Parameters['$($param.Name)'].Attributes.Mandatory | Should -Be `$true
        }
"@
        }

        if ($param.ValidateRange) {
            $test += @"

        It 'Should have $($param.Name) parameter with valid range $($param.ValidateRange.Min)-$($param.ValidateRange.Max)' {
            `$command = Get-Command $funcName
            `$param = `$command.Parameters['$($param.Name)']
            `$param.Attributes.Where({`$_.TypeId.Name -eq 'ValidateRangeAttribute'}).MinRange | Should -Be $($param.ValidateRange.Min)
            `$param.Attributes.Where({`$_.TypeId.Name -eq 'ValidateRangeAttribute'}).MaxRange | Should -Be $($param.ValidateRange.Max)
        }
"@
        }

        if ($param.Switch) {
            $test += @"

        It 'Should have $($param.Name) as switch parameter' {
            `$command = Get-Command $funcName
            `$command.Parameters['$($param.Name)'].SwitchParameter | Should -Be `$true
        }
"@
        }
    }

    if ($FunctionInfo.SupportsShouldProcess) {
        $test += @"

        It 'Should support ShouldProcess' {
            `$command = Get-Command $funcName
            `$command.Parameters.ContainsKey('WhatIf') | Should -Be `$true
            `$command.Parameters.ContainsKey('Confirm') | Should -Be `$true
        }
"@
    }

    $test += @"

    }

    Context 'API Interaction' {
        It 'Should call Invoke-TfcApi with correct method' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = $mockFunction }
            }

            # TODO: Add actual function call with required parameters
            # $funcName -RequiredParam 'value' $(if ($FunctionInfo.SupportsShouldProcess) { '-Confirm:$false' })

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                `$Method -eq '$($FunctionInfo.HttpMethod)'
            }
        }

        It 'Should call correct API endpoint' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                return @{ data = $mockFunction }
            }

            # TODO: Add actual function call with required parameters
            # $funcName -RequiredParam 'value' $(if ($FunctionInfo.SupportsShouldProcess) { '-Confirm:$false' })

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1 -ParameterFilter {
                # TODO: Add URI validation
                `$Uri -like '*/expected/path*'
            }
        }
    }
"@

    if ($FunctionInfo.HttpMethod -in @('Post', 'Patch')) {
        $test += @"


    Context 'Request Body Validation' {
        It 'Should include required fields in request body' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud -MockWith {
                param(`$Uri, `$Method, `$Body)
                `$bodyObj = `$Body | ConvertFrom-Json
                # TODO: Add body validation assertions
                `$bodyObj.data.type | Should -Not -BeNullOrEmpty
                return @{ data = $mockFunction }
            }

            # TODO: Add actual function call with required parameters
            # $funcName -RequiredParam 'value' $(if ($FunctionInfo.SupportsShouldProcess) { '-Confirm:$false' })
        }
    }
"@
    }

    if ($FunctionInfo.SupportsShouldProcess) {
        $test += @"


    Context 'ShouldProcess Support' {
        It 'Should not make API call when WhatIf is specified' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud

            # TODO: Add actual function call with required parameters
            # $funcName -RequiredParam 'value' -WhatIf

            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 0
        }
    }
"@
    }

    $test += @"

}
"@

    return $test
}

# Main execution
try {
    $testsImplemented = 0
    $testsSkipped = 0

    # Get all function files
    $functionFiles = if ($FunctionName) {
        Get-ChildItem -Path $srcRoot -Recurse -Filter "$FunctionName.ps1"
    } elseif ($Category) {
        Get-ChildItem -Path (Join-Path $srcRoot $Category) -Filter '*.ps1'
    } else {
        Get-ChildItem -Path $srcRoot -Recurse -Filter '*.ps1'
    }

    foreach ($file in $functionFiles) {
        $funcInfo = Get-FunctionInfo -FilePath $file.FullName

        if (-not $funcInfo) {
            Write-Warning "Could not parse function from: $($file.FullName)"
            continue
        }

        # Determine category from path
        $relativePath = $file.FullName.Replace($srcRoot, '').TrimStart('\', '/')
        $categoryName = $relativePath.Split([IO.Path]::DirectorySeparatorChar)[0]

        # Find corresponding test file
        $testFile = Join-Path $testRoot $categoryName "$($funcInfo.Name).Tests.ps1"

        if (-not (Test-Path $testFile)) {
            Write-Warning "Test file not found: $testFile"
            continue
        }

        # Check if test already has implementation (not just TODO comments)
        $existingTest = Get-Content -Path $testFile -Raw
        if ((-not $Force) -and ($existingTest -notmatch '\-Skip' -and $existingTest -notmatch 'TODO')) {
            Write-Verbose "Test already implemented: $testFile"
            $testsSkipped++
            continue
        }

        # Generate new test
        $newTest = New-TestImplementation -FunctionInfo $funcInfo -Category $categoryName

        # Keep the BeforeAll/AfterAll blocks from existing test
        $beforeAll = if ($existingTest -match '(?s)(BeforeAll \{.*?\n\})') { $matches[1] } else { '' }
        $afterAll = if ($existingTest -match '(?s)(AfterAll \{.*?\n\})') { $matches[1] } else { '' }

        $fullTest = @"
$beforeAll

$afterAll

$newTest
"@

        # Write test file
        Set-Content -Path $testFile -Value $fullTest.Trim() -Force

        Write-Host "✅ Implemented test for: $($funcInfo.Name)" -ForegroundColor Green
        $testsImplemented++
    }

    Write-Host ""
    Write-Host "Test Implementation Summary:" -ForegroundColor Cyan
    Write-Host "  Tests Implemented: $testsImplemented" -ForegroundColor Green
    Write-Host "  Tests Skipped: $testsSkipped" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "⚠️  Note: Generated tests include TODO comments for manual completion" -ForegroundColor Yellow
    Write-Host "   Review each test and fill in actual function calls and assertions" -ForegroundColor Yellow

} catch {
    Write-Error "Error implementing tests: $_"
    exit 1
}
