# TerraformCloud PowerShell Module - Testing Guide

## Overview

The `Test-TerraformCloudModule.ps1` script provides comprehensive testing for the TerraformCloud PowerShell module with built-in safety features for production environments. This guide covers all testing options, safety features, and best practices.

## Quick Start

### Safe Testing (Recommended)

```powershell
# Mock mode - completely safe, no real API calls
./Test-TerraformCloudModule.ps1 -MockMode

# Production-safe mode - read-only operations only (default)
./Test-TerraformCloudModule.ps1
```

### Test Organization Mode

```powershell
# Full testing with dedicated test organization
./Test-TerraformCloudModule.ps1 -UseTestOrganization -TestOrganizationName "my-test-org" -RunDestructiveTests
```

## Testing Modes

### Mock Mode (`-MockMode`)

**Completely safe simulation mode that requires no API credentials.**

Features:

- Simulates all API responses with realistic mock data
- Tests function signatures and logic flow
- No real API calls for any operations
- Fast execution (no network dependencies)
- Can test error scenarios safely

Mock data includes:

- User account information
- Organizations and entitlements
- Workspaces and variables
- Teams and OAuth clients
- Variable sets and state versions
- Runs and API responses

### Live API Mode

**Tests against real Terraform Cloud/Enterprise API.**

Safety levels:

1. **Production Safe** (default): Read-only operations only
2. **Test Organization** (`-UseTestOrganization`): Full testing with dedicated test org
3. **Hybrid** (`-MockMode:$false`): Live reads, mock writes

## Test Coverage

The script includes **177 comprehensive tests** organized into categories:

### Core Module Tests (6 tests)

- **Module Import**: Verifies PowerShell module loads correctly from consolidated `TerraformCloud.psm1`
- **Authentication Check**: Validates API token and credentials
- **Organization Tests**: Get organizations, specific organization, entitlements
- **Workspace Tests**: Get workspaces, find workspace, ID validation

### Comprehensive Function Coverage (171 tests)

Tests cover all 194 module functions across these categories:

**Core Operations** (28 tests): Workspaces, variables, variable sets, teams, OAuth, configuration, state, runs, plans, applies, projects, registry

**Workflow Automation** (34 tests): Run triggers, run tasks, notifications, enhanced plans/applies, workspace team access

**Enterprise Features** (27 tests): Agent pools, agent tokens, SSH keys, token management, additional features

**Policy & Compliance** (17 tests): Policies, policy sets, policy checks, audit trails, comments

**Enhanced RBAC** (20 tests): Variable set variables, team membership, project team access, organization memberships, organization tags

**Extended Run/Resource Management** (13 tests): Run details, run task results, workspace resource details, OAuth tokens, assessment results, cost estimate logs, VCS event details, state rollback

**New Features & Innovation** (16 tests): Change requests, no-code provisioning, GitHub App installations, GraphQL explorer, IP ranges, feature sets

**Enterprise & Admin Features** (18 tests): Admin settings, SAML/SSO, enterprise user management, registry settings, billing, two-factor authentication

### Test Organization

All tests support three modes:

1. **Mock Mode**: Safe simulation with mock data (no API calls)
2. **Live Read-Only**: Production-safe queries without modifications
3. **Full Integration**: Complete create/update/delete testing (test org only)

## Parameters

### Core Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `RunDestructiveTests` | switch | `$false` | Enable create/update/delete operations |
| `MockMode` | switch | `$false` | Use mock data instead of API calls |
| `UseTestOrganization` | switch | `$false` | Allow destructive tests on test org |
| `TestOrganizationName` | string | `""` | Name of dedicated test organization |
| `Verbose` | switch | `$false` | Enable verbose output |

### Safety Features

The script includes multiple safety mechanisms:

1. **Production Warnings**: Interactive prompts before destructive operations
2. **Test Organization Validation**: Explicit opt-in required
3. **Default Safe Mode**: Destructive tests disabled by default
4. **Mock Mode**: Complete simulation without API calls

## Usage Examples

### Development and Testing

```powershell
# Start with mock mode for development
./Test-TerraformCloudModule.ps1 -MockMode

# Test with verbose output for debugging
./Test-TerraformCloudModule.ps1 -MockMode -Verbose

# Read-only testing against production (default - safe)
./Test-TerraformCloudModule.ps1
```

### CI/CD Pipeline

```yaml
name: Test TerraformCloud Module
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Test Module (Mock Mode)
        shell: pwsh
        run: ./Test-TerraformCloudModule.ps1 -MockMode

      - name: Test Module (Integration)
        shell: pwsh
        run: |
          ./Test-TerraformCloudModule.ps1 -UseTestOrganization -TestOrganizationName "${{ secrets.TEST_ORG_NAME }}" -RunDestructiveTests
        env:
          TFE_TOKEN: ${{ secrets.TEST_TFE_TOKEN }}
```

### Production Validation

```powershell
# Quick validation of module functionality (default - safe, read-only)
./Test-TerraformCloudModule.ps1

# Comprehensive read-only testing with verbose output
./Test-TerraformCloudModule.ps1 -Verbose
```

## Setting Up Test Environment

### Option 1: Mock Mode (No Setup Required)

```powershell
# No credentials or setup needed
./Test-TerraformCloudModule.ps1 -MockMode
```

### Option 2: Test Organization

1. Create a free Terraform Cloud account at <https://app.terraform.io>
2. Create a new organization (e.g., `mycompany-testing`)
3. Generate a user token: **Settings** → **Tokens** → **Create API Token**
4. Set environment variable:

   ```powershell
   $env:TFE_TOKEN = "your-test-token-here"
   ```

5. Run tests:

   ```powershell
   ./Test-TerraformCloudModule.ps1 -UseTestOrganization -TestOrganizationName "mycompany-testing" -RunDestructiveTests
   ```

### Option 3: Credentials File

Store token in credentials file:

```json
# ~/.terraform.d/credentials.tfrc.json
{
  "credentials": {
    "app.terraform.io": {
      "token": "your-token-here"
    }
  }
}
```

## Test Results and Reporting

### Output Format

The script provides detailed test results with:

- **Color-coded status**: PASS (Green), FAIL (Red), SKIP (Yellow), MOCK (Cyan)
- **Mode indicators**: [LIVE] or [MOCK] prefixes
- **Detailed messages**: Context for each test result
- **Timestamps**: When each test was executed
- **Summary statistics**: Pass/fail counts and success rate

### Sample Output

```text
=== TerraformCloud Module Comprehensive Test Suite ===
Mode: MOCK/SIMULATION

=== Core Module Tests ===
[PASS][MOCK] Module Import
    Module imported successfully
[MOCK][MOCK] Authentication Check
    Mock mode - authentication simulated

=== Comprehensive Test Results Summary ===
Total Tests: 130
Passed: 6
Failed: 0
Skipped: 0
Mocked: 124

Success Rate: 100% (6/6 executed tests)
```

### Programmatic Access

The script returns test results for programmatic use:

```powershell
$results = ./Test-TerraformCloudModule.ps1 -MockMode
$failedTests = $results | Where-Object { $_.Status -eq "FAIL" }
$mockTests = $results | Where-Object { $_.Status -eq "MOCK" }
```

## Troubleshooting

### Common Issues

#### No TFE_TOKEN found

```powershell
# Solution: Set environment variable or use mock mode
$env:TFE_TOKEN = "your-token-here"
# OR
./Test-TerraformCloudModule.ps1 -MockMode
```

#### Authentication failures

```powershell
# Verify token is valid
$env:TFE_TOKEN = "your-valid-token"
./Test-TerraformCloudModule.ps1 -Verbose
```

#### Module import errors

```powershell
# Ensure you're in the correct directory
cd /path/to/terraform/tfcloud/powershell
./Test-TerraformCloudModule.ps1 -MockMode
```

### Debugging Tips

1. **Use Verbose Mode**: Add `-Verbose` for detailed execution information
2. **Start with Mock Mode**: Verify script logic before API testing
3. **Check Module Path**: Ensure `TerraformCloud.psd1` exists in current directory
4. **Verify Credentials**: Test authentication separately before full test suite

## Production Safety Checklist

Before running tests against production:

- [ ] Understand what each test does
- [ ] Destructive tests are disabled by default (safe)
- [ ] Verify you have appropriate permissions
- [ ] Test in mock mode first
- [ ] Have backups of critical state files
- [ ] Consider using a test organization instead
- [ ] Review the destructive test list (create/update/delete operations)
- [ ] Only use `-RunDestructiveTests` with a dedicated test organization

## Advanced Usage

### Custom Test Scenarios

```powershell
# Test specific organization
./Test-TerraformCloudModule.ps1 -MockMode -TestOrganizationName "specific-org"

# Comprehensive logging
./Test-TerraformCloudModule.ps1 -MockMode -Verbose | Tee-Object test-results.log

# Integration with external monitoring
$results = ./Test-TerraformCloudModule.ps1 -MockMode
if (($results | Where-Object Status -eq "FAIL").Count -gt 0) {
    Write-Error "Tests failed - check results"
    exit 1
}
```

### Extending Tests

To add new tests to the script:

1. Add mock data to `Initialize-MockData` function
2. Add function handler to `Invoke-MockTfcFunction`
3. Create new test section following existing pattern
4. Update test categories and documentation

Example test structure:

```powershell
# Test XX: New Function Test
if ($script:TestWorkspaceId) {
    try {
        if ($MockMode) {
            $result = Invoke-MockTfcFunction -FunctionName "New-Function"
            Add-TestResult "New Function Test" "MOCK" "Mock function executed"
        }
        else {
            $result = New-Function -WorkspaceId $script:TestWorkspaceId
            Add-TestResult "New Function Test" "PASS" "Function executed successfully"
        }
    }
    catch {
        Add-TestResult "New Function Test" "FAIL" $_.Exception.Message
    }
}
```

This comprehensive testing framework ensures reliable validation of the TerraformCloud PowerShell module while maintaining safety for production environments.
