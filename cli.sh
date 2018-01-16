#!/bin/sh
set -e

# commands: all lint syntax-check run_test converge requirements idempotence all

# Colors!
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

root_role_dir="/etc/ansible/roles/role_to_test"
root_test_dir="${root_role_dir}/tests"
playbook="${root_test_dir}/playbook.yml"
inventory="${root_test_dir}/inventory"
requirements="${root_test_dir}/requirements.yml"
run_tests="${root_test_dir}/run_tests.sh"

lint() {
	printf "${green}Using ansible-lint to check syntax${neutral}\\n"
	ansible-lint "$playbook"
}

syntax_check() {
	printf "${green}Checking ansible playbook syntax-check${neutral}\\n"
	if [ "$#" -gt 1 ]; then
		ansible-playbook "$@" "$playbook" --syntax-check
	else
		ansible-playbook "$playbook" --syntax-check
	fi
}

converge() {
	printf "${green}Running full playbook${neutral}\\n"
	ansible-playbook "$playbook"
	if [ "$#" -gt 1 ]; then
		ansible-playbook "$@" "$playbook"
	else
		ansible-playbook "$playbook"
	fi
}

run_test() {
	printf "${green}Running tests${neutral}\\n"
	sh "$run_tests"
}

idempotence() {
	printf "${green}Running playbook again (idempotence test)${neutral}\\n"
	idempotence="$(mktemp)"

	if [ "$#" -gt 1 ]; then
		cmd="ansible-playbook ${@} ${playbook}"
	else
		cmd="ansible-playbook ${playbook}"
	fi
	$cmd | tee -a "$idempotence"
	tail "$idempotence" \
		| grep -q 'changed=0.*failed=0' \
		&& (printf "${green}Idempotence test: pass${neutral}\\n") \
		|| (printf "${red}Idempotence test: fail${neutral}\\n" && exit 1)
}

requirements() {
	if [ -f "$requirements" ]; then
		printf "${green}Requirements file detected; installing dependencies.${neutral}\\n"
		ansible-galaxy install -r "$requirements"
	fi
}

usage() {
	echo "usage: $0 (lint|syntax-check|requirments|converge|idempotence|run_test|all)"
	echo "  lint: Runs ansible-lint on tests/playbook.yml"
	echo "  syntax-check: Runs ansible-playbook --syntax-check on tests/playbook.yml"
	echo "  requirements: Imports requirements from ansible galaxy"
	echo "  converge: Runs tests/playbook.yml"
	echo "  idempotence: Runs ansible-playbook again and fails if anything changes"
	echo "  run_test: Runs pytest on tests folder"
	echo "  all: Runs all of the above"
	exit 1
}

cmd="$1"
if [ ! "$#" -eq 0 ]; then
	shift 1
fi
args="$*"

case "$cmd" in
	all)
		lint
		syntax_check "$args"
		requirements
		converge "$args"
		idempotence "$args"
		run_test
		;;
	lint)
		lint
		;;
	syntax-check)
		syntax_check "$args"
		;;
	requirements)
		requirements
		;;
	converge)
		converge "$args"
		;;
	idempotence)
		converge "$args"
		idempotence "$args"
		;;
	run_test)
		run_test
		;;
	*)
		usage
		;;
esac
