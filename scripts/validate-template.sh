#!/usr/bin/env sh
set -eu

export ANSIBLE_ROLES_PATH="${ANSIBLE_ROLES_PATH:-../iac-modules/ansible/roles:.ansible/roles}"
export ANSIBLE_COLLECTIONS_PATH="${ANSIBLE_COLLECTIONS_PATH:-.ansible/collections}"

find playbooks -maxdepth 2 -type f -name '*.yml' | sort | while IFS= read -r playbook; do
  ansible-playbook --syntax-check -i inventory/templates/personal/hosts.yml "$playbook"
done
