# Contributing

## Commit convention

All commits and PR titles must follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```
type: short description (50 chars max)
```

| Type | When to use |
|------|-------------|
| `feat` | New cmdlet or new parameter on an existing cmdlet |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Restructure without changing behavior |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `ci` | CI/CD workflow changes |
| `chore` | Dependency bumps, housekeeping |
| `deps` | Dependency updates |
| `security` | Security fix or hardening |

The PR title is what ends up in the changelog — write it as a clear, reader-facing statement.

## Development workflow

1. Create a branch from `main`: `git checkout -b feat/my-feature`
2. Make changes and run the local quality gate:

   ```powershell
   ./Build-Module.ps1 -SkipTests
   Import-Module ./Output/TerraformCloud/TerraformCloud.psd1 -Force
   ./Tests/Invoke-AllTests.ps1 -TestType Unit
   ```

3. Open a PR to `main` with a conventional-commit title.
4. CI runs automatically: build → unit tests (Ubuntu/Windows/macOS × PS 5.1/7.x) → PSScriptAnalyzer.
5. Merge when CI passes and the PR is approved.

## Release process

Releases are fully automated via [release-please](https://github.com/googleapis/release-please):

1. Merge conventional-commit PRs to `main` — release-please accumulates them.
2. release-please opens a **Release PR** that bumps `Build-Module.ps1` (`ModuleVersion`) and updates `CHANGELOG.md`.
3. Review and merge the Release PR. release-please creates a draft GitHub Release and pushes the `vX.Y.Z` tag.
4. The `release.yml` workflow fires on the tag: CI gate → build → version check → publish to PowerShell Gallery → publish GitHub Release.

**Required secrets/variables:**

| Name | Type | Purpose |
|------|------|---------|
| `NUGET_API_KEY` | Secret | PowerShell Gallery API key |
| `RELEASE_DISPATCH_APP_ID` | Variable | GitHub App client ID for release-please |
| `RELEASE_DISPATCH_APP_KEY` | Secret | GitHub App private key for release-please |
| `TFE_TOKEN` | Secret | HCP Terraform token (integration tests only — optional) |

The `gallery` environment (Settings → Environments) should have at least one required reviewer so every PSGallery publish gets human approval.

## Testing

```powershell
# Unit tests only (fast, no network)
./Tests/Invoke-AllTests.ps1 -TestType Unit -Coverage

# Integration tests (requires TFE_TOKEN env var)
./Tests/Invoke-AllTests.ps1 -TestType Integration

# PSScriptAnalyzer
Import-Module PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path ./Output/TerraformCloud/TerraformCloud.psm1 -Recurse -Settings ./.psscriptanalyzer.psd1
```

## Adding a new cmdlet

1. Create `src/Public/Verb-TfcNoun.ps1` (one function per file).
2. Run `./Build-Module.ps1 -SkipTests` — the build script discovers and exports all public functions automatically.
3. Add Pester tests in `Tests/`.
4. Open a PR with title `feat: add Verb-TfcNoun`.
