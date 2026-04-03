#!/usr/bin/env bash

BIN="$(dirname "$0")/../bin/dv"
PASS=0; FAIL=0

run_test() {
    local desc="$1" expected="$2"; shift 2
    local actual
    actual=$("$BIN" "$@")
    printf "%-30s  expected: %-25s  " "$desc" "$expected"
    if [ "$actual" = "$expected" ]; then
        echo "PASS"
        ((PASS++))
    else
        echo "FAIL (got: $actual)"
        ((FAIL++))
    fi
}

run_test "dv 100 4 5"         "5"                       100 4 5
run_test "dv 1 2"             "0.5"                     1 2
run_test "dv 10 3"            "3.33333333333333333333"  10 3
run_test "dv 0 5"             "0"                       0 5
run_test "dv 1 -2"            "-0.5"                    1 -2

echo
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
