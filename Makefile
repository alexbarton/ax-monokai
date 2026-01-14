# Alex' Monokai Color Scheme: AX-Monokai
#
# AX-Monokai Makefile
#

SOURCE = AX-Monokai.conf

TARGETS = \
	out/ax-monokai.inc.sh \
	out/ghostty.conf \
	out/kitty.conf \
	out/vivaldi.zip \

ENVSUBST_TARGETS = \
	out/vscode-terminal.json \

ALL_TARGETS = $(TARGETS) $(ENVSUBST_TARGETS) \
	tmp/vivaldi/settings.json \

TARGET_HEADER_TITLE = Alex' Monokai Color Scheme: AX-Monokai
TARGET_HEADER_FILE = Generated file ($(SOURCE) -> %s), do not edit!

all: $(TARGETS) $(ENVSUBST_TARGETS)

check: all
	grep -Fq 'export cursor="#ff5820"' out/ax-monokai.inc.sh
	grep -Fq 'palette = 13=#fb87ff' out/ghostty.conf
	grep -Fq 'selection_background #0a5d78' out/kitty.conf
	unzip -l out/vivaldi.zip | grep -Fq 'settings.json'
	grep -Fq '#fd971f' out/vscode-terminal.json
	grep -Fq '"colorWindowBg": "#1e1f1c",' tmp/vivaldi/settings.json
	@printf "\n\e[32;1mAll tests passed.\e[m\n\n"

clean:
	rm -fv $(TARGETS)
	rm -frv tmp out

distclean: clean

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
	bash -eu -o pipefail -c '. out/ax-monokai.inc.sh && cat assets/$(@F) | envsubst' >"$@"
