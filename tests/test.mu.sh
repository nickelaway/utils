#!/usr/bin/env bash

BIN="$(dirname "$0")/../bin/mu"
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

run_test "mu 2 3 4"           "24"                      2 3 4
run_test "mu 0.5 2"           "1"                       0.5 2
run_test "mu 3 0.1"           "0.3"                     3 0.1
run_test "mu 2 0.25"          "0.5"                     2 0.25
run_test "mu 5 2 3"           "30"                      5 2 3

echo
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
