#!/usr/bin/env bats

@test "tools: Verifica que las herramientas requeridas estén disponibles" {
  run make tools
  [ "$status" -eq 0 ]
  [[ "$output" == *"Todas las herramientas están disponibles"* ]]
}