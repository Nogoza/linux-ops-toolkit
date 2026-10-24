# Linux Ops Toolkit

A hands-on project for learning Linux operations and Bash automation.

Status: disk, memory, hostname, and timestamp reporting implemented.
Failures in memory and disk measurement pipelines return exit code 3.

## First milestone

Build a command-line tool that reports root filesystem usage and memory usage,
then returns a meaningful exit status when disk usage exceeds a threshold.

## Planned features

- [x] Root filesystem usage report
- [x] Configurable disk usage threshold (default: 80%)
- [x] Threshold argument validation and exit codes 0, 1, and 2
- [x] Memory, hostname, and timestamp report
- [x] Handle failed memory and disk measurement commands
- [ ] Service availability checks
- [ ] Backup creation and verified restoration
- [ ] Troubleshooting notes and reproducible examples

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

The tests simulate `df` and `free` failures separately using exported Bash
functions inside subshells. Each test checks that the health-check script
returns 3 and does not print an OK or WARNING result.

A successful run prints two PASS messages and returns 0. A failed assertion
prints the captured output for diagnosis and returns 1. The tests stop at the
first failed assertion.

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

The exact equality boundary has not yet been tested. Successful commands that
produce empty or malformed output are not yet validated by these checks.

## Project structure

```text
scripts/       Operational scripts
tests/         Automated regression tests
docs/          Tasks, learning notes, and troubleshooting records
```

## Safety

Use sample data for backup experiments. Keep credentials, private keys, local
configuration, generated logs, and backup archives outside version control.
