#!/bin/sh
# test-kabi-sidecar.sh -- self-test of tools/kabi-sidecar.py's kbootset-min= (C2-3 version 10) against a cut.
# RUN is a cut's run root (cuts/<KB>/cut.sh OUT): its out/c/unix and the sidecar recorded beside it,
# out/c/kabi, whose pin= and abi= are the inputs.  Checks: without --kbootset-min the tool writes the
# recorded sidecar byte for byte (a recorded sidecar is never re-stamped); with it, the same bytes plus
# one last line, the file's line verbatim; --check accepts both and refuses the key out of its place;
# and a floor file that is not one line of the form N.N.N.YYMMDD-N, or is missing, is refused.
#
#     sh tools/test-kabi-sidecar.sh RUN          # exits 0 if every case passes
set -u
HERE=$(cd "$(dirname "$0")/.." && pwd)
RUN=${1:?usage: test-kabi-sidecar.sh RUN, the run root of a cut, with out/c/unix and out/c/kabi}
K=$RUN/out/c/unix; REC=$RUN/out/c/kabi
[ -f "$K" ] && [ -f "$REC" ] || { echo "test-kabi-sidecar: no $K or $REC"; exit 2; }
W="$HERE/build/test-kabi-sidecar"; rm -rf "${W:?}"; mkdir -p "$W"
T="python3 $HERE/tools/kabi-sidecar.py"
PIN=$(sed -n 's/^pin=//p' "$REC"); ABI=$(sed -n 's/^abi=//p' "$REC")
fails=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1"; fails=$((fails + 1)); }
gen() { $T "$K" --family generic --pin "$PIN" --abi "$ABI" "$@" > "$W/log" 2>&1; }

grep -q '^kbootset-min=' "$REC" && fail "the recorded sidecar predates version 10" || pass "the recorded sidecar predates version 10"

gen -o "$W/none" && cmp -s "$W/none" "$REC" && pass "no --kbootset-min: the recorded sidecar byte for byte" \
	|| { fail "no --kbootset-min: the recorded sidecar byte for byte"; cat "$W/log"; }

printf '1.1.0.261101-34\n' > "$W/kbmin"
{ cat "$REC"; echo "kbootset-min=1.1.0.261101-34"; } > "$W/want"
gen --kbootset-min "$W/kbmin" -o "$W/with" && cmp -s "$W/with" "$W/want" \
	&& pass "--kbootset-min: the recorded bytes plus kbootset-min= as the last line" \
	|| { fail "--kbootset-min: the recorded bytes plus kbootset-min= as the last line"; cat "$W/log"; diff "$W/want" "$W/with"; }

$T --check "$K" "$REC" > /dev/null 2>&1 && pass "--check accepts the recorded sidecar" || fail "--check accepts the recorded sidecar"
$T --check "$K" "$W/with" > /dev/null 2>&1 && pass "--check accepts the version 10 sidecar" || fail "--check accepts the version 10 sidecar"
{ echo "kbootset-min=1.1.0.261101-34"; cat "$REC"; } > "$W/moved"
$T --check "$K" "$W/moved" > /dev/null 2>&1 && fail "--check refuses kbootset-min= out of place" || pass "--check refuses kbootset-min= out of place"

refuse() {	# refuse NAME CONTENT-PRINTF-FORMAT
	printf "$2" > "$W/bad"
	if gen --kbootset-min "$W/bad" -o "$W/out-bad"; then fail "refuses $1"
	elif grep -q 'kabi-sidecar: --kbootset-min' "$W/log"; then pass "refuses $1"
	else fail "refuses $1 (the wrong message)"; cat "$W/log"; fi
}
refuse "two lines" '1.1.0.261101-34\n1.1.0.261101-35\n'
refuse "no newline" '1.1.0.261101-34'
refuse "an empty file" ''
refuse "a version without the date" '1.1.0-34\n'
refuse "a trailing blank" '1.1.0.261101-34 \n'
if gen --kbootset-min "$W/missing" -o "$W/out-missing"; then fail "refuses a missing file"
else grep -q 'kabi-sidecar: --kbootset-min' "$W/log" && pass "refuses a missing file" || { fail "refuses a missing file (the wrong message)"; cat "$W/log"; }; fi

[ "$fails" -eq 0 ] && echo "test-kabi-sidecar: all cases pass" || echo "test-kabi-sidecar: $fails case(s) FAIL"
exit "$fails"
