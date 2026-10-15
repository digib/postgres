# PostgreSQL 18 with PostGIS 3 and pgvector. The official postgres image is multi-architecture
# (x86 and Arm) and Debian-based, with the PostgreSQL project's apt repository configured, whose
# extension packages follow each release.
FROM postgres:18-trixie

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    postgresql-18-postgis-3 \
    postgresql-18-postgis-3-scripts \
    postgresql-18-pgvector \
  && rm -rf /var/lib/apt/lists/*
