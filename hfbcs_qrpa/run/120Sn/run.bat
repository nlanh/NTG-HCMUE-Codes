@echo off
setlocal

REM Run the HFB+BCS-QRPA program.
REM Expected executable: ..\..\bin\windows-x86_64\hfbcs-qrpa.exe

set "SCRIPT_DIR=%~dp0"
set "PROGRAM=%SCRIPT_DIR%..\..\bin\windows-x86_64\hfbcs-qrpa.exe"

REM Run from the directory containing this script, so input/output files
REM are resolved relative to run/.
cd /d "%SCRIPT_DIR%"

if not exist "%PROGRAM%" (
    echo Error: executable not found:
    echo "%PROGRAM%"
    exit /b 1
)

echo === Running hfbcs-qrpa ===
"%PROGRAM%"
if errorlevel 1 (
    echo Error: hfbcs-qrpa failed.
    exit /b 1
)

echo.
echo === Calculation completed successfully ===
endlocal
