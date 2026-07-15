# MetrikFlow Integration — Claude Code Instructions

## Project purpose

This repository contains a monthly Python batch integration that extracts ESG data from:

- Sage X3 via SQL Server
- CARL via REST APIs
- RENTRI via REST APIs

It validates and transforms the data into semicolon-separated CSV files and uploads them to an FTP or SFTP server.

The software runs on Windows Server through Windows Task Scheduler.

## Architectural constraints

Prefer simplicity, reliability and maintainability.

Do not introduce:

- microservices
- web applications
- REST APIs
- containers unless explicitly requested
- Kubernetes
- Airflow
- enterprise ETL platforms
- unnecessary frameworks
- unnecessary abstraction layers

This is a monthly batch process, not a continuously running service.

## Runtime

- Python 3.14 during initial development
- Windows and PowerShell
- Entry point: `python -m app.main`
- Git branch: `main`

Do not change the supported Python version without explicit approval.

## Code organization

Each module must have a single responsibility:

- `app/main.py`: batch orchestration
- `app/config.py`: configuration loading and validation
- `app/x3.py`: Sage X3 extraction
- `app/carl.py`: CARL API integration
- `app/rentri.py`: RENTRI API integration
- `app/csv_export.py`: CSV generation
- `app/ftp_upload.py`: FTP/SFTP transfer
- `app/state.py`: SQLite execution state
- `sql/`: external SQL query files

Do not place SQL queries directly inside Python unless they are trivial.

## Coding rules

- Use explicit, readable Python.
- Prefer standard-library solutions where reasonable.
- Avoid clever or speculative abstractions.
- Use type hints.
- Use `pathlib.Path` instead of manual path concatenation.
- Use `logging`, never `print`, in application code.
- Never log passwords, tokens, connection strings or personal data.
- Every HTTP request must have an explicit timeout.
- Retry only transient failures.
- Fail clearly on authentication, validation and configuration errors.
- Preserve the original exception context when raising application errors.
- Write CSV files using UTF-8, semicolon separator and headers.
- Write files to a temporary path before final atomic rename.
- Generated data, logs, archives, databases and `.env` files must not be committed.

## Change discipline

Before modifying code:

1. inspect the relevant files;
2. explain the proposed change briefly;
3. identify risks or assumptions;
4. make the smallest coherent change;
5. run the relevant checks;
6. show the resulting Git diff.

Do not commit, push, force-push, reset, delete files or rewrite Git history unless explicitly instructed.

Do not install dependencies without explaining why they are needed.

Do not change unrelated files.

## Testing

For every non-trivial feature:

- add or update tests;
- test success and failure paths;
- avoid real calls to production systems;
- mock external APIs and file transfers;
- use temporary directories for filesystem tests.

## Current priority

The current priority is establishing the development environment and creating a minimal executable project skeleton.

Do not implement X3, CARL, RENTRI or FTP integration until explicitly requested.