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

skills-sync:	## Regenerate this repo's Claude Code and Cursor skills from src/skills/.
	rm -rf .claude/skills .cursor/skills  # SEE: .skillshare-manifest.json note in .gitignore
	skillshare sync

SKILLSHARE_CONFIG := $(or $(XDG_CONFIG_HOME),$(HOME)/.config)/skillshare/config.yaml

# NOTE: linking all of src/skills/ as one folder makes skillshare's default flat naming
# sync each skill with the link name as a prefix (e.g. _configurator__git-commit),
# so link each skill on its own instead. This keeps flat naming, avoiding standard and
# prefixed naming, which skip both skills on a name collision (and prefixed requires copy mode).
# TODO: once https://github.com/runkids/skillshare/issues/964 is resolved, remove this target
skills-link:	## Link each src/skills/ skill into the global skillshare source, so other repos see plain names like git-commit.
	@if ! command -v skillshare >/dev/null || [[ ! -f $(SKILLSHARE_CONFIG) ]]; then \
		echo "No global skillshare setup, skipping skills-link"; exit 0; \
	fi; \
	source_dir=$$(skillshare status -g --json 2>/dev/null | jq -r .source.path) \
		|| source_dir=$(dir $(SKILLSHARE_CONFIG))skills; \
	changed=false; \
	for skill_md in "$(CURDIR)"/src/skills/*/SKILL.md; do \
		skill_dir=$$(dirname "$$skill_md"); name=$$(basename "$$skill_dir"); link=$$source_dir/$$name; \
		if [[ -L $$link && $$(readlink "$$link" || true) == */src/skills/"$$name" ]]; then \
			if [[ -e $$link ]]; then continue; fi; \
			skillshare unlink -g "$$name" >/dev/null; \
		fi; \
		if [[ -e $$link || -L $$link ]]; then \
			echo "$$link exists but isn't a link to $$skill_dir" >&2; exit 1; \
		fi; \
		skillshare link -g "$$skill_dir" --name "$$name" >/dev/null; \
		echo "Linked $$name into $$source_dir"; changed=true; \
	done; \
	for link in "$$source_dir"/*; do \
		if [[ -L $$link && ! -e $$link && $$(readlink "$$link") == */src/skills/* ]]; then \
			skillshare unlink -g "$$(basename "$$link")" >/dev/null; \
			echo "Unlinked $$(basename "$$link") from $$source_dir"; changed=true; \
		fi; \
	done; \
	if $$changed; then skillshare sync -g; fi
