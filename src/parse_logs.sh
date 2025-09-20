#!/usr/bin/env bash

LOGDIR="logs"
OUTDIR="out"
mkdir -p "$LOGDIR" "$OUTDIR"

INPUT_LOG="$LOGDIR/access.log"
OUTPUT_PARSED="$OUTDIR/access_parsed.txt"

if [ ! -f "$INPUT_LOG" ]; then
  echo "ERROR: No existe $INPUT_LOG"
  exit 1
fi

# Extraer: IP - Fecha - Recurso solicitado - Código de respuesta
awk '{print $1, $4, $7, $9}' "$INPUT_LOG" > "$OUTPUT_PARSED"
echo "Log parseado en $OUTPUT_PARSED"

