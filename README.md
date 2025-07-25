# configurator

[![github](https://img.shields.io/badge/GitHub-%23121011.svg?logo=github&logoColor=white)](https://github.com/jamesbraza/configurator)
![ci](https://github.com/jamesbraza/configurator/actions/workflows/lint-test.yaml/badge.svg)
[![repo status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
![license](https://img.shields.io/badge/License-MIT-blue.svg)
[![python](https://img.shields.io/badge/python-3.11+-blue?style=flat&logo=python&logoColor=white)](https://www.python.org)

Tooling and configurations for the creation of better software.

Goals of this repository:

- Providing one configured toolchain that is fluent and valuable in
  research, development, and production settings.
- Resembling an [awesome list](https://github.com/topics/awesome) for developer tooling.
- Being strict so that developers can think less, feel more relaxed,
  and be proud of their code.
- Not being stylistically restrictive or arduous to comply with.

Aspirations of this repository:

- Supporting auto-propagation of tooling configuration
  changes across repositories.

<!--TOC-->

- [Non-Python Tool Integrations](#non-python-tool-integrations)
  - [Autoformatters](#autoformatters)
  - [Linters](#linters)
  - [Markdown](#markdown)
- [Python Tool Integrations](#python-tool-integrations)
  - [Autoformatters](#autoformatters-1)
  - [Testing](#testing)
  - [Linters](#linters-1)
  - [Type Checking](#type-checking)
  - [Dependencies](#dependencies)
  - [Packaging](#packaging)
  - [Configuration](#configuration)
- [Helper Scripts](#helper-scripts)
  - [Changing Repos](#changing-repos)
  - [`.gitignore` Creation](#gitignore-creation)

<!--TOC-->

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
<tr><td>

[`sqlfluff`](https://github.com/sqlfluff/sqlfluff)
([docs](https://docs.sqlfluff.com/en/stable/))

</td><td>

Yes

</td><td>

Autoformatting SQL

</td><td>

`pre-commit` hook

</td><td>

</td></tr>
<tr><td>

[`djlint`](https://github.com/djlint/djlint)
([docs](https://www.djlint.com/))

</td><td>

No

</td><td>

Autoformatting templates like Jinja, Nunjucks, etc.

</td><td>

`pre-commit` hook

</td><td>

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

### Markdown

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`markdown-toc-creator`](https://github.com/jsh9/markdown-toc-creator)

</td><td>

Yes, `>=0.0.8`

</td><td>

Markdown table of contents

</td><td>

`pre-commit` hook

</td><td></td></tr>
<tr><td>

[`markdownlint-cli`](https://github.com/igorshubovych/markdownlint-cli)

</td><td>

Yes

</td><td>

Lint Markdown files

</td><td>

`pre-commit` hook

</td><td>

There's also [`markdownlint-cli2`](https://github.com/DavidAnson/markdownlint-cli2)
but its configuration system does not support `pyproject.toml`.

</td></tr>
<tr><td>

[`markdown-link-check`](https://github.com/tcort/markdown-link-check)

</td><td>

No

</td><td>

Confirm Markdown links are not dead.

</td><td>

`pre-commit` hook

</td><td>

Slows down `pre-commit` due to link visitation.

</td></tr>
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
[`hug_parens_with_braces_and_square_brackets` preview option][1].

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

[1]: https://black.readthedocs.io/en/stable/the_black_code_style/future_style.html#preview-style

### Testing

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`pytest`](https://github.com/pytest-dev/pytest)
([docs](https://docs.pytest.org/en/stable/))

</td><td>

Yes

</td><td>

Test runner

</td><td>

Command line

</td><td></td></tr>
<tr><td>

[`pytest-xdist`](https://github.com/pytest-dev/pytest-xdist)
([docs](https://pytest-xdist.readthedocs.io/en/stable/))

</td><td>

Yes

</td><td>

Test runner parallelism via multiprocessing

</td><td>

`pytest` plugin

</td><td></td></tr>
<tr><td>

[`pytest-timer`](https://github.com/skudriashev/pytest-timer)

</td><td>

Yes

</td><td>

Timing tests

</td><td>

`pytest` plugin

</td><td>

Use the `colorama` extra for colored output.

</td></tr>
<tr><td>

[`pytest-sugar`](https://github.com/Teemu/pytest-sugar)

</td><td>

Yes

</td><td>

User-friendly `pytest` output

</td><td>

`pytest` plugin

</td><td></td></tr>
<tr><td>

[`pytest-subtests`](https://github.com/pytest-dev/pytest-subtests)

</td><td>

Yes

</td><td>

Supporting subtesting

</td><td>

`pytest` plugin

</td><td>

Will be deprecated after
[pytest-dev/pytests-subtests#71](https://github.com/pytest-dev/pytest-subtests/issues/71).

</td></tr>
<tr><td>

[`pytest-rerunfailures`](https://github.com/pytest-dev/pytest-rerunfailures)

</td><td>

No

</td><td>

Easy decorator `pytest.mark.flaky` for flaky tests

</td><td>

`pytest` plugin

</td><td>

A third party alternative is [`flaky`](https://github.com/box/flaky).

</td></tr>
<tr><td>

[`pytest-timeout`](https://github.com/pytest-dev/pytest-timeout)

</td><td>

No

</td><td>

Terminate long-running tests

</td><td>

`pytest` plugin

</td><td>

Useful when there's unsolved race conditions.

</td></tr>
<tr><td>

[`pytest-recording`](https://github.com/kiwicom/pytest-recording)

</td><td>

No

</td><td>

Cache HTTP requests as cassettes

</td><td>

`pytest` plugin

</td><td>

Maintained successor to [`pytest-vcr`](https://github.com/ktosiek/pytest-vcr).

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

### Dependencies

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[Renovate](https://github.com/renovatebot/renovate)
([docs](https://docs.renovatebot.com/))

</td><td>Yes</td><td>

Automated dependency updates

</td><td>

GitHub Actions

</td><td>

Pair with `renovate-config-validator`, run via its `pre-commit` hook
from <https://github.com/renovatebot/pre-commit-hooks>,
to validate the configuration file.

</td></tr>
<tr><td>

[`uv`](https://github.com/astral-sh/uv)
([docs](https://docs.astral.sh/uv/))

</td><td>

Yes, `>=0.3.0`

</td><td>

Python environment and dependency management

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

[`pipdeptree`](https://github.com/tox-dev/pipdeptree)

</td><td>No</td><td>

Auditing requirements

</td><td>

Command line

</td><td>

Alternative to `uv tree`.

</td></tr>
</table>

### Packaging

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`validate-pyproject`](https://github.com/abravalheri/validate-pyproject)
([docs](https://validate-pyproject.readthedocs.io/en/latest/))

</td><td>No</td><td>

Validating `pyproject.toml` configuration(s)

</td><td>

`pre-commit` hook

</td><td>

By specifying
[`validate-pyproject-schema-store`](https://github.com/henryiii/validate-pyproject-schema-store)
in `additional_dependencies`,
configurations for `mypy`, `ruff`, `uv`, etc. will also be validated.

See Notes for `validate-pyproject-schema-store` below.

</td></tr>
<tr><td>

[`validate-pyproject-schema-store`](https://github.com/henryiii/validate-pyproject-schema-store)

</td><td>Yes</td><td>

Validating tool-specific `pyproject.toml` configuration(s)

</td><td>

`pre-commit` hook

</td><td>

This tool's versions change frequently because it tracks upstream tools' schemae.
It also depends on `validate-pyproject`,
so to avoid frequently updating the
min version in `validate-pyproject`'s `additional_dependencies`,
use this as the `pre-commit` hook.

</td></tr>
<tr><td>

[`check-sdist`](https://github.com/henryiii/check-sdist)

</td><td>Yes</td><td>

Checking SDist build

</td><td>

`pre-commit` hook

</td><td>

Unclear if this tool is a subset of `build-and-inspect-python-package` below.

</td></tr>
<tr><td>

[`build-and-inspect-python-package`](https://github.com/hynek/build-and-inspect-python-package)

</td><td>No</td><td>

Checking SDist, wheel, and README.

</td><td>

GitHub Actions

</td><td></td></tr>
<tr><td>

[`ini2toml`](https://github.com/abravalheri/ini2toml)
([docs](https://ini2toml.readthedocs.io/en/latest/))

</td><td>No</td><td>

Migration from `setup.cfg`/`ini` to `pyproject.toml`

</td><td>

Command line

</td><td></td></tr>
</table>

### Configuration

<table>
<tr><th>Tool</th><th>Used Here?</th><th>Description</th><th>Invocation</th><th>Notes</th></tr>
<tr><td>

[`nitpick`](https://github.com/andreoliwa/nitpick)
([docs](https://nitpick.readthedocs.io/en/latest/))

</td><td>No</td><td>

Propagating configurations

</td><td>

`pre-commit` hook

</td><td>

Had tons of potential,
but `nitpick` itself lacked the configurability for adoption here.

</td></tr>
</table>

## Helper Scripts

### Changing Repos

<!-- markdownlint-disable line-length -->

```shell
pathver() {
    : 'print PATH and VERsion; optionally assert version file matches'
    source=$(type -p "$1")
    if [[ -z $source ]]; then
        source=$(type "$1")
    fi
    actual_version=$("$1" --version 2>&1 | gsed -En 's/(.+ )?(v?[0-9]+\.[0-9]+\.[^ ]+).*/\2/p')
    echo "$source $actual_version"
}

a() {
    : 'Activate virtual environment after changing directory'

    if [[ ${1-} ]]; then
        directory=~/code/$1
    else
        directory=.
    fi

    if ! [[ -d $directory ]]; then
        echo "ERROR: $directory is not a directory"
        return 1
    fi

    cd "$directory" || return 1

    [[ ${CONDA_PREFIX-} && $(command -v conda) ]] && conda deactivate
    if [[ ${VIRTUAL_ENV-} ]]; then
        might_be_file=$(command -v deactivate)
        if [[ $might_be_file ]]; then
            if [[ -f $might_be_file ]]; then
                # pyenv-virtualenv wants this
                # shellcheck disable=SC1091
                source deactivate
            else
                deactivate
            fi
        fi
    fi

    if [[ -f .venv/bin/activate ]]; then
        # shellcheck disable=SC1091
        source .venv/bin/activate
        pathver python .python-version
    elif [[ -d conda ]]; then
        # shellcheck disable=SC1090
        source ~/miniconda3/etc/profile.d/conda.sh
        conda activate "$(basename "$PWD")"
        pathver python .python-version
    fi

    if [[ -f .nvmrc ]]; then
        pathver node .nvmrc
    fi
}
```

This was taken from
<https://github.com/biobuddies/helicopyter/blob/main/.biobuddies/includes.bash>.

### `.gitignore` Creation

```bash
curl -s \
  https://raw.githubusercontent.com/github/gitignore/master/{Global/Vim,Global/JetBrains,Global/VisualStudioCode,Global/macOS,Python}.gitignore \
  > .gitignore
```

<!-- markdownlint-enable line-length -->
