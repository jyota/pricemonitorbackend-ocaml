export PGHOST=127.0.0.1
export PGPORT=5433
export PGUSER=sa
export PGPASSWORD=data1
export PGDATABASE=pricing_monitor_www
dune exec ./main.exe -- -p 9000 -d

