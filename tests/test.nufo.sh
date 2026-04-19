#!/usr/bin/env bash

BIN="$(dirname "$0")/../bin/nufo"
PASS=0; FAIL=0

run_test() {
    local desc="$1" expected="$2"; shift 2
    local actual
    actual=$("$BIN" "$@")
    printf "%-35s  expected: %-20s  " "$desc" "$expected"
    if [ "$actual" = "$expected" ]; then
        echo "PASS"
        ((PASS++))
    else
        echo "FAIL (got: $actual)"
        ((FAIL++))
    fi
}

run_test_stdin() {
    local desc="$1" expected="$2" input="$3"; shift 3
    local actual
    actual=$(echo "$input" | "$BIN" "$@")
    printf "%-35s  expected: %-20s  " "$desc" "$expected"
    if [ "$actual" = "$expected" ]; then
        echo "PASS"
        ((PASS++))
    else
        echo "FAIL (got: $actual)"
        ((FAIL++))
    fi
}

# commas (default)
run_test "1000"                  "1,000"          1000
run_test "1000000"               "1,000,000"      1000000
run_test "999"                   "999"            999
run_test "1234.56"               "1,234.56"       1234.56
run_test "-1000"                 "-1,000"         -1000
run_test_stdin "stdin 1000"      "1,000"          "1000"
run_test "commas input commas"   "1,000"          1,000

# --bytes
run_test "500 bytes"             "500B"           --bytes 500
run_test "1024 bytes"            "1KB"            --bytes 1024
run_test "1536 bytes"            "1.5KB"          --bytes 1536
run_test "1048576 bytes"         "1MB"            --bytes 1048576
run_test "1572864 bytes"         "1.5MB"          --bytes 1572864
run_test "1073741824 bytes"      "1GB"            --bytes 1073741824
run_test "1099511627776 bytes"   "1TB"            --bytes 1099511627776
run_test "commas input bytes"    "1KB"            --bytes 1,024
run_test_stdin "stdin bytes"     "1KB"            "1,024" --bytes

# --seconds
run_test "45s"                   "45 Seconds"                         --seconds 45
run_test "65s"                   "1 Minute 5 Seconds"                 --seconds 65
run_test "3600s"                 "1 Hour"                             --seconds 3600
run_test "3661s"                 "1 Hour 1 Minute 1 Second"           --seconds 3661
run_test "86400s"                "1 Day"                              --seconds 86400
run_test "90061s"                "1 Day 1 Hour 1 Minute 1 Second"     --seconds 90061
run_test "7200s"                 "2 Hours"                            --seconds 7200
run_test "120s"                  "2 Minutes"                          --seconds 120
run_test "2s"                    "2 Seconds"                          --seconds 2
run_test "0s"                    "0 Seconds"                          --seconds 0
run_test_stdin "stdin seconds"   "1 Minute 5 Seconds"                 "65" --seconds

# --millis
run_test "500ms"                 "500 Milliseconds"                            --millis 500
run_test "1ms"                   "1 Millisecond"                               --millis 1
run_test "1000ms"                "1 Second"                                    --millis 1000
run_test "1500ms"                "1 Second 500 Milliseconds"                   --millis 1500
run_test "65000ms"               "1 Minute 5 Seconds"                          --millis 65000
run_test "65500ms"               "1 Minute 5 Seconds 500 Milliseconds"         --millis 65500
run_test "3600000ms"             "1 Hour"                                       --millis 3600000
run_test "86400000ms"            "1 Day"                                        --millis 86400000
run_test "90061001ms"            "1 Day 1 Hour 1 Minute 1 Second 1 Millisecond" --millis 90061001
run_test "0ms"                   "0 Milliseconds"                              --millis 0
run_test_stdin "stdin millis"    "1 Minute 5 Seconds"                          "65000" --millis

echo
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
