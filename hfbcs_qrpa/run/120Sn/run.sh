#!/usr/bin/env bash
# Run the HFB+BCS-QRPA program.
# Expected executable: ../../bin/linux-x86_64/hfbcs-qrpa

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROGRAM="${SCRIPT_DIR}/../../bin/linux-x86_64/hfbcs-qrpa"

# Run from the directory containing this script, so input/output files
# are resolved relative to run/.
cd "$SCRIPT_DIR"

if [[ ! -f "$PROGRAM" ]]; then
    echo "Error: executable not found: $PROGRAM" >&2
    exit 1
fi

# Ensure the Linux executable has execute permission.
chmod +x "$PROGRAM"

echo "=== Running hfbcs-qrpa ==="
"$PROGRAM"

echo
echo "=== Calculation completed successfully ==="
