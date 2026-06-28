---
name: check-ruff-schema
description: Diagnose why henryiii/validate-pyproject-schema-store rejects a pyproject.toml because of unknown Ruff rule codes.
---

# check-ruff-schema

## What this skill does

The `validate-pyproject` pre-commit / prek hook validates `pyproject.toml` against
JSON schemas bundled in [`henryiii/validate-pyproject-schema-store`][vppss-repo].
Its `ruff.schema.json` in `resources/` enumerates known Ruff rule codes as an exhaustive enum,
so any code that Ruff has added but the schema store hasn't ingested yet causes
the whole `[tool.ruff.lint]` section to fail validation with an unhelpful error like:

> `tool.ruff.lint` cannot be validated by any definition

This skill pinpoints which specific Ruff codes are the culprit by diffing the
project's `extend-select` / `select` / `ignore` / `extend-ignore` /
`unfixable` lists against the `validate-pyproject-schema-store` schema's enum.

## When to run

Trigger whenever:

- The user says `prek run validate-pyproject`
  or `pre-commit run validate-pyproject` is failing on `tool.ruff.lint`.
- The user has just bumped Ruff (via `prek autoupdate`, Renovate, manual
  edit of `.pre-commit-config.yaml`) and wants to check compatibility.
- The user asks some version of "which of my Ruff rules aren't in the
  schema yet?" or "why is validate-pyproject complaining?"

## How to run

Invoke the bundled script against the repo's `pyproject.toml` (the default arg).
Note this won't rewrite the file, just print out a report
and gives a non-zero exit code if any codes are missing.

```bash
python scripts/check_ruff_codes.py  # Pass a path to check a specific pyproject.toml
```

To see what Ruff currently supports, use `ruff check --show-settings`.

### Codes vs. category prefixes

The schema enum accepts both full codes like `E501` and bare category prefixes
like `ANN`, `PTH`, `DTZ`. The script treats both as valid, a "missing" report
means the string literally isn't in the `validate-pyproject-schema-store` schema's enum,
not that Ruff doesn't know it.

[vppss-repo]: https://github.com/henryiii/validate-pyproject-schema-store
