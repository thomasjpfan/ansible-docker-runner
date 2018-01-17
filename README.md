# thomasjpfan/ansible-docker-runner

[![Build Status](https://travis-ci.org/thomasjpfan/ansible-docker-runner.svg?branch=master)](https://travis-ci.org/thomasjpfan/ansible-docker-runner)

Ansible runner for testing playbooks with docker connection.

## Usage

1. Set up hosts using docker-compose:

```yaml
docker-compose -f tests/docker-compose.yml up -d
```

1. Mount volumes in `thomasjpfan/ansible-docker-runner` with your playbooks and run all

```bash
docker run --rm -v $PWD:/etc/ansible/roles/role_to_test \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v $PWD/dep_roles:/root/.ansible/roles -t \
  thomasjpfan/ansible-docker-runner:py2 cli all
```

1. Notice that `tests/playbook.yml` names the role under testing: `role_to_test`.

## Commands

1. `lint`: Runs ansible-lint on `tests/playbook.yml`.
1. `syntax-check`: Runs ansible-playbook --syntax-check on `tests/playbook.yml` with `tests/inventory`.
1. `converge`: Runs ansible-playbook on `tests/playbook.yml` with `tests/inventory`.
1. `idempotence`: Runs converge again and see if anthing changed.
1. `run_test`: Runs test `tests/run_tests.sh`.
1. `requirements`: Runs ansible-galaxy install on `tests/requirements.yml`.
1. `all`: Runs `lint`, `syntax_check`, `requirements`, `converge`, `idempotence`.

## Local Development

For local development, one can start a shell:

```bash
docker run --rm -v $PWD:/etc/ansible/roles/role_to_test
  --name runner \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v $PWD/dep_roles:/root/.ansible/roles -ti \
  thomasjpfan/ansible-docker-runner /bin/sh
```

And run the commands prefixed with `cli`, for example: `cli lint`.

## Extra Features

- Setting `ANSIBLE_PLAYBOOK_ARGS` in the env will be passed along to the `ansible-playbook` cli.
- Any arguments after the command will be passed along to the `ansible-playbook` cli and overwrites `ANSIBLE_PLAYBOOK_ARGS`
- Setting `INVENTORY_PATH` will change the default inventory path: `tests/inventory`.