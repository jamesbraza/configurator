# configurator

Tool with configurations for the creation of better software.

## Non-Python Tool Integrations

### Autoformatters

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`prettier`](https://github.com/prettier/prettier)
([docs](https://prettier.io/docs/en/))

</td><td>

Yes, `>=3`

</td><td>

Autoformatting files like JSON, Markdown, and YAML.

</td><td>

`pre-commit` hook [mirror](https://github.com/rbubley/mirrors-prettier)

</td><td>

Configure to use four space indent to match [Python PEP 8](https://peps.python.org/pep-0008/).

</td></tr>
<tr><td>

[`toml-sort`](https://github.com/pappasam/toml-sort)
([docs](https://toml-sort.readthedocs.io/en/latest/))

</td><td>

Yes

</td><td>

Formatting TOML

</td><td>

`pre-commit` hook

</td><td></td></tr>
<tr><td>

[`pre-commit-hooks`](https://github.com/pre-commit/pre-commit-hooks)

</td><td>

Yes

</td><td>

Miscellaneous file cleanup like end of file newlines

</td><td>

`pre-commit` hook

</td><td>

When adding rules, try to avoid duplication of other tools like `ruff`.

</td></tr>
</table>

### Linters

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`yamllint`](https://github.com/adrienverge/yamllint)
([docs](https://yamllint.readthedocs.io/en/stable/))

</td><td>

Yes, `>=1.33`

</td><td>

Ensuring high quality YAML

</td><td>

`pre-commit` hook

</td><td>

Configure to coexist with YAML autoformatting of `prettier`.

</td></tr>
<tr><td>

[`codespell`](https://github.com/codespell-project/codespell)

</td><td>

Yes, `>=2.3.0`

</td><td>

Checking for typos

</td><td>

`pre-commit` hook

</td><td></td></tr>
<tr><td>

[`hadolint`](https://github.com/hadolint/hadolint)

</td><td>

Yes

</td><td>

`Dockerfile` following best practices

</td><td>

`pre-commit` hook

</td><td></td></tr>
</table>

## Python Tool Integrations

### Autoformatters

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`black`](https://github.com/psf/black)
([docs](https://black.readthedocs.io/en/stable/))

</td><td>

Yes, `>=24.2.0`, `jupyter` extra

</td><td>

`black` code standard

</td><td>

`pre-commit` hook [mirror](https://github.com/psf/black-pre-commit-mirror)

</td><td>

I am a fan of the
[`hug_parens_with_braces_and_square_brackets` preview option](https://black.readthedocs.io/en/stable/the_black_code_style/future_style.html#preview-style).

</td></tr>
<tr><td>

[`docformatter`](https://github.com/PyCQA/docformatter)
([docs](https://docformatter.readthedocs.io/en/latest/))

</td><td>

Yes,`>=1.7`

</td><td>

Formatting docstrings

</td><td>

`pre-commit` hook

</td><td></td></tr>
<tr><td>

[`nb-clean`](https://github.com/srstevenson/nb-clean)

</td><td>

Yes,`>=2.4`

</td><td>

Cleaning Jupyter Notebooks

</td><td>

`pre-commit` hook

</td><td>

Paired with `black[jupyter]`,
this makes PRs with Jupyter Notebooks easier to read.

</td></tr>
</table>

### Linters

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`pylint`](https://github.com/pylint-dev/pylint)
([docs](https://pylint.readthedocs.io/en/latest/))

</td><td>

Yes, `>=3`

</td><td>

Static analysis

</td><td>

Command line

</td><td>

Since `pylint` is slow,
pairing with the
[`ruff` partial reimplementation](https://github.com/astral-sh/ruff/issues/970)
will ensure that `pylint` runs are more effective.

</td></tr>
<tr><td>

[`ruff`](https://github.com/astral-sh/ruff)
([docs](https://docs.astral.sh/ruff/))

</td><td>

Yes,`>=0.6`

</td><td>

Static analysis

</td><td>

`pre-commit` hook [mirror](https://github.com/charliermarsh/ruff-pre-commit)

</td><td>

Partially reimplements many other tools like `flake8` and `pylint`.

</td></tr>
<tr><td>

[`refurb`](https://github.com/dosisod/refurb)
([docs](https://github.com/dosisod/refurb/tree/master/docs))

</td><td>

Yes,`>=2`

</td><td>

Static analysis

</td><td>

Command line

</td><td>

`refurb` development outpaces its
[`ruff` reimplementation](https://github.com/astral-sh/ruff/issues/1348).

</td></tr>
<tr><td>

[`flake8`](https://github.com/PyCQA/flake8)
([docs](https://flake8.pycqa.org/en/latest/))

</td><td>

Yes

</td><td>

Static analysis

</td><td>

`pre-commit` hook

</td><td>

Pair with [`Flake8-pyproject`](https://pypi.org/project/Flake8-pyproject/)
for configuration in `pyproject.toml`.

Mostly reimplemented by `ruff`,
but still useful for partially reimplemented or not yet reimplemented plugins.

</td></tr>
<tr><td>

[`pydoclint`](https://github.com/jsh9/pydoclint)
([docs](https://jsh9.github.io/pydoclint/))

</td><td>

Yes

</td><td>

Checking docstrings

</td><td>

`flake8` plugin

</td><td>

`pydoclint` was created in response to a
[stalled `ruff` reimplementation](https://github.com/astral-sh/ruff/issues/458).

</td></tr>
</table>

### Type Checking

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`mypy`](https://github.com/python/mypy)
([docs](https://mypy.readthedocs.io/en/stable/))

</td><td>

Yes, `>=1.8`

</td><td>

Static type checking

</td><td>

`pre-commit` hook [mirror](https://github.com/pre-commit/mirrors-mypy#using-mypy-with-pre-commit)

</td><td>

Some opt-in rules like `ignore-without-code` and `truthy-iterable` are enabled.

</td></tr>
<tr><td>

[`typeguard`](https://github.com/agronholm/typeguard)
([docs](https://typeguard.readthedocs.io/en/latest/))

</td><td>

Yes

</td><td>

Runtime type checking

</td><td>

`pytest` plugin (built into `typeguard`),
with `--typeguard-packages=mypackage` command line argument

</td><td></td></tr>
<tr><td>

[`beartype`](https://github.com/beartype/beartype)
([docs](https://beartype.readthedocs.io/en/latest/))

</td><td>No</td><td>

Runtime type checking

</td><td>

[`pytest` plugin `pytest-beartype`](https://pypi.org/project/pytest-beartype/),
with `beartype_packages = "mypackage"` configured

</td><td>

As of Feb. 20th in 2024,
Python 3.10's `typing.TypeAlias` was unsupported.

</td></tr>
<tr><td>

[`mypy_clean_slate`](https://github.com/geo7/mypy_clean_slate)

</td><td>

No, `>=0.2.5`

</td><td>

Adopting `mypy` on a preexisting codebase

</td><td>

Command line

</td><td>

Equivalent of `ruff --add-noqa`, but for `mypy`.

</td></tr>
</table>

### Requirements

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`uv`](https://github.com/astral-sh/uv)

</td><td>

Yes, `>=0.3.0`

</td><td>

Requirements compilation

</td><td>

Command line

</td><td></td></tr>
<tr><td>

`pip-compile` from
[`pip-tools`](https://github.com/jazzband/pip-tools)
([docs](https://pip-tools.readthedocs.io/en/stable/))

</td><td>

No, `>=7.4.0`

</td><td>

Requirements compilation

</td><td>

Command line

</td><td></td></tr>
<tr><td>

[`flake8-requirements`](https://github.com/arkq/flake8-requirements)

</td><td>Yes</td><td>

Checking requirements

</td><td>

`flake8` plugin (CI only)

</td><td>

If invoking `flake8` as part of `pre-commit`,
run this only in CI because this check isn't relevant for most commits.

</td></tr>
<tr><td>

[`validate-pyproject`](https://github.com/abravalheri/validate-pyproject)

</td><td>Yes</td><td>

Validating `pyproject.toml` configuration(s)

</td><td>

`pre-commit` hook

</td><td>

By specifying
[`validate-pyproject-schema-store`](https://github.com/henryiii/validate-pyproject-schema-store)
in `additional_dependencies`,
configurations for `mypy`, `ruff`, `uv`, etc. will also be validated.

</td></tr>
</table>

## Git

### `.gitignore` Creation

```bash
curl -s \
  https://raw.githubusercontent.com/github/gitignore/master/{Global/Vim,Global/JetBrains,Global/VisualStudioCode,Global/macOS,Python}.gitignore \
  > .gitignore
```
