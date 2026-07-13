#!/usr/bin/env python3

"""Check Ruff rule codes in pyproject.toml against validate-pyproject-schema-store."""

import argparse
import re
import sys
import tomllib
import urllib.request
from pathlib import Path

SCHEMA_URL = (
    "https://raw.githubusercontent.com/henryiii/validate-pyproject-schema-store/"
    "main/src/validate_pyproject_schema_store/resources/ruff.schema.json"
)
# Matches rule codes (e.g. "E501", "ASYNC119") and category prefixes (e.g. "ANN", "PTH").
CODE_RE = re.compile(r'"([A-Z]{1,5}[0-9]{0,4})"')
CHECKED_FIELDS = ("select", "extend-select", "ignore", "extend-ignore", "unfixable")


def fetch_schema_codes(url: str = SCHEMA_URL) -> set[str]:
    with urllib.request.urlopen(url, timeout=15) as resp:  # noqa: S310
        text = resp.read().decode("utf-8")
    return set(CODE_RE.findall(text))


def load_pyproject_codes(path: Path) -> dict[str, list[str]]:
    with path.open("rb") as f:
        data = tomllib.load(f)
    lint = data.get("tool", {}).get("ruff", {}).get("lint", {})
    return {field: list(lint.get(field, [])) for field in CHECKED_FIELDS}


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "pyproject",
        nargs="?",
        default="pyproject.toml",
        type=Path,
        help="Path to pyproject.toml",
    )
    parser.add_argument(
        "--schema-url",
        default=SCHEMA_URL,
        help="Override the ruff.schema.json URL",
    )
    args = parser.parse_args()

    if not args.pyproject.is_file():
        print(f"error: {args.pyproject} not found", file=sys.stderr)
        return 2

    schema_codes = fetch_schema_codes(args.schema_url)
    any_missing = False
    for field, codes in load_pyproject_codes(args.pyproject).items():
        missing = [c for c in codes if c not in schema_codes]
        status = f"{len(codes)} total"
        if missing:
            any_missing = True
            print(f"{field}: {status}, missing from schema: {missing}")
        else:
            print(f"{field}: {status}, all known to schema")

    if any_missing:
        print(
            "\nThese codes will cause validate-pyproject-schema-store to reject"
            f" pyproject {args.pyproject}.",
            file=sys.stderr,
        )
        return 1
    print("\nAll ruff codes are present in the schema.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
