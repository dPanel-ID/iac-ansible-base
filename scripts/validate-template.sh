#!/usr/bin/env sh
set -eu

export ANSIBLE_ROLES_PATH="${ANSIBLE_ROLES_PATH:-../iac-modules/ansible/roles:.ansible/roles}"
export ANSIBLE_COLLECTIONS_PATH="${ANSIBLE_COLLECTIONS_PATH:-.ansible/collections}"

ansible-playbook --syntax-check -i inventory/templates/personal/hosts.yml playbooks/setup.yml

for playbook in playbooks/modules/*.yml; do
  ansible-playbook --syntax-check -i inventory/templates/personal/hosts.yml "$playbook"
done
