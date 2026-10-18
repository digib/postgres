# digib/postgres

PostgreSQL 18 with PostGIS 3, pgvector and hypopg, the same image locally, in CI and deployed.

```bash
docker pull ghcr.io/digib/postgres:18
```

## What's in it

- **[PostgreSQL 18](https://hub.docker.com/_/postgres)**, from the official `postgres:18-trixie` image: Debian, for x86 and Arm
- **[PostGIS 3](https://postgis.net/)**, with its topology and Tiger geocoder extensions (`postgresql-18-postgis-3`, `postgresql-18-postgis-3-scripts`)
- **[pgvector](https://github.com/pgvector/pgvector)** (`postgresql-18-pgvector`)
- **[hypopg](https://hypopg.readthedocs.io/)** (`postgresql-18-hypopg`): hypothetical indexes, to see what an index would do without building it
- PostgreSQL's own extensions, such as `pg_trgm`, `fuzzystrmatch` and `pg_stat_statements` (statistics per query), which the image loads at startup (`shared_preload_libraries`). A project that sets its own `command` or `shared_preload_libraries` replaces that and adds `pg_stat_statements` to its own list.

Extensions come from the PostgreSQL project's apt repository, which follows each release. A project creates the ones it uses, in a migration or an init script:

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;
```

## Tags

| Tag | |
| --- | --- |
| `18` | The latest build, with PostgreSQL's and the extensions' latest fixes |
| `18-YYYYMMDD` | One build, unchanged: to pin to it, or to go back to it |

The image is built on every push to `main` and every Monday, so fixes arrive without changes here. A pull request builds and checks it without publishing.

## After an update

A newer extension version is installed in the image, but an existing database keeps the old one until it's updated:

```sql
SELECT extname, extversion, (SELECT default_version FROM pg_available_extensions WHERE name = extname) AS available FROM pg_extension;
ALTER EXTENSION vector UPDATE;
SELECT postgis_extensions_upgrade();
```

A new PostgreSQL major version (19) is a new tag and a dump and restore (or `pg_upgrade`), never an update of `18`.

## Adding an extension

Add its package to the `Dockerfile` and a `CREATE EXTENSION` to the check in `.github/workflows/publish.yml`, open a pull request, and list it above. Everyone using the image gets it, so add only what's needed.
