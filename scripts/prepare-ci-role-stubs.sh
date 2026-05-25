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
  /ansible\.builtin\.include_role:/ {
    include_role = 1
    next
  }
  include_role && /name:/ {
    role = $0
    sub(/^.*name:[[:space:]]*/, "", role)
    sub(/[[:space:]]*#.*/, "", role)
    gsub(/["'\''"]/, "", role)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", role)
    if (role != "") {
      print role
    }
    include_role = 0
  }
' | sort -u | while IFS= read -r role; do
  mkdir -p ".ansible/roles/${role}/tasks"
  printf '%s\n' '---' > ".ansible/roles/${role}/tasks/main.yml"
done
