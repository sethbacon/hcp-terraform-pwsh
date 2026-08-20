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

- All GitHub Actions are pinned to full commit SHAs. Some are pinned **in this repository**
  (`.github/workflows/`) and some in the shared workflows this repository calls — see
  *Shared CI workflows* below. Checking only `.github/workflows/` no longer verifies this
  claim on its own, which is the point of recording the relationship.
- Secret scanning + push protection: enabled
- Private vulnerability reporting: enabled
- PSScriptAnalyzer SAST runs on every PR with SARIF upload to the Security tab
- Scheduled weekly security workflow runs the CI matrix plus
  [Legitify](https://github.com/Legit-Labs/legitify) misconfiguration scanning
  and auto-opens an issue on failure
- Releases are gated behind a `gallery` GitHub environment that requires
  manual approval before `Publish-PSResource` runs against PSGallery

## Shared CI workflows

Part of this repository's CI is **defined in another repository** — [`4cloudguru/shared-workflows`](https://github.com/4cloudguru/shared-workflows) — and called from `.github/workflows/`. That is a real supply-chain relationship, and it is recorded here so an audit of this repository does not stop at this repository's own tree.

**What runs, and where it is pinned.** Each caller in `.github/workflows/` names the shared workflow on its `uses:` line, pinned to a full 40-hex commit SHA with a trailing comment naming the release that SHA is. The tag is a label; the SHA is what runs. An unlabelled SHA is rejected by the workflow-hardening gate, because a bare 40-hex ref cannot be reviewed or updated deliberately.

**Why the pins have to agree across repositories.** A shared definition drifts differently from a duplicated file: every repository looks like it is using "the shared one" while sitting on different commits, which is *harder* to see than divergent files, not easier. A signature in `security-orchestration` (`shared-workflow-pin-parity`) reports **disagreement** between callers of the same shared workflow — it reports disagreement rather than staleness, because a repository deliberately held back is a decision while N repositories disagreeing without anyone deciding is drift.

**What the shared repository is itself protected by.** Its `main` requires its own zizmor and actionlint checks with `enforce_admins` enabled, restricts which third-party actions may run to an explicit allowlist, issues a read-only default `GITHUB_TOKEN`, and runs the workflow-hardening gate against itself.

**What this repository still controls.** Triggers, concurrency, and the secrets it passes. Secrets are passed **by name** — never `secrets: inherit`, which would forward every secret in this repository to a workflow owned by someone else. Any `vars.*` a shared workflow reads resolve against **this** repository, so credentials and their installation scope do not move.
