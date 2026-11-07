#!/usr/bin/env bash
# Run POT first, then RC.
# Place this script in run/p12C/ and keep the bin/ directory
# alongside the project, as in:
#   project/
#   ├── bin/linux-x86_64/POT
#   ├── bin/linux-x86_64/RC
#   └── run/p12C/run.sh

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/../../bin/linux-x86_64"

POT="${BIN_DIR}/POT"
RC="${BIN_DIR}/RC"

for program in "$POT" "$RC"; do
    if [[ ! -f "$program" ]]; then
        echo "Error: executable not found: $program" >&2
        exit 1
    fi

    # Ensure the executable permission is set before running.
    if ! chmod +x "$program"; then
        echo "Error: could not set executable permission: $program" >&2
        exit 1
    fi
done

echo "=== Running POT ==="
"$POT"

echo
echo "=== Running RC ==="
"$RC"

echo
echo "=== Calculation completed successfully ==="
