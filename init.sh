#!/usr/bin/env bash
set -euo pipefail

DUMP=/workspace/olist_db.dump
ADD_FK=/workspace/add_fk.sql
DROP_INDEX=/workspace/drop_index.sql
ADD_INDEX=/workspace/add_index.sql

log() { echo "[$(date '+%H:%M:%S')] $*"; }

restore_and_setup() {
  local HOST="$1"
  local LABEL="$2"
  local WITH_INDEX="$3"

  log "===================================================="
  log "[$LABEL] START (host=$HOST)"
  log "===================================================="

  log "[$LABEL] Step 0: reset schema public"
  psql -v ON_ERROR_STOP=1 -h "$HOST" -U postgres -d postgres \
    -c "DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public;"

  log "[$LABEL] Step 1: pg_restore $DUMP"
  pg_restore -h "$HOST" -U postgres -d postgres \
    --no-owner --no-privileges --clean --if-exists \
    -v "$DUMP"

  log "[$LABEL] Step 2: psql $ADD_FK"
  psql -v ON_ERROR_STOP=1 -h "$HOST" -U postgres -d postgres -f "$ADD_FK"

  log "[$LABEL] Step 3: psql $DROP_INDEX"
  psql -v ON_ERROR_STOP=1 -h "$HOST" -U postgres -d postgres -f "$DROP_INDEX"

  if [ "$WITH_INDEX" = "yes" ]; then
    log "[$LABEL] Step 4: psql $ADD_INDEX"
    psql -v ON_ERROR_STOP=1 -h "$HOST" -U postgres -d postgres -f "$ADD_INDEX"
  fi

  log "[$LABEL] Verifikasi jumlah tabel:"
  psql -h "$HOST" -U postgres -d postgres -tAc \
    "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';"

  log "[$LABEL] DONE"
}

log "=== Menunggu DB siap ==="
until pg_isready -h db_dengan_index -U postgres -d postgres; do sleep 2; done
until pg_isready -h db_tanpa_index  -U postgres -d postgres; do sleep 2; done
sleep 3

restore_and_setup db_dengan_index "DB_DENGAN_INDEX" "yes"
restore_and_setup db_tanpa_index  "DB_TANPA_INDEX"  "no"

log "===================================================="
log "=== SEMUA PROSES BERHASIL DISELESAIKAN ==="
log "===================================================="