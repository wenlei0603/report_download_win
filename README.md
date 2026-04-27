# LSEG Research Next Downloader (Windows)

This repository is the Windows edition of the LSEG Research Next manual download assistant.

It is designed for a human-in-the-loop workflow:

- the script fills company and date filters
- the script triggers search
- you manually inspect results and download reports
- you record status and page counts in the terminal

The repository already includes the task dataset used by the workflow:

- `data/tasks/lseg_request_by_call_2015_2018_end_plus_7d.txt`

## Quick Start

1. Clone the repository.
2. Open a terminal in the repository root.
3. Run:

```powershell
.\setup_windows.bat
```

4. After setup completes, run:

```powershell
.\start_manual_loop.bat
```

## What Setup Does

`setup_windows.bat` will:

- create `.venv`
- install Python dependencies from `requirements.txt`
- create `logs/`
- create `output/`
- create `.browser-profile/`

## Default Files

- Main config: `config/config.yaml`
- Input dataset: `data/tasks/lseg_request_by_call_2015_2018_end_plus_7d.txt`
- Stable status log: `logs/manual_task_status.jsonl`
- Stable progress CSV: `output/manual_task_progress.csv`
- Stable task mapping CSV: `output/task_file_mapping.csv`
- Stable run log: `logs/run_log.jsonl`

## Daily Workflow

Use this for normal work:

```powershell
.\start_manual_loop.bat
```

The launcher will:

- detect Microsoft Edge or Google Chrome
- start the browser with CDP on port `9222` if needed
- reuse the repo-local browser profile in `.browser-profile/`
- launch the manual loop driver

## Per-Task Interaction

The terminal shows a reference prompt window and the actual search window:

- Prompt window: `cc_date .. cc_date + 7d`
- Search window: dataset `window_start .. window_end`

Available status codes:

- `1`: `downloaded`
- `2`: `no_report`
- `3`: `failed`
- `4`: `skip`
- `5`: `special_company_case`

Examples of `special_company_case`:

- privatized
- delisted
- no longer covered because of a structural company change

## Initial LSEG UI Setup

Before processing tasks, prepare the LSEG page manually:

- Contributor: `Morgan Stanley` only
- Country/Region: `USA`
- Industry: none
- Do not enable preferred contributors

The script assumes those global filters remain fixed.

## Resetting Progress

To archive stable logs and restart from the first task:

```powershell
.\init_manual_loop_state.bat
```

You will be asked to type `RESET`.

## Isolated Timestamped Runs

To create a separate set of output files for a one-off batch:

```powershell
.\start_manual_loop_new_run.bat
```

## Advanced Commands

Run the loop directly:

```powershell
$env:PYTHONPATH = (Resolve-Path .deps).Path
.\.venv\Scripts\python.exe scripts\manual_loop_driver.py --config config\config.yaml --day-page-limit 650
```

Start from a specific task:

```powershell
$env:PYTHONPATH = (Resolve-Path .deps).Path
.\.venv\Scripts\python.exe scripts\manual_loop_driver.py --config config\config.yaml --start-from-task T0100 --day-page-limit 650
```

Dry-run task parsing:

```powershell
$env:PYTHONPATH = (Resolve-Path .deps).Path
.\.venv\Scripts\python.exe scripts\lseg_rpa.py --config config\config.yaml --dry-run
```

## Notes

- This repository does not commit `.venv` or browser binaries.
- If the LSEG session expires, log in again in the browser and continue from the terminal.
- `skipped` is not a final status. Skipped tasks appear again in later runs.
- `special_company_case`, `downloaded`, `no_report`, and `task_failed` are treated as final statuses.
