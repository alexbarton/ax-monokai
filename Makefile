# Alex' Monokai Color Scheme: AX-Monokai
# 2024-11-16, alex@barton.de
#
# AX-Monokai Makefile
#

SOURCE = AX-Monokai.conf

TARGETS = \
	out/ax-monokai.inc.sh \
	out/kitty.conf \

ENVSUBST_TARGETS = \
	out/vscode-terminal.json \

ALL_TARGETS = $(TARGETS) $(ENVSUBST_TARGETS) \

TARGET_HEADER_TITLE = Alex' Monokai Color Scheme: AX-Monokai
TARGET_HEADER_FILE = Generated file ($(SOURCE) -> %s), do not edit!

all: $(TARGETS) $(ENVSUBST_TARGETS)

check: all

clean:
	rm -fv $(TARGETS)
	rm -frv out

distclean: clean

maintainer-clean: distclean

.PHONY: all check clean distclean maintainer-clean

# Generators

out/ax-monokai.inc.sh: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	grep "^[a-z]" AX-Monokai.conf | sed -Ee 's/^([_[:alnum:]]*) (.*)$$/export \1="\2" /' >>"$@"

out/kitty.conf: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	grep "^[a-z]" AX-Monokai.conf >>"$@"

# Generic Generators

$(ENVSUBST_TARGETS): $(SOURCE) Makefile out/ax-monokai.inc.sh
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	sh -c '. out/ax-monokai.inc.sh && cat assets/$(@F) | envsubst' >>"$@"
