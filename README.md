# thomasjpfan/ansible-docker-runner



Ansible runner for testing playbooks with docker connection

## Usage

1. Set up hosts using docker-compose:

```yaml
version: "3.2"

services:
  server1:
    image: thomasjpfan/ubuntu-python-systemd:latest
    privileged: true
    volumes:
      - type: bind
        source: /sys/fs/cgroup
        target: /sys/fs/cgroup
        read_only: true
  server2:
    image: thomasjpfan/ubuntu-python-systemd:latest
    privileged: true
    volumes:
      - type: bind
        source: /sys/fs/cgroup
        target: /sys/fs/cgroup
        read_only: true
```

2. Mount volumes in `thomasjpfan/ansible-docker-runner` with your playbooks and run ansible commands:

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
-v ${PWD}/tests:/tests \
thomasjpfan/ansible-docker-runner:latest \
ansible-playbook -c docker -i "tests_server1_1,tests_server2_1," /tests/playbook.yml
```

Note that the names `tests_server1_2` and `test_server2_1` is the naming convention of docker-compose when the `docker-compose.yml` file in a folder named tests.

When testing a role mount the current directory into `/etc/ansible/roles` and then target the `playbook.yml` for testing
