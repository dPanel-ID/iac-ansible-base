# Security Notes

This repository is public template code. Treat every file as visible to all
users.

## Never Commit

- SSH private keys, public keys, or authorized keys.
- Real inventories, IP addresses, ports, usernames, or bastion details.
- `.env` files or local runtime configuration.
- dPanel callback tokens, Casdoor secrets, Uptrace DSNs, cloud tokens, or GitHub
  tokens.
- Vault password files or decrypted vault data.
- Generated executor credentials or extra-vars JSON.

## Secret Handling

Module manifests should use `secret_ref` inputs. The actual secret value must be
resolved by dPanel at execution time and injected ephemerally.

Tasks that receive resolved secrets must use `no_log: true` when logging could
include the secret value.

## Role Supply Chain

Ansible roles execute code on target machines. Role changes should be reviewed
like application code. Prefer pinned tags or immutable commits. Avoid mutable
branch references for production workspaces.

