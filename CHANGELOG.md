# Changelog

## v0.1.0 — 2026-10-24

- Report timestamp, hostname, memory usage, and root filesystem usage.
- Accept a disk threshold from 1 to 100, with 80 as the default.
- Reject invalid arguments and use exit codes 0, 1, 2, and 3.
- Handle failed memory and disk measurement pipelines with `pipefail` and explicit checks.
- Add five automated tests for measurement failures and disk threshold boundaries.
- Allow the test runner to check an alternative script, verified against a pre-fix implementation.
- Run Bash syntax checks and regression tests through GitHub Actions on pushes and pull requests.
- Document usage, test expectations, and known limits.
