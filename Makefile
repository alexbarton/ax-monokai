# Alex' Monokai Color Scheme: AX-Monokai
#
# AX-Monokai Makefile
#

VERSION = $(shell grep -F '"version":' package.json | cut -d'"' -f4)

SOURCE = AX-Monokai.conf

TARGETS = \
	out/ax-monokai.inc.sh \
	out/ghostty.conf \
	out/kitty.conf \
	out/vivaldi.zip \

ENVSUBST_TARGETS = \
	out/vscode-color-theme.json \
	out/vscode-terminal.json \

OPTIONAL_TARGETS = \
	out/ax-monokai-$(VERSION).vsix \

ALL_TARGETS = $(TARGETS) $(ENVSUBST_TARGETS) \
	tmp/vivaldi/settings.json \

TARGET_HEADER_TITLE = Alex' Monokai Color Scheme: AX-Monokai
TARGET_HEADER_FILE = Generated file ($(SOURCE) -> %s), do not edit!

VSCE_OPTIONS = --readme-path VSCode.md

all: $(TARGETS) $(ENVSUBST_TARGETS)

optional: $(OPTIONAL_TARGETS)

everything: all optional

check: all
	grep -Fq 'export cursor="#ff5820"' out/ax-monokai.inc.sh
	grep -Fq 'palette = 13=#fb87ff' out/ghostty.conf
	grep -Fq 'selection_background #0a5d78' out/kitty.conf
	unzip -l out/vivaldi.zip | grep -Fq 'settings.json'
	grep -Fq '#fd971f' out/vscode-terminal.json
	grep -Fq '"colorWindowBg": "#1e1f1c",' tmp/vivaldi/settings.json
	grep -Fq '"badge.background": "#f92672",' out/vscode-color-theme.json
	@printf "\n\e[32;1mAll tests passed.\e[m\n\n"

clean:
	rm -fv $(ALL_TARGETS)
	rm -fr $(OPTIONAL_TARGETS)

distclean: clean
	rm -frv tmp out

maintainer-clean: distclean

.PHONY: all check clean distclean maintainer-clean

# Generators

out/ax-monokai.inc.sh: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	sed -En -e 's/^([_[:alnum:]]*) (.*)$$/export \1="\2"/p' "$(SOURCE)" >>"$@"

out/ghostty.conf: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	grep "^[a-fh-z]" "$(SOURCE)" | sed -E \
		-e 's/^([_[:alnum:]]*) (.*)$$/\1 = "\2"/' \
		-e 's/_/-/g' -e 's/"//g' \
		-e 's/^cursor /cursor-color /' -e 's/cursor-text-color/cursor-text/' \
		-e 's/^color([[:digit:]]+) = (.*)/palette = \1=\2/' \
		>>"$@"

out/kitty.conf: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	grep "^[a-fh-z]" "$(SOURCE)" >>"$@"

tmp/vivaldi/settings.json: $(SOURCE) Makefile out/ax-monokai.inc.sh
	mkdir -p "$(@D)"
	sh -c '. out/ax-monokai.inc.sh && cat assets/vivaldi.json | envsubst' >>"$@"

out/vivaldi.zip: tmp/vivaldi/settings.json Makefile
	zip -j out/vivaldi.zip tmp/vivaldi/settings.json

# Generic Generators

$(ENVSUBST_TARGETS): $(SOURCE) Makefile out/ax-monokai.inc.sh
	mkdir -p "$(@D)"
	bash -eu -o pipefail -c '. out/ax-monokai.inc.sh && cat assets/$(@F) | schema='\\\$$schema' envsubst' >"$@"

out/vscode-color-theme.json: assets/vscode-color-theme.json
out/vscode-terminal.json: assets/vscode-terminal.json

# VS Code

vscode: out/ax-monokai-$(VERSION).vsix

out/ax-monokai-$(VERSION).vsix: out/vscode-color-theme.json
	vsce package $(VSCE_OPTIONS) -o out/ax-monokai-$(VERSION).vsix

vscode-install: out/ax-monokai-$(VERSION).vsix
	code --install-extension out/ax-monokai-$(VERSION).vsix

vscode-publish: out/vscode-color-theme.json
	vsce publish $(VSCE_OPTIONS)

.PHONY: vscode-install vscode-publish
