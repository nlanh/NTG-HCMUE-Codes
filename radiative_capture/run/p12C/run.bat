from pathlib import Path

run_dir = Path("/mnt/data")
sh = r"""#!/usr/bin/env bash
# Run POT first, then RC. Input/output files are read from this run/ directory.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/../../bin/linux-x86_64"

cd "$SCRIPT_DIR"

POT="${BIN_DIR}/POT"
RC="${BIN_DIR}/RC"

for program in "$POT" "$RC"; do
    if [[ ! -f "$program" ]]; then
        echo "Error: executable not found: $program" >&2
        exit 1
    fi
    if [[ ! -x "$program" ]]; then
        echo "Error: file is not executable: $program" >&2
        echo "Run: chmod +x \"$program\"" >&2
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
"""
bat = r"""@echo off
setlocal

REM Run POT first, then RC. Input/output files are read from this run/ directory.

set "SCRIPT_DIR=%~dp0"
set "BIN_DIR=%SCRIPT_DIR%..\..\bin\windows-x86_64"

REM Make run/ the working directory, regardless of where this script is launched.
cd /d "%SCRIPT_DIR%"

if not exist "%BIN_DIR%\POT.exe" (
    echo Error: POT.exe not found:
    echo "%BIN_DIR%\POT.exe"
    exit /b 1
)

if not exist "%BIN_DIR%\RC.exe" (
    echo Error: RC.exe not found:
    echo "%BIN_DIR%\RC.exe"
    exit /b 1
)

echo === Running POT ===
"%BIN_DIR%\POT.exe"
if errorlevel 1 (
    echo Error: POT failed. RC will not be started.
    exit /b 1
)

echo.
echo === Running RC ===
"%BIN_DIR%\RC.exe"
if errorlevel 1 (
    echo Error: RC failed.
    exit /b 1
)

echo.
echo === Calculation completed successfully ===
endlocal
"""
(run_dir / "run.sh").write_text(sh, encoding="utf-8")
(run_dir / "run.sh").chmod(0o755)
(run_dir / "run.bat").write_text(bat, encoding="utf-8")
print("Updated run.sh and created run.bat; both execute from the run/ directory.")
