#!/bin/bash
#-------------------------------------------------------------------------------
# (C) British Crown Copyright 2012-5 Met Office.
#
# This file is part of Rose, a framework for meteorological suites.
#
# Rose is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Rose is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Rose. If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Test "rose suite-restart", --host=HOST option.
#-------------------------------------------------------------------------------
. "$(dirname "$0")/test_header"

HOSTS=$(rose config --default= 'rose-suite-run' 'hosts')
HOST=
if [[ -n "${HOSTS}" ]]; then
    HOST="$(rose host-select "${HOSTS}")"
fi
if [[ -z "${HOST}" ]]; then
    skip_all '[rose-suite-run]hosts not defined or no suite host available'
fi
tests 4
#-------------------------------------------------------------------------------
export ROSE_CONF_PATH=
mkdir -p "${HOME}/cylc-run"
SUITE_RUN_DIR="$(mktemp -d --tmpdir="${HOME}/cylc-run" 'rose-test-battery.XXXXXX')"
NAME="$(basename "${SUITE_RUN_DIR}")"
rose suite-run --debug -q -C "${TEST_SOURCE_DIR}/${TEST_KEY_BASE}" \
    --name="${NAME}" --host="${HOST}" --no-gcontrol \
    -- --debug

TEST_KEY="${TEST_KEY_BASE}"
run_pass "${TEST_KEY}" rose suite-restart \
    --debug --name="${NAME}" --host="${HOST}" --no-gcontrol \
    -- --debug
file_grep "${TEST_KEY}.out.1" \
    "\\[INFO\\] ${NAME}: will restart on ${HOST}" \
    "${TEST_KEY}.out"
# N.B. This relies on output from "cylc restart"
file_grep "${TEST_KEY}.out.2" \
    "\\[INFO\\] cylc job-submit ${SUITE_RUN_DIR}/log/job/1/t2/01/job" \
    "${TEST_KEY}.out"
file_cmp "${TEST_KEY}.err" "${TEST_KEY}.err" '/dev/null'
#-------------------------------------------------------------------------------
rose suite-clean -y "${NAME}"
exit
