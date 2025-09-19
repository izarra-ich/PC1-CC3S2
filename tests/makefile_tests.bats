#!/usr/bin/env bats

@test "tools: Verifica que las herramientas requeridas estén disponibles" {
  run make tools
  [ "$status" -eq 0 ]
  [[ "$output" == *"Todas las herramientas están disponibles"* ]]
}

@test "run: Ejecuta scripts y genera archivos en out/" {
  run make run
  [ "$status" -eq 0 ]
  [ -f "out/http.log" ]
  [ -f "out/dns.log" ]
  grep -q "Simulación de chequeo HTTP" out/http.log
  grep -q "Simulación de chequeo DNS" out/dns.log
}
