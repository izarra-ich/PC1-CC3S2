#!/usr/bin/env bats

# Test para dns_check.sh

setup() {
  # Limpiar carpeta out antes de cada test
  rm -rf out
  mkdir -p out
}

@test "dns_check.sh genera archivo TXT para example.com" {
  export DNS_SERVER=8.8.8.8
  export TARGETS="example.com"
  ./src/dns_check.sh

  [ -f out/dns_example.com.txt ]
  [ -s out/dns_example.com.txt ] # archivo no vacío
}

@test "dns_check.sh genera archivo PARSED para example.com" {
  export DNS_SERVER=8.8.8.8
  export TARGETS="example.com"
  ./src/dns_check.sh

  [ -f out/dns_example.com.parsed ]
  [ -s out/dns_example.com.parsed ] # archivo no vacío
}

