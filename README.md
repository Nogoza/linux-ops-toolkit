# Linux Ops Toolkit

[![Bash CI](https://github.com/Nogoza/linux-ops-toolkit/actions/workflows/bash-ci.yml/badge.svg?branch=main)](https://github.com/Nogoza/linux-ops-toolkit/actions/workflows/bash-ci.yml)

A hands-on project for learning Linux operations and Bash automation.

Version: **v0.1.0**. This first release is a command-line system report with
disk threshold checks, measurement error handling, regression tests, and CI.

## Purpose

Report root filesystem usage, memory usage, hostname, and timestamp. Return a
meaningful exit status so another script or an automation job can use the result.

## Included in v0.1.0

- [x] Root filesystem usage report
- [x] Configurable disk usage threshold (default: 80%)
- [x] Threshold argument validation and exit codes 0, 1, and 2
- [x] Memory, hostname, and timestamp report
- [x] Handle failed memory and disk measurement commands
- [x] Five automated checks covering measurement failures and disk boundaries
- [x] GitHub Actions syntax checks and regression tests on pushes and pull requests

Service availability checks and backup/restore exercises are separate future
labs, outside the scope of this release.

## Learning workflow

Read the task, implement a small change, verify its behavior, document the result,
and commit it. The first task is in [Day 01](docs/day01.md).

## Requirements

- Ubuntu / WSL 2
- Bash, GNU coreutils, procps, awk, and Git

## Usage

Run from the project root:

```bash
bash scripts/health-check.sh
bash scripts/health-check.sh 90
```

The optional threshold must be an integer from 1 to 100 without leading zeros.
The script checks the filesystem mounted at `/`. Under WSL, this is not the
same measurement as Windows C: drive usage.

| Exit code | Meaning |
| --- | --- |
| 0 | Disk usage is below the threshold |
| 1 | Disk usage is at or above the threshold |
| 2 | An invalid threshold or too many arguments were supplied |
| 3 | A memory or disk measurement pipeline failed |

## Automated tests

Run from the project root:

```bash
bash tests/test-health-check.sh
```

The tests use exported Bash functions inside subshells to simulate command
failures and fixed disk readings. Disk boundary checks do not depend on the
machine's actual disk usage.

| Scenario | Expected health-check result | Exit code |
| --- | --- | --- |
| `df` fails | Measurement error, no OK or WARNING | 3 |
| `free` fails | Measurement error, no OK or WARNING | 3 |
| Disk usage 79%, threshold 80% | OK | 0 |
| Disk usage 80%, threshold 80% | WARNING | 1 |
| Disk usage 81%, threshold 80% | WARNING | 1 |

A successful run prints five PASS messages and returns 0. A failed assertion
prints the captured output for diagnosis and returns 1. The tests stop at the
first failed assertion.

An optional first argument selects another health-check implementation:

```bash
bash tests/test-health-check.sh /path/to/health-check.sh
```

Regression verification: testing the pre-fix script from commit `dfa54a0`
failed at the disk measurement test and returned 1. That implementation
incorrectly returned 0 after `df` failed. The current implementation passes
all five checks and the test suite returns 0.

## Continuous integration

[Bash CI](https://github.com/Nogoza/linux-ops-toolkit/actions/workflows/bash-ci.yml)
runs on pushes and pull requests using an Ubuntu 24.04 GitHub-hosted runner.
It checks both Bash files with `bash -n`, then runs the regression tests.
Workflow configuration is in `.github/workflows/bash-ci.yml`.

## Manual verification

Check syntax with `bash -n scripts/health-check.sh`. After each script execution,
run `echo $?` immediately to inspect its exit code.

Observed during the first exercise with root filesystem usage at 3%:

| Threshold / arguments | Observed result | Exit code |
| --- | --- | --- |
| `80` | Successful exit reported by learner | 0 |
| `2` | WARNING | 1 |
| `02` | ERROR | 2 |
| `101` | ERROR | 2 |
| `80 extra` | ERROR | 2 |

The valid-threshold results depend on the actual disk usage.

Memory and disk command failures were also injected separately using exported
Bash functions in subshells. Each function returned 1 in place of the real
`free` or `df` command. In both cases, the script printed the corresponding
measurement error, returned 3, and did not print OK or WARNING.

The 79%, 80%, and 81% boundary cases are verified by the automated tests above.

## Known limits

Successful commands that produce empty or malformed output are not yet
validated. Timestamp and hostname collection do not have explicit failure
handling. Argument validation was checked manually; the automated suite covers
the five scenarios listed above. The report is a single snapshot, not a
continuous monitoring service.

## Project structure

```text
scripts/       Operational scripts
tests/         Automated regression tests
docs/          Tasks, learning notes, and troubleshooting records
.github/       Continuous integration workflow
CHANGELOG.md   Release history
```

See [project summary](docs/project-summary.md) for the learning outcomes and
[changelog](CHANGELOG.md) for the first release scope.

## Safety

Use sample data for backup experiments. Keep credentials, private keys, local
configuration, generated logs, and backup archives outside version control.
