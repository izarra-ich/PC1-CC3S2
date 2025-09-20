#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

OUTDIR="${OUTDIR:-out}"
APP_PORT="${PORT:-8080}"
APP_URL="http://127.0.0.1:${APP_PORT}"

# Número de últimas peticiones a analizar (por defecto 10)
N="${1:-10}"

mkdir -p "$OUTDIR"

log() {
  echo "[$(date --iso-8601=seconds)] $*" | tee -a "$OUTDIR/analyzer.log"
}

# Generar peticiones correctas e incorrectas a la app
send_requests() {
  log "Enviando peticiones correctas e incorrectas al app..."
  curl -s -o /dev/null -w "%{http_code}\n" -X GET    "$APP_URL/"        >> "$OUTDIR/codes.txt"  # 200
  curl -s -o /dev/null -w "%{http_code}\n" -X POST   "$APP_URL/"        >> "$OUTDIR/codes.txt"  # 200
  curl -s -o /dev/null -w "%{http_code}\n" -X PUT    "$APP_URL/123"     >> "$OUTDIR/codes.txt"  # 200
  curl -s -o /dev/null -w "%{http_code}\n" -X DELETE "$APP_URL/123"     >> "$OUTDIR/codes.txt"  # 200
  curl -s -o /dev/null -w "%{http_code}\n" -X PATCH  "$APP_URL/"        >> "$OUTDIR/codes.txt"  # 405
  curl -s -o /dev/null -w "%{http_code}\n" -X GET    "$APP_URL/unknown" >> "$OUTDIR/codes.txt"  # 404
  curl -s -o /dev/null -w "%{http_code}\n" -X GET    "$APP_URL/user"    >> "$OUTDIR/codes.txt"  # 404
  curl -s -o /dev/null -w "%{http_code}\n" -X PUT    "$APP_URL/abc"     >> "$OUTDIR/codes.txt"  # 404 
  curl -s -o /dev/null -w "%{http_code}\n" -X DELETE "$APP_URL/"        >> "$OUTDIR/codes.txt"  # 405 
  curl -s -o /dev/null -w "%{http_code}\n" -X GET    "$APP_URL/unknown" >> "$OUTDIR/codes.txt"  # 404
}

# Analiza logs de app, últimas N peticiones
analyze_logs() {
  log "Analizando las últimas $N peticiones..."

  # Filtrar solo las líneas que corresponden a requests HTTP (las de acceso)
  grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ - - \[.*\] ".*" [0-9]{3} -' "$OUTDIR/app_logs.txt" \
    | tail -n "$N" \
    > "$OUTDIR/last_requests.txt"

  local ok_count error_count
  # Extraer el código HTTP y contarlos
  ok_count=$(awk '{code=$9; if(code ~ /^2/) print code}' "$OUTDIR/last_requests.txt" | wc -l)
  error_count=$(awk '{code=$9; if(code ~ /^[45]/) print code}' "$OUTDIR/last_requests.txt" | wc -l)

  echo "Resumen de las últimas $N peticiones:" | tee -a "$OUTDIR/analyzer.log"
  echo "Request exitosos: $ok_count" | tee -a "$OUTDIR/analyzer.log"
  echo "Request con errores: $error_count" | tee -a "$OUTDIR/analyzer.log"
}

main() {
  : > "$OUTDIR/codes.txt"   # limpiar códigos anteriores
  send_requests
  analyze_logs
}

main "$@"
