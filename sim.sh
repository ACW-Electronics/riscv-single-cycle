#!/usr/bin/env bash
# Icarus Verilog helper. Run from the repo root in Git Bash (Windows), macOS or Linux.
#
#   ./sim.sh                      compile every RTL file (syntax/port check)
#   ./sim.sh alu/alu_tb.v         compile and run one testbench
#   ./sim.sh all                  run every *_tb.v
#
# Build output and .vcd waveforms go in build/ (git-ignored).
# Open a waveform with: gtkwave build/<name>.vcd

set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build

# Every .v file that isn't a testbench is RTL.
RTL=$(find . -name '*.v' ! -name '*_tb.v' ! -path './build/*' | sort)
FLAGS="-g2012 -Wall -Wno-timescale"

# Testbenches use library mode: each folder is searched for <module>.v, and only
# the modules the testbench actually uses get loaded. A half-written file
# elsewhere can't break an unrelated test. (Requires module name == filename.)
LIBS=$(for d in $(dirname $RTL | sort -u); do printf -- '-y %s ' "$d"; done)

run_tb() {
    local tb=$1 name
    name=$(basename "$tb" .v)
    echo "== $tb"
    iverilog $FLAGS $LIBS -o "build/$name.vvp" "$tb"
    (cd build && vvp -n "$name.vvp")
}

case "${1:-}" in
    "")
        echo "== compiling RTL"
        iverilog $FLAGS -o build/rtl.vvp $RTL && echo "OK"
        ;;
    all)
        fail=0
        for tb in $(find . -name '*_tb.v' ! -path './build/*' | sort); do run_tb "$tb" || fail=1; done
        exit $fail
        ;;
    *)
        run_tb "$1"
        ;;
esac
