#!/usr/bin/env bash

BIN="$(dirname "$0")/../bin/mi"
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

run_test "mi 10 3 2"         "5"                        10 3 2
run_test "mi 5 2.5"          "2.5"                      5 2.5
run_test "mi 1 1.5"          "-0.5"                     1 1.5
run_test "mi 0 0.5"          "-0.5"                     0 0.5
run_test "mi 10 3"           "7"                        10 3

echo
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
