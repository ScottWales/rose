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
# Test fcm_make built-in application:
# * alternate ctx name for continuation
# * alternate mapping for original and continuation task names
# On job host with or without shared file system
#
# N.B. Test requires compatible versions of "rose" and "fcm make" on the job
#      host, as well as "gfortran" being installed and available there.
#-------------------------------------------------------------------------------
. $(dirname $0)/test_header
if ! fcm help make 1>/dev/null 2>&1; then
    skip_all 'fcm make unavailable'
fi
if ! gfortran --version 1>/dev/null 2>&1; then
    skip_all 'gfortran unavailable'
fi
if [[ "${TEST_KEY_BASE}" == *-with-share ]]; then
    JOB_HOST="$(rose config --default= 't' 'job-host-with-share')"
else
    JOB_HOST="$(rose config --default= 't' 'job-host')"
fi
if [[ -n "${JOB_HOST}" ]]; then
    JOB_HOST="$(rose host-select "${JOB_HOST}")"
fi
if [[ -z "${JOB_HOST}" ]]; then
    skip_all '"[t]job-host" not defined or not available'
fi
#-------------------------------------------------------------------------------
tests 1
export ROSE_CONF_PATH=
mkdir -p "${HOME}/cylc-run"
#-------------------------------------------------------------------------------
SUITE_RUN_DIR="$(mktemp -d --tmpdir="${HOME}/cylc-run" 'rose-test-battery.XXXXXX')"
NAME="$(basename "${SUITE_RUN_DIR}")"
timeout 120 rose suite-run -v -v --debug \
    -C "${TEST_SOURCE_DIR}/${TEST_KEY_BASE}" --name="${NAME}" \
    --no-gcontrol --host='localhost' \
    -D "[jinja2:suite.rc]HOST=\"${JOB_HOST}\"" -- --debug
#-------------------------------------------------------------------------------
ssh -n -oBatchMode=yes "${JOB_HOST}" \
    cat "cylc-run/${NAME}/share/hello.txt" >'hello.txt'
file_cmp "${TEST_KEY_BASE}" 'hello.txt' <<<'Hello World!'
#-------------------------------------------------------------------------------
rose suite-clean -q -y "${NAME}"
exit 0
