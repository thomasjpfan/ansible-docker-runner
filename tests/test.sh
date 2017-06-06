#!/bin/bash

set -e

TAG=${1:-"master"}

printf "Running ansible ping\n"
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
thomasjpfan/ansible-docker-runner:$TAG \
ansible all -c docker -i tests_server1_1,tests_server2_1, -m ping
printf "\n"

printf "Running ansible playbook\n"
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
-v ${PWD}/tests:/tests \
thomasjpfan/ansible-docker-runner:$TAG \
ansible-playbook -c docker -i "tests_server1_1,tests_server2_1," /tests/playbook.yml
printf "\n"
