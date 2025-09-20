#!/usr/bin/env bats

@test "tools: Verifica que las herramientas requeridas estén disponibles" {
  run make tools
  [ "$status" -eq 0 ]
  [[ "$output" == *"Todas las herramientas están disponibles"* ]]
}

@test "run: Ejecuta app Flask y guarda respuestas HTTP" {
  run make run
  [ "$status" -eq 0 ]
  [ -f "out/http.log" ]
  grep -q "status" out/http.log
}

