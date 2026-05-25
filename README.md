# dPanel Ansible IaC Base

Public Ansible template for dPanel personal and organization workspace IaC
repositories.

dPanel creates managed workspace repositories from this template, for example:

```text
dpanel-iac-personal-<USER-ID>
dpanel-iac-organization-<ORG-ID>
```

This repository intentionally contains only the workspace playbook and inventory
structure. The module catalog and reusable Ansible roles are resolved from
[`dPanel-ID/iac-modules`](https://github.com/dPanel-ID/iac-modules).

## Repository Contract

```text
playbooks/
inventory/
requirements.yml
ansible.cfg
scripts/
docs/
```

## What This Repository Contains

- `playbooks/setup.yml` for the standard dPanel VM bootstrap.
- `playbooks/build.yml` for build artifact preparation.
- `playbooks/application.yml` for application filesystem cleanup.
- `playbooks/deploy.yml` for artifact deployment.
- `playbooks/pipeline.yml` for the full build and deploy pipeline.
- `playbooks/router.yml` for load balancer or router management.
- `inventory/templates/*` as safe example inventory structure.
- `requirements.yml` for collections required by template validation.
- Validation scripts used by CI and local checks.

## What This Repository Does Not Contain

- Module manifests such as `dpanel.module.yaml`.
- Module alias overlays.
- `modules/` or `playbooks/modules/`.
- Vendored reusable Ansible roles.
- Real inventory, machine addresses, users, tokens, or secrets.

The module catalog lives in `dPanel-ID/iac-modules` under:

```text
ansible/modules/<module-name>/dpanel.module.yaml
```

Reusable roles live in `dPanel-ID/iac-modules/ansible/roles` or are installed
from `dPanel-ID/iac-modules/ansible/requirements.yml` by the dPanel executor.

## Runtime Flow

1. dPanel Manager prepares or selects a workspace IaC repository created from
   this template.
2. dPanel Manager reads available modules from `dPanel-ID/iac-modules`.
3. For module installation, dPanel Manager generates a playbook under the
   workspace repository:

   ```text
   playbooks/generated/<name>.yml
   ```

4. dPanel Executor checks out the workspace repository at the selected ref.
5. dPanel Executor checks out `dPanel-ID/iac-modules` at the configured module
   source ref.
6. dPanel Executor installs module role dependencies from:

   ```text
   dPanel-ID/iac-modules/ansible/requirements.yml
   ```

7. dPanel Executor runs the selected playbook with runtime variables, inventory,
   credentials, and extra-vars supplied by dPanel.

Generated playbooks are part of each workspace repository so other executors or
future GitHub Actions runners can execute the same desired state.

## Branch, Tag, And Commit Safety

dPanel resolves the selected workspace IaC ref and module source ref to concrete
commit SHAs before execution.

Workspace repositories may use branches for development, but production
workspaces should prefer reviewed tags or immutable commits when stability is
more important than automatic updates.

If the selected module source branch changes and invalidates a module manifest,
dPanel should hide invalid inputs from the normal UI and surface validation
details to workspace owners.

## Runtime Variables

dPanel supplies runtime values during execution. Do not commit them into this
repository.

Examples include:

- machine ID and workspace ID
- SSH connection details
- active agent callback and enrollment settings
- Uptrace DSN and OTLP endpoints
- artifact source and version
- generated extra-vars JSON
- resolved secrets

Secrets must be stored in dPanel secret storage or an external secret manager
and injected only at execution time.

## Local Validation

Install Ansible and required collections:

```sh
ansible-galaxy collection install -r requirements.yml -p .ansible/collections
```

For local syntax checks, provide role sources from `iac-modules`:

```sh
git clone https://github.com/dPanel-ID/iac-modules.git ../iac-modules
ansible-galaxy role install \
  -r ../iac-modules/ansible/requirements.yml \
  -p ../iac-modules/ansible/roles
```

Then run:

```sh
ANSIBLE_ROLES_PATH="../iac-modules/ansible/roles:.ansible/roles" \
scripts/validate-template.sh
```

CI also creates lightweight role stubs with
`scripts/prepare-ci-role-stubs.sh` so template syntax can be validated without
executing real role logic.

## Security Rules

Never commit:

- SSH private keys, public keys, or authorized keys.
- Real inventories, IP addresses, ports, usernames, or bastion details.
- `.env` files or local runtime configuration.
- dPanel callback tokens, Casdoor secrets, Uptrace DSNs, cloud tokens, or GitHub
  tokens.
- Vault password files or decrypted vault data.
- Generated executor credentials or extra-vars JSON.

See [docs/SECURITY.md](docs/SECURITY.md) for additional security notes.
