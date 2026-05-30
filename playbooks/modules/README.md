# Generated Module Installers

dPanel writes shared module installer playbooks here, for example:

```text
install-php.yml
install-caddyserver.yml
install-postgresql.yml
```

Application and load balancer playbooks import these files from their workspace
folder with `{{ playbook_dir }}/../modules/<installer>.yml`.

Do not place secrets, inventories, or execution-specific variables in this
folder. Runtime values must be supplied by dPanel at execution time.
