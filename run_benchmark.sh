#!/usr/bin/env bash
# ============================================================
# run_benchmark.sh
# Menjalankan pgbench pada DB indexed (5433) & non-indexed (5434)
# lalu mencetak perbandingan TPS & latency.
# ============================================================
set -euo pipefail

# ---- Konfigurasi (bisa dioverride via env) ----
CLIENTS=${CLIENTS:-10}      # jumlah koneksi paralel
JOBS=${JOBS:-4}             # jumlah thread
DURATION=${DURATION:-60}    # detik per run
SCALE_RUNS=${SCALE_RUNS:-1} # berapa kali ulang (ambil terbaik)

PGBENCH_IMAGE=${PGBENCH_IMAGE:-postgres:17-alpine}
DB_USER=postgres
DB_PASS=rahasia123
DB_NAME=postgres

# Pastikan pgbench script ada
[[ -f bench.sql ]] || { echo "bench.sql tidak ditemukan di $PWD"; exit 1; }

run_bench() {
  local port=$1
  local label=$2
  local out="bench_${label}.txt"

  echo
  echo "============================================================"
  echo " Benchmark: ${label^^}"
  echo " port=$port  clients=$CLIENTS  jobs=$JOBS  duration=${DURATION}s"
  echo "============================================================"

  docker run --rm --network host \
    -v "$PWD":/w -w /w \
    -e PGPASSWORD="$DB_PASS" \
    "$PGBENCH_IMAGE" \
    pgbench \
      -h 127.0.0.1 -p "$port" -U "$DB_USER" -d "$DB_NAME" \
      -c "$CLIENTS" -j "$JOBS" -T "$DURATION" \
      -n \
      -f /w/bench.sql \
      --progress 10 \
    2>&1 | tee "$out"
}

# Jalankan berulang, simpan log terbaik
for run in $(seq 1 "$SCALE_RUNS"); do
  run_bench 5433 "indexed_run${run}"
  run_bench 5434 "nonindexed_run${run}"
done

# Ambil nilai numerik terakhir
extract() {
  local file=$1
  local key=$2
  grep -E "^${key}" "$file" 2>/dev/null | tail -1 | awk '{print $NF}' || echo "N/A"
}

echo
echo "============================================================"
echo " RINGKASAN PERBANDINGAN"
echo "============================================================"
printf "%-25s | %-12s | %-15s | %-12s\n" "RUN" "TPS" "Latency (ms)" "Failed"
printf -- "--------------------------+--------------+-----------------+-------------\n"

for f in bench_indexed_run*.txt bench_nonindexed_run*.txt; do
  [[ -f "$f" ]] || continue
  local_name=$(basename "$f" .txt)
  tps=$(grep -E '^tps' "$f" | tail -1 | awk '{print $3}')
  lat=$(grep -E '^latency average' "$f" | tail -1 | awk '{print $4}')
  fail=$(grep -E 'number of failed transactions' "$f" | tail -1 | awk '{print $NF}' || echo 0)
  printf "%-25s | %-12s | %-15s | %-12s\n" "$local_name" "${tps:-N/A}" "${lat:-N/A}" "${fail:-0}"
done

echo
echo "Plan per query tersimpan di:"
echo "  plan_indexed.txt / plan_nonindexed.txt (buat sendiri dari queries.sql)"