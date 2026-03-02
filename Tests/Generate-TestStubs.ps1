# Generate Pester Test Stubs for All Functions
# Creates test file structure matching src/ directory

param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Stub Generator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$srcPath = Join-Path $PSScriptRoot '..' 'src' 'Public'
$testsPath = Join-Path $PSScriptRoot 'Unit'

# Resolve to full path
$srcPathResolved = (Resolve-Path $srcPath).Path

# Get all public function files
$functionFiles = Get-ChildItem -Path $srcPath -Recurse -Filter "*.ps1"

$created = 0
$skipped = 0
$total = $functionFiles.Count

Write-Host "Found $total function files to process" -ForegroundColor Green
Write-Host ""

foreach ($file in $functionFiles) {
    # Determine category from path - use resolved path for accurate substring
    $relativePath = $file.FullName.Substring($srcPathResolved.Length + 1)
    $categoryPath = Split-Path $relativePath -Parent

    # Handle files directly in Public folder (shouldn't happen, but just in case)
    if ([string]::IsNullOrEmpty($categoryPath)) {
        $category = "Misc"
    } else {
        $category = $categoryPath
    }    # Build test file path
    $testFileName = $file.BaseName + '.Tests.ps1'
    $testCategoryPath = Join-Path $testsPath $category

    # Ensure category directory exists
    if (-not (Test-Path $testCategoryPath)) {
        New-Item -Path $testCategoryPath -ItemType Directory -Force | Out-Null
    }

    $testFilePath = Join-Path $testCategoryPath $testFileName    # Check if test already exists
    if ((Test-Path $testFilePath) -and -not $Force) {
        Write-Host "  ⊘ Skipping $category/$testFileName (already exists)" -ForegroundColor Yellow
        $skipped++
        continue
    }

    # Generate test content
    $functionName = $file.BaseName

    # Determine appropriate mock based on category
    $mockSetup = switch ($category) {
        'Workspaces' { 'Mock Invoke-TfcApi { return @{ data = Get-MockWorkspace } }' }
        'Runs' { 'Mock Invoke-TfcApi { return @{ data = Get-MockRun } }' }
        'StateVersions' { 'Mock Invoke-TfcApi { return @{ data = Get-MockStateVersion } }' }
        'Policies' { 'Mock Invoke-TfcApi { return @{ data = Get-MockPolicy } }' }
        'OAuth' { 'Mock Invoke-TfcApi { return @{ data = Get-MockOAuthClient } }' }
        'Organizations' { 'Mock Invoke-TfcApi { return @{ data = Get-MockOrganization } }' }
        default { 'Mock Invoke-TfcApi { return @{ data = @{ id = "test-id"; type = "test-type" } } }' }
    }

    $testContent = @"
BeforeAll {
    `$helpersPath = Join-Path `$PSScriptRoot '..' '..' 'Helpers' 'TestHelpers.psm1'
    Import-Module `$helpersPath -Force

    `$mocksPath = Join-Path `$PSScriptRoot '..' '..' 'Mocks' 'TfcMocks.psm1'
    Import-Module `$mocksPath -Force

    `$modulePath = Join-Path `$PSScriptRoot '..' '..' '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module `$modulePath -Force

    `$env:TFE_TOKEN = "test-token-12345"
}

AfterAll {
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
    Remove-Module TestHelpers -Force -ErrorAction SilentlyContinue
    Remove-Module TfcMocks -Force -ErrorAction SilentlyContinue
}

Describe '$functionName' {
    BeforeEach {
        # TODO: Customize mock for $functionName
        $mockSetup
    }

    Context 'Parameter Validation' {
        It 'Should have appropriate parameters defined' {
            Get-Command $functionName | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Functionality' {
        It 'Should call Invoke-TfcApi correctly' -Skip {
            # TODO: Implement test for $functionName
            # $functionName -ParamName 'value'
            # Should -Invoke Invoke-TfcApi -Times 1
        }
    }
}
"@    # Write test file
    $testContent | Out-File -FilePath $testFilePath -Encoding utf8
    Write-Host "  ✓ Created $category/$testFileName" -ForegroundColor Green
    $created++
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Total Functions: $total" -ForegroundColor White
Write-Host "  Tests Created:   $created" -ForegroundColor Green
Write-Host "  Tests Skipped:   $skipped" -ForegroundColor Yellow
Write-Host ""

if ($created -gt 0) {
    Write-Host "✓ Test stubs generated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Review and customize generated test files" -ForegroundColor Gray
    Write-Host "  2. Add appropriate mocks and assertions" -ForegroundColor Gray
    Write-Host "  3. Run tests: ./Tests/Invoke-AllTests.ps1" -ForegroundColor Gray
} else {
    Write-Host "No new test files created" -ForegroundColor Yellow
}
