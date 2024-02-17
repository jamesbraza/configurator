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
