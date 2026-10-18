# digib/postgres

A PostgreSQL 18 image with PostGIS 3 and pgvector, published as `ghcr.io/digib/postgres`. Projects use the same image locally, in CI and deployed. Three files: `Dockerfile`, `.github/workflows/publish.yml` (builds for x86 and Arm, checks the extensions, publishes) and `README.md`.

## Public repository

This repository is public. Issues, pull requests, commits and code never name or link the private projects that use the image, or their issues: describe a need in general terms ("a project needs index suggestions").

## Adding an extension

1. Add its package from the PostgreSQL project's apt repository (`postgresql-18-<name>`) to the `Dockerfile`.
2. Add `CREATE EXTENSION <name>;` to the check in `publish.yml`, with a query that shows it works.
3. List it in the README's "What's in it".

Every project and deployment using the image gets it, so add only what's needed.

## Checking locally

```bash
docker build -t postgres:check .
docker run -d --name check -e POSTGRES_PASSWORD=check postgres:check
docker exec check psql -U postgres -v ON_ERROR_STOP=1 -c "CREATE EXTENSION postgis; …"   # the workflow's check
docker rm -f check
```

A pull request runs the same build and check without publishing.

## Tags

`18` is the latest build, `18-YYYYMMDD` one build, unchanged. Builds run on every push to `main` and every Monday. A new PostgreSQL major version is a new tag, never an update of `18`.

## Workflow

- Every change has an issue. Branch from `main` as `GH-<issue>-short_description`.
- Commits: `type(GH-<issue>): Description` (Conventional Commits; the description starts with a capital letter).
- Pull requests: titled `GH-<issue>: Description`, with `Closes #<issue>` and how it was tested.
- Commit, push, open pull requests and create issues only when asked.
