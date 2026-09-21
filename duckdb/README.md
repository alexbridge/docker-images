### Playground DuckDB stack (same domain as `mysql8-big`) for comparing a columnar engine against InnoDB

DuckDB is embedded — there is no server process. The container exists to hold a persistent
database file, seed it once, and serve the built-in DuckDB Web UI.

| | |
| --- | --- |
| Database file | `/data/playground.duckdb` in the `duckdb-data` volume |
| Schema | `APP` — `APPLICATION`, `APPLICATION_CLIENT`, `APPLICATION_DECISION` |
| Web UI | http://localhost:4213 (`SERVICES_DUCKDB_UI_PORT`) |
| Seed size | `DUCKDB_SEED_ROWS` in `.env`, default 10,000,000 applications |

#### Usage

```bash
make start   # build, seed (once), serve the UI
make logs    # follow the seeding progress
make shell   # DuckDB REPL (pauses the UI, restarts it on exit)
make stop    # down -v, drops the volume and the seeded data
```

Seeding runs only when `/data/.seeded` is missing, so a restart keeps the data. `make stop`
removes the volume, so the next `make start` re-seeds from scratch.

#### Notes

- One process may hold the database file at a time, so `make shell` stops the UI container
  first and restarts it when the REPL exits.
- The UI server binds the loopback interface only and offers no bind-host setting, so the
  container runs with `network_mode: host` rather than publishing a port. The UI is reachable
  from this host, not from the LAN. Change the port with `SERVICES_DUCKDB_UI_PORT`.
- Seed scripts in `duckdb/` mirror `mysql8-big/mysql/` row for row, rewritten in DuckDB
  idioms: `range()` instead of the `seq` CROSS JOIN ladder, list indexing instead of `ELT`,
  and only equality-lookup columns get an ART index since zonemaps already prune range scans.
