# SEE: http://redsymbol.net/articles/unofficial-bash-strict-mode/
SHELL := /bin/bash -euo pipefail

GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
END_COLOR=$(shell tput sgr0)

# NOTE: for these colors to work, you need sed = gnu-sed, which can be
# installed via brew install gnu-sed and adding the following to your RC file:
# export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
help:	## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST) | \
		sed -E 's/^([a-zA-Z0-9%_-]+):\s+(\w+)/$(GREEN)\1$(END_COLOR):~\u\2/' | \
		sed -E 's/(.*)(EX:)(.*)/\1$(YELLOW)\2\3$(END_COLOR)/' | \
		column -s '~' -t

ruff-preview-sync:	## Sync tool.ruff.lint.extend-select in pyproject.toml to Ruff's preview rules.
	@trap 'rm -f .ruff-preview.tmp pyproject.toml.tmp' EXIT; \
	uv run ruff rule --all --output-format=json \
		| jq -r '.[] | select(.preview == true) | "    \"\(.code)\","' \
		| sort > .ruff-preview.tmp; \
	awk '/^extend-select = \[$$/ { print; while ((getline l < ".ruff-preview.tmp") > 0) print l; skip=1; next } skip && /^\]$$/ { print; skip=0; next } skip { next } { print }' pyproject.toml > pyproject.toml.tmp; \
	mv pyproject.toml.tmp pyproject.toml; \
	echo "$(GREEN)Synced extend-select to Ruff preview rules$(END_COLOR)"
