@echo off
REM ============================================================
REM  run_xlsx_to_csv.bat
REM  Double-click wrapper for xlsx_to_csv.py on Windows.
REM  Edit the SRC and DST paths below to match your project.
REM ============================================================

set SRC=C:\Users\Mohamed Ahmed Rashed\sql_data_warehouse_business_analytics\datasets\source_xlsx
set DST=C:\Users\Mohamed Ahmed Rashed\sql_data_warehouse_business_analytics\datasets\source_csv

REM Change /ALL_SHEETS to true if you want every sheet exported
set ALL_SHEETS=false

echo Converting xlsx files in %SRC% to CSV in %DST% ...
echo.

if "%ALL_SHEETS%"=="true" (
    python "%~dp0xlsx_to_csv.py" --src "%SRC%" --dst "%DST%" --all-sheets
) else (
    python "%~dp0xlsx_to_csv.py" --src "%SRC%" --dst "%DST%"
)

echo.
echo Done. Press any key to close.
pause >nul
