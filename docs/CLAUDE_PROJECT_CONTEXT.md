# MetrikFlow Integration — Claude Instructions

## Project purpose

This repository contains the Apache Hop ETL project used to prepare monthly
data files for Metrikflow carbon-footprint reporting.

Current and planned data sources include:

- Sage X3 via SQL Server
- RENTRI via REST APIs
- CARL via REST APIs
- other sources as required

The primary output is a set of local CSV files conforming to Metrikflow
import layouts.

SFTP delivery is a later shared delivery phase.
Local file generation, validation and troubleshooting come first.

## Current technology

- Apache Hop 2.18.1
- Java 21 for Apache Hop
- Windows development workstation
- Git repository
- Hop project: `metrikflow`
- development environment: `development`
- current integration branch: `migrate-to-apache-hop`

Apache Hop GUI is launched through:

`scripts/start-hop-gui.ps1`

Do not replace Apache Hop with Python or another ETL framework unless explicitly requested.

## Execution topology

Development and authoring are performed on the Windows laptop.

The authoritative Apache Hop execution environment is the Linux server
`Engraulis`.

The laptop may run Apache Hop GUI for development, inspection and local tests,
but production-like pipeline and workflow execution must target Engraulis.

Changes are transferred through Git.

Do not assume that a pipeline which runs locally is deployed until it has been
validated on Engraulis.

Runtime secrets, server configuration, execution logs and production outputs
should remain on Engraulis whenever possible.

Claude Desktop runs on the Windows laptop. It must not assume that local
execution represents the authoritative runtime environment.

Interaction with Engraulis should use controlled operations rather than
unrestricted remote shell access whenever practical.

## Architecture principles

Prefer:

- simplicity
- reliability
- maintainability
- native Apache Hop capabilities
- small reusable pipelines and workflows
- explicit configuration
- reproducible local output

Avoid:

- unnecessary custom code
- unnecessary frameworks
- microservices
- Kubernetes
- Airflow
- web applications
- reinventing capabilities already provided by Apache Hop

This is a monthly batch integration.

## Repository areas

- `pipelines/` — Apache Hop pipelines (`.hpl`)
- `workflows/` — Apache Hop workflows (`.hwf`)
- `sql/` — SQL used by source extractions
- `metadata/` — project metadata
- `docs/` — technical and functional documentation
- `scripts/` — project helper scripts
- `runtime/output/` — generated CSV files
- `runtime/logs/` — execution logs
- `runtime/archive/` — retained historical output when applicable
- `runtime/rejected/` — rejected/invalid output

## Secrets

Never read, expose, print, copy, commit or request secret values.

In particular:

- `secrets/local.env` contains Sage X3 credentials
- private keys
- certificates
- `.p12` / `.pfx`
- API tokens
- passwords

must remain outside Claude-visible working material whenever possible.

Do not add secrets to Git.

## Git discipline

Before modifying anything:

1. inspect the existing implementation;
2. preserve existing conventions where reasonable;
3. explain the intended change;
4. make the smallest coherent change;
5. validate the result;
6. inspect the resulting diff.

Do not:

- commit
- push
- merge
- reset
- force-push
- delete existing work
- change branches

unless explicitly instructed.

The working tree may contain unfinished local work.
Never assume an untracked file can be deleted.

## Current X3 status

Apache Hop connectivity to Sage X3 SQL Server has already been validated.

Existing known pipelines include:

- `hello-hop.hpl`
- `x3-connection-test.hpl`

There is also provisional work for:

- `x3-s31-purchased-goods.hpl`

X3 SQL supplied by users/colleagues may be provisional.
Do not invent accounting filters or business rules.

Monthly date windows should prefer half-open intervals:

`>= PERIOD_FROM`
`< PERIOD_TO`

where `PERIOD_TO` is the first day of the following month.

## Current RENTRI priority

RENTRI is currently the highest-priority unknown integration.

Do not assume RENTRI semantics from field names.

For RENTRI work:

1. study official RENTRI documentation;
2. verify authentication and endpoints;
3. obtain and preserve representative API responses;
4. document the mapping;
5. only then implement Apache Hop extraction;
6. validate local files before automating delivery.

Postman is a development and diagnostic tool, not part of the final production ETL.

The intended RENTRI flow is:

RENTRI API
→ raw response
→ normalized staging data
→ mapping/aggregation
→ Metrikflow CSV
→ local validation
→ SFTP delivery later

## Metrikflow waste CSV layout

The required waste output currently contains:

- CER CODE
- Waste Category
- Waste Quantity
- Unit:Waste Quantity
- Treatment name 1
- Treatment rate percentage 1
- Treatment name 2
- Treatment rate percentage 2
- Treatment name 3
- Treatment rate percentage 3

Do not invent Waste Category mappings or treatment mappings.
Unknown mappings must be explicitly documented as unresolved.

## Output policy

Generated CSV files are intentionally retained locally for:

- validation
- troubleshooting
- auditability
- comparison with source data
- test delivery to Metrikflow by email

Do not automatically delete generated files after processing.

Prefer:

- UTF-8
- semicolon-separated CSV
- headers
- deterministic filenames
- explicit validation before delivery

## SFTP

SFTP is deliberately deferred.

It will eventually be implemented as a shared delivery component reused by
X3, RENTRI, CARL and other Metrikflow flows.

Do not implement or modify SFTP unless explicitly requested.

## Change philosophy

Keep it simple.

Do not reinvent the wheel.

Prefer a standard Apache Hop transform or workflow action over custom scripts
when it satisfies the requirement.

When uncertain about source-system semantics, stop and document the uncertainty
rather than inventing an answer.
