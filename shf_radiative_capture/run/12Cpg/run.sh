#!/usr/bin/env bash

# Stop if any command fails
set -euo pipefail

# Determine directories
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/../../bin/linux-x86_64"

# Select calculation mode (default: all)
MODE="${1:-all}"

# Check executable directory
if [[ ! -d "$BIN_DIR" ]]; then
    echo "ERROR: Binary directory not found: $BIN_DIR"
    exit 1
fi

# Make all binaries executable
echo "Setting executable permissions..."
chmod +x "$BIN_DIR"/*

case "$MODE" in

    all)
        echo "===================================="
        echo "  Running full calculation"
        echo "===================================="

        # Step 1: Skyrme Hartree-Fock calculation
        echo "[1/4] Running Skyrme HF..."
        (
            cd "$SCRIPT_DIR/skyrme"
            "$BIN_DIR/skyrme_rpa"
        )

        # Step 2: Copy the generated potential
        echo "[2/4] Copying HF potential..."
        cp "$SCRIPT_DIR/skyrme/OUTPOT.DAT" \
           "$SCRIPT_DIR/rc/OUTPOT.DAT"

        # Step 3: Generate radiative capture potential
        echo "[3/4] Generating RC potential..."
        (
            cd "$SCRIPT_DIR/rc"
            "$BIN_DIR/POT_HFRC"
        )

        # Step 4: Radiative capture calculation
        echo "[4/4] Running radiative capture..."
        (
            cd "$SCRIPT_DIR/rc"
            "$BIN_DIR/RC"
        )
        ;;

    rc)
        echo "===================================="
        echo "  Running radiative capture only"
        echo "===================================="

        # Check whether the HF potential exists
        if [[ ! -f "$SCRIPT_DIR/skyrme/OUTPOT.DAT" ]]; then
            echo "ERROR: skyrme/OUTPOT.DAT not found."
            echo "Please run './run.sh all' first."
            exit 1
        fi

        # Step 1: Copy existing HF potential
        echo "[1/3] Copying existing HF potential..."
        cp "$SCRIPT_DIR/skyrme/OUTPOT.DAT" \
           "$SCRIPT_DIR/rc/OUTPOT.DAT"

        # Step 2: Generate RC potential
        echo "[2/3] Generating RC potential..."
        (
            cd "$SCRIPT_DIR/rc"
            "$BIN_DIR/POT_HFRC"
        )

        # Step 3: Radiative capture calculation
        echo "[3/3] Running radiative capture..."
        (
            cd "$SCRIPT_DIR/rc"
            "$BIN_DIR/RC"
        )
        ;;

    *)
        echo "Usage: ./run.sh [all|rc]"
        echo ""
        echo "  all : Run complete calculation (default)"
        echo "  rc  : Run radiative capture only"
        exit 1
        ;;
esac

echo "===================================="
echo "  Calculation completed successfully!"
echo "===================================="
