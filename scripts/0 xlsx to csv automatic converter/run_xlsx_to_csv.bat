@echo off
REM double click this to run the converter instead of typing the command
REM every time.

python "%~dp0xlsx_to_csv.py"

echo.
echo Done. Press any key to close.
pause >nul
