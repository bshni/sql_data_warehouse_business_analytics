"""
xlsx_to_csv.py

Batch-converts all .xlsx files in a source folder to .csv files in an output
folder, so they can be loaded with SQL Server's BULK INSERT.

Usage:
    python xlsx_to_csv.py --src "C:\\sql\\dwh_project\\datasets\\source_erp" --dst "C:\\sql\\dwh_project\\datasets\\source_erp_csv"

If --dst is omitted, CSVs are written alongside the source files.

Notes:
- Only the FIRST sheet of each workbook is exported by default (use
  --all-sheets to export every sheet as its own CSV: <file>__<sheet>.csv).
- Dates are written in ISO format (YYYY-MM-DD) so they match what your
  BULK INSERT / bronze DATE columns expect.
- Output is UTF-8 with a comma delimiter, matching FIELDTERMINATOR = ','
  and no header skipping surprises (FIRSTROW = 2 still applies since the
  header row is kept).
"""

import argparse
import subprocess
import sys
from pathlib import Path


def ensure_dependencies():
    """Install pandas/openpyxl automatically if they're missing, so this
    script runs standalone on a fresh machine without a manual pip step."""
    required = {"pandas": "pandas", "openpyxl": "openpyxl"}
    missing = []
    for module_name, pip_name in required.items():
        try:
            __import__(module_name)
        except ImportError:
            missing.append(pip_name)

    if missing:
        print(f"Installing missing packages: {', '.join(missing)} ...")
        subprocess.check_call(
            [sys.executable, "-m", "pip", "install", "--quiet", *missing]
        )
        print("Done installing dependencies.\n")


ensure_dependencies()

import pandas as pd  # noqa: E402  (import after dependency check on purpose)


def convert_file(xlsx_path: Path, dst_dir: Path, all_sheets: bool) -> None:
    try:
        excel = pd.ExcelFile(xlsx_path, engine="openpyxl")
    except Exception as e:
        print(f"[SKIP] Could not open {xlsx_path.name}: {e}")
        return

    sheets = excel.sheet_names if all_sheets else excel.sheet_names[:1]

    for sheet in sheets:
        df = excel.parse(sheet_name=sheet)

        # Normalize datetime columns to plain ISO dates (no time component
        # unless one is actually present).
        for col in df.columns:
            if pd.api.types.is_datetime64_any_dtype(df[col]):
                df[col] = df[col].dt.strftime("%Y-%m-%d")

        if all_sheets and len(excel.sheet_names) > 1:
            out_name = f"{xlsx_path.stem}__{sheet}.csv"
        else:
            out_name = f"{xlsx_path.stem}.csv"

        out_path = dst_dir / out_name
        df.to_csv(out_path, index=False, encoding="utf-8")
        print(f"[OK] {xlsx_path.name} ({sheet}) -> {out_path}")


def main():
    parser = argparse.ArgumentParser(description="Convert xlsx files to CSV.")
    parser.add_argument("--src", required=True, help="Folder containing .xlsx files")
    parser.add_argument("--dst", help="Output folder for .csv files (defaults to --src)")
    parser.add_argument(
        "--all-sheets",
        action="store_true",
        help="Export every sheet in each workbook (default: first sheet only)",
    )
    args = parser.parse_args()

    src_dir = Path(args.src)
    dst_dir = Path(args.dst) if args.dst else src_dir
    dst_dir.mkdir(parents=True, exist_ok=True)

    if not src_dir.exists():
        print(f"Source folder does not exist: {src_dir}")
        sys.exit(1)

    xlsx_files = sorted(src_dir.glob("*.xlsx"))
    if not xlsx_files:
        print(f"No .xlsx files found in {src_dir}")
        return

    for f in xlsx_files:
        convert_file(f, dst_dir, args.all_sheets)


if __name__ == "__main__":
    main()
