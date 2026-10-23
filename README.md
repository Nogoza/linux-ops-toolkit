# Linux Ops Toolkit

A hands-on project for learning Linux operations and Bash automation.

Status: initial disk usage checker implemented. Memory reporting and measurement
failure handling are planned next.

## First milestone

Build a command-line tool that reports root filesystem usage and memory usage,
then returns a meaningful exit status when disk usage exceeds a threshold.

## Planned features

- [x] Root filesystem usage report
- [x] Configurable disk usage threshold (default: 80%)
- [x] Threshold argument validation and exit codes 0, 1, and 2
- [ ] Memory, hostname, and timestamp report
- [ ] Measurement failure handling
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

The valid-threshold results depend on the actual disk usage. These manual checks
do not yet verify measurement-command failures or the exact equality boundary.

## Project structure

```text
scripts/       Operational scripts
docs/          Tasks, learning notes, and troubleshooting records
```

## Safety

Use sample data for backup experiments. Keep credentials, private keys, local
configuration, generated logs, and backup archives outside version control.
