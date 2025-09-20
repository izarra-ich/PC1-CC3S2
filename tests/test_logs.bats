#!/usr/bin/env bats

@test "parse_logs.sh genera archivo PARSED desde access.log" {
  mkdir -p logs
  echo '203.0.113.5 - - [19/Sep/2025:23:00:00 +0000] "GET /home HTTP/1.1" 404 321 "-" "curl/7.81.0"' > logs/access.log

  ./src/parse_logs.sh

  [ -f out/access_parsed.txt ]
  grep "203.0.113.5" out/access_parsed.txt
  grep "/home" out/access_parsed.txt
  grep "404" out/access_parsed.txt
}
