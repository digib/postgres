# PostgreSQL 18 with PostGIS 3, pgvector and hypopg. The official postgres image is multi-architecture
# (x86 and Arm) and Debian-based, with the PostgreSQL project's apt repository configured, whose
# extension packages follow each release.
FROM postgres:18-trixie

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    postgresql-18-postgis-3 \
    postgresql-18-postgis-3-scripts \
    postgresql-18-pgvector \
    postgresql-18-hypopg \
  && rm -rf /var/lib/apt/lists/*

# pg_stat_statements (statistics per query) works only when loaded at startup. A project that sets
# its own command or shared_preload_libraries replaces this and adds it to its own list.
CMD ["postgres", "-c", "shared_preload_libraries=pg_stat_statements"]
