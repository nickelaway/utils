#!/usr/bin/env bash

BIN="$(dirname "$0")/../bin/depoch"
PASS=0; FAIL=0

ALL="1234567890 1234567890123 1234567890123456789"
ALL_CONVERTED="1234567890{2009-02-13_23:31:30} 1234567890123{2009-02-13_23:31:30.123} 1234567890123456789{2009-02-13_23:31:30.123456789}"

run_test() {
    local desc="$1" expected="$2" input="$3"; shift 3
    local actual
    actual=$(echo "$input" | "$BIN" "$@")
    printf "%-50s  expected: %-55s  " "$desc" "$expected"
    if [ "$actual" = "$expected" ]; then
        echo "PASS"
        ((PASS++))
    else
        echo "FAIL (got: $actual)"
        ((FAIL++))
    fi
}

# Default behaviour (no options)
run_test "10-digit timestamp"             "1234567890{2009-02-13_23:31:30}"                              "1234567890"
run_test "13-digit timestamp (ms)"        "1234567890123{2009-02-13_23:31:30.123}"                       "1234567890123"
run_test "19-digit timestamp (ns)"        "1234567890123456789{2009-02-13_23:31:30.123456789}"           "1234567890123456789"
run_test "timestamp with prefix/suffix"   "event at 1234567890{2009-02-13_23:31:30} done"               "event at 1234567890 done"
run_test "timestamp adjacent to text"     "ts=1234567890{2009-02-13_23:31:30} end"                      "ts=1234567890 end"
run_test "multiple timestamps per line"   "1234567890{2009-02-13_23:31:30} and 1609459200{2021-01-01_00:00:00}"  "1234567890 and 1609459200"
run_test "11-digit run (not a timestamp)" "12345678901"                                                 "12345678901"
run_test "9-digit run (not a timestamp)"  "123456789"                                                   "123456789"
run_test "no digits"                      "no timestamps here"                                          "no timestamps here"

# --seconds
run_test "--seconds matches 10-digit"     "1234567890{2009-02-13_23:31:30} 1234567890123 1234567890123456789"  "$ALL"  --seconds
run_test "--seconds ignores 13-digit"     "1234567890123"                                                "1234567890123"  --seconds
run_test "--seconds ignores 19-digit"     "1234567890123456789"                                         "1234567890123456789"  --seconds

# --millis
run_test "--millis matches 13-digit"      "1234567890 1234567890123{2009-02-13_23:31:30.123} 1234567890123456789"  "$ALL"  --millis
run_test "--millis ignores 10-digit"      "1234567890"                                                   "1234567890"  --millis
run_test "--millis ignores 19-digit"      "1234567890123456789"                                         "1234567890123456789"  --millis

# --nanos
run_test "--nanos matches 19-digit"       "1234567890 1234567890123 1234567890123456789{2009-02-13_23:31:30.123456789}"  "$ALL"  --nanos
run_test "--nanos ignores 10-digit"       "1234567890"                                                   "1234567890"  --nanos
run_test "--nanos ignores 13-digit"       "1234567890123"                                                "1234567890123"  --nanos

# combinations
run_test "--seconds --millis"             "1234567890{2009-02-13_23:31:30} 1234567890123{2009-02-13_23:31:30.123} 1234567890123456789"  "$ALL"  --seconds --millis
run_test "--seconds --nanos"              "1234567890{2009-02-13_23:31:30} 1234567890123 1234567890123456789{2009-02-13_23:31:30.123456789}"  "$ALL"  --seconds --nanos
run_test "--millis --nanos"               "1234567890 1234567890123{2009-02-13_23:31:30.123} 1234567890123456789{2009-02-13_23:31:30.123456789}"  "$ALL"  --millis --nanos

# --tz
run_test "default tz (no suffix)"         "1234567890{2009-02-13_23:31:30}"           "1234567890"
run_test "--tz=UTC appends Z"             "1234567890{2009-02-13_23:31:30Z}"          "1234567890"  --tz=UTC
run_test "--tz UTC (space form)"          "1234567890{2009-02-13_23:31:30Z}"          "1234567890"  --tz UTC
run_test "--tz=America/New_York"          "1234567890{2009-02-13_18:31:30-05:00}"     "1234567890"  --tz=America/New_York
run_test "--tz=Asia/Kolkata (+05:30)"     "1234567890{2009-02-14_05:01:30+05:30}"     "1234567890"  --tz=Asia/Kolkata
run_test "--tz with millis"               "1234567890123{2009-02-13_23:31:30.123Z}"   "1234567890123"  --tz=UTC
run_test "--tz with --seconds"            "1234567890{2009-02-13_18:31:30-05:00}"     "1234567890"  --tz=America/New_York --seconds

echo
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
