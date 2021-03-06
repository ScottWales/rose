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
# Test "rose suite-clean", --only= mode and a remote host root-dir{*} setting.
#-------------------------------------------------------------------------------
. $(dirname $0)/test_header

run_suite() {
    set -e
    rose suite-run --new -q \
        -C "$TEST_SOURCE_DIR/$TEST_KEY_BASE" --name="$NAME" \
        --no-gcontrol -S "HOST=\"$JOB_HOST\"" -- --debug
    ssh "$JOB_HOST" "ls -d cylc-run/$NAME 1>/dev/null"
    ls -d $HOME/cylc-run/$NAME $HOME/.cylc/{$NAME,REGDB/$NAME} 1>/dev/null
    set +e
}
JOB_HOST=$(rose config --default= 't' 'job-host')
JOB_HOST_WORK=$(rose config --default= 't' 'job-host-run-root')
if [[ -z "$JOB_HOST" || -z "$JOB_HOST_WORK" ]]; then
    skip_all '[t]job-host or [t]job-host-run-root not defined'
fi
JOB_HOST=$(rose host-select $JOB_HOST)
#-------------------------------------------------------------------------------
tests 2
#-------------------------------------------------------------------------------
export ROSE_CONF_PATH=$PWD/conf

mkdir 'conf'
cat >'conf/rose.conf' <<__CONF__
[rose-suite-run]
root-dir{work}=$JOB_HOST=$JOB_HOST_WORK
__CONF__
JOB_HOST_WORK=$(ssh -oBatchMode=yes "$JOB_HOST" \
    "bash -l -c \"echo \\$JOB_HOST_WORK\"" | tail -1)

mkdir -p $HOME/cylc-run
SUITE_RUN_DIR=$(mktemp -d --tmpdir=$HOME/cylc-run 'rose-test-battery.XXXXXX')
SUITE_RUN_DIR=$(readlink -f "$SUITE_RUN_DIR")
NAME=$(basename $SUITE_RUN_DIR)
#-------------------------------------------------------------------------------
run_suite
TEST_KEY="$TEST_KEY_BASE-work"
run_pass "$TEST_KEY" rose suite-clean -y -n "$NAME" --only=work
sed -i '/\/\.cylc\//d' "$TEST_KEY.out"
{
    echo "[INFO] delete: $SUITE_RUN_DIR/work/"
    LANG=C sort <<__OUT__
[INFO] delete: $JOB_HOST:cylc-run/$NAME/work
[INFO] delete: $JOB_HOST:$JOB_HOST_WORK/cylc-run/$NAME/work
__OUT__
} >"$TEST_KEY.out.expected"
file_cmp  "$TEST_KEY.out" "$TEST_KEY.out" "$TEST_KEY.out.expected"
#-------------------------------------------------------------------------------
rose suite-clean -q -y --name="$NAME"
exit 0
