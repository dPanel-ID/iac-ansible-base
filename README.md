# dPanel Ansible IaC Base

Public base template for dPanel workspace Infrastructure as Code repositories.

This repository is designed to be cloned by dPanel for a personal workspace or
organization workspace. It is based on the ideas and roles from
`devetek/d-panel-resource`, but the public template uses a cleaner top-level
contract:

```text
dpanel.yaml
modules/
playbooks/
inventory/
```

## What This Repository Contains

- `playbooks/setup.yml` for the standard dPanel VM bootstrap.
- `modules/*/dpanel.module.yaml` as the UI/execution contract for dPanel.
- `playbooks/modules/*.install.yml` as reusable module playbooks.
- Safe inventory templates with no real hosts or secrets.

Reusable Ansible roles are not vendored here. dPanel Manager and the executor
resolve roles from `dPanel-ID/iac-modules` using the selected workspace IaC ref.

## What This Repository Must Not Contain

- SSH private keys or public keys.
- Real inventories, IP addresses, usernames, passwords, or tokens.
- Vault password files or decrypted vault content.
- Generated executor variables or credentials.
- Local Docker/demo harness files.

Secrets must be stored in dPanel secret storage or an external secret manager
and injected at execution time.

## Branch, Tag, And Commit Safety

dPanel reads module manifests, alias overlays, playbooks, and inventory from
the selected workspace IaC ref. Reusable roles are resolved from
`dPanel-ID/iac-modules` using that selected branch/ref. A branch, tag, or commit
is resolved to an immutable commit SHA before catalog validation and before
execution.

If a branch moves and breaks a module manifest or alias overlay, dPanel should
hide the invalid inputs from normal UI and expose validation details only to
workspace owners.

## Setup Playbook

The default setup playbook is:

```text
playbooks/setup.yml
```

dPanel Manager supplies runtime variables such as machine ID, workspace ID,
agent callback URL, Uptrace DSN, and artifact source during VM setup. Do not
commit those values into this repository.

## Local Validation

Use the shared role source and install required collections first:

```sh
git clone https://github.com/dPanel-ID/iac-modules.git ../iac-modules
export ANSIBLE_ROLES_PATH="../iac-modules/ansible/roles"
ansible-galaxy collection install -r requirements.yml -p .ansible/collections
```

Then run:

```sh
scripts/validate-template.sh
```

## Module Manifests

Each module should have:

```text
modules/<module-name>/dpanel.module.yaml
```

Optional product-facing aliases can be defined in:

```text
modules/<module-name>/dpanel.aliases.yaml
```

Aliases are scoped to the selected branch, tag, or commit. They should only
adjust labels, help text, grouping, and deprecated input names. They should not
be used as a second execution mapping layer.
