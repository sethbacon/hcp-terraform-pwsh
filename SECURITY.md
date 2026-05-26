<!-- markdownlint-disable MD013 -->
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

Security fixes are released as patch versions on top of the latest minor.
Older minors do not receive backports.

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

Report privately using one of these channels:

1. **GitHub Security Advisories** — use the "Report a vulnerability" button on the
   [Security tab](../../security/advisories) of this repository. Private
   vulnerability reporting is enabled.
2. **Email** — contact the maintainer listed in
   [.github/CODEOWNERS](.github/CODEOWNERS).

### What to Include

- Description of the vulnerability
- Steps to reproduce (proof of concept if possible)
- Affected module version (`Get-Module TerraformCloud | Select-Object Version`)
- PowerShell edition and version (`$PSVersionTable`)
- Potential impact

### Response Timeline

- **Acknowledgement:** within 48 hours
- **Initial assessment:** within 5 business days
- **Fix or mitigation:** targeting 30 days for critical/high severity

### Disclosure Policy

We follow [coordinated disclosure](https://en.wikipedia.org/wiki/Coordinated_vulnerability_disclosure).
Reporters will be credited in the release notes unless anonymity is requested.

## Security Practices

- **Static analysis:** PSScriptAnalyzer runs on every PR; results are uploaded
  as SARIF and surfaced in the GitHub Security tab.
- **Test coverage:** Pester suite executes on Windows / Linux / macOS across
  PowerShell 5.1 and 7.x.
- **Build provenance:** every PSGallery release is accompanied by a
  [GitHub Artifact Attestation](https://github.com/actions/attest-build-provenance)
  for the module zip. Verify with:

  ```bash
  gh attestation verify TerraformCloud-vX.Y.Z.zip --repo sethbacon/hcp-terraform-pwsh
  ```

- **Token handling:** the module never logs the value of `$env:TFE_TOKEN` or
  tokens read from `~/.terraform.d/credentials.tfrc.json`. Sensitive values
  passed to PSGallery are wired through GitHub Actions environment secrets.

## Repository Hardening

The following GitHub repository controls protect the release pipeline and
supply chain:

### Branch Protection (`main`)

- Required status checks (strict — branch must be up-to-date with `main`):
  `Build Module`, `Code Analysis`, `Test (PS 5.1-windows-latest)`,
  `Test (PS 7.x-ubuntu-latest)`, `Test (PS 7.x-windows-latest)`,
  `Test (PS 7.x-macos-latest)`, `Conventional PR Title`
- Required pull request reviews: 1 approving review, dismiss stale reviews,
  require code-owner review
- Required conversation resolution: yes
- Force pushes: blocked; branch deletion: blocked

### Tag Protection

- Release tags matching `v[0-9]+.[0-9]+.[0-9]+*` are protected from deletion,
  non-fast-forward updates, and arbitrary updates via a repository ruleset.

### Merge Strategy

- **Squash merge and merge-commit allowed**; rebase merge disabled
- Delete branch on merge: enabled

### Dependency Management

- Dependabot vulnerability alerts: enabled
- Dependabot automated security fixes: enabled
- Dependabot version updates configured via `.github/dependabot.yml`
  (GitHub Actions, biweekly)

### Code Ownership

- `.github/CODEOWNERS` requires explicit owner review for all paths

### Supply-Chain Security

- All GitHub Actions pinned to full commit SHAs
- Secret scanning + push protection: enabled
- Private vulnerability reporting: enabled
- PSScriptAnalyzer SAST runs on every PR with SARIF upload to the Security tab
- Scheduled weekly security workflow runs the CI matrix plus
  [Legitify](https://github.com/Legit-Labs/legitify) misconfiguration scanning
  and auto-opens an issue on failure
- Releases are gated behind a `gallery` GitHub environment that requires
  manual approval before `Publish-PSResource` runs against PSGallery
