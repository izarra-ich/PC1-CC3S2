#!/usr/bin/env bash

DOMAIN=${1:-example.com}
OUTDIR="out"
mkdir -p "$OUTDIR"

TXT_FILE="$OUTDIR/dns_${DOMAIN}.txt"
PARSED_FILE="$OUTDIR/dns_${DOMAIN}.parsed"

# Resolver con dig usando TCP
dig +tcp @"8.8.8.8" "$DOMAIN" A > "$TXT_FILE"

# Extraer solo las direcciones IP de la ANSWER SECTION
grep -A100 ";; ANSWER SECTION:" "$TXT_FILE" \
  | grep -v ";;" \
  | awk '{print $5}' \
  | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' \
  > "$PARSED_FILE"

