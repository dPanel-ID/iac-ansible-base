#!/usr/bin/env sh
set -eu

mkdir -p .ansible/roles

find playbooks -name '*.yml' -print0 | xargs -0 awk '
  /role:/ {
    role = $0
    sub(/^.*role:[[:space:]]*/, "", role)
    sub(/[[:space:]]*#.*/, "", role)
    gsub(/["'\''"]/, "", role)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", role)
    if (role != "") {
      print role
    }
  }
' | sort -u | while IFS= read -r role; do
  mkdir -p ".ansible/roles/${role}/tasks"
  printf '%s\n' '---' > ".ansible/roles/${role}/tasks/main.yml"
done
