#!/usr/bin/env bash
set -euo pipefail

COUNT="${1:-20}"
LOG_FILE="${2:-samples/logs/app.log}"

mkdir -p "$(dirname "$LOG_FILE")"

urls=("/api/orders" "/api/payments" "/health" "/api/users" "/")
methods=("GET" "POST" "PUT")
clients=("8.8.8.8" "1.1.1.1" "203.0.113.10" "9.9.9.9")

for i in $(seq 1 "$COUNT"); do
  url="${urls[RANDOM % ${#urls[@]}]}"
  method="${methods[RANDOM % ${#methods[@]}]}"
  client="${clients[RANDOM % ${#clients[@]}]}"
  status=$(( (RANDOM % 10 < 2) ? 500 + (RANDOM % 50) : 200 + (RANDOM % 100) ))
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  printf '{"@timestamp":"%s","message":"%s %s","status":%d,"client_ip":"%s","service":"web"}\n' "$ts" "$method" "$url" "$status" "$client" >> "$LOG_FILE"
done

echo "Generated $COUNT log lines into $LOG_FILE"
