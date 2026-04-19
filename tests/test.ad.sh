#!/usr/bin/env bash

BIN="$(dirname "$0")/../bin/ad"
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

run_test "ad 1 2 3 4"        "10"                       1 2 3 4
run_test "ad 1.5 2.5"        "4"                        1.5 2.5
run_test "ad 0.1 0.4"        "0.5"                      0.1 0.4
run_test "ad 1 2 3"          "6"                        1 2 3
run_test "ad 0.1 0.2"        "0.3"                      0.1 0.2
run_test "ad 1,000 10"       "1010"                     1,000 10
run_test "ad 1,000 2,000"    "3000"                     1,000 2,000

echo
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
