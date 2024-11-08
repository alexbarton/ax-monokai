# Alex' Monokai Color Scheme: AX-Monokai
# 2024-11-16, alex@barton.de
#
# AX-Monokai Makefile
#

SOURCE = AX-Monokai.conf

TARGETS = \
	out/kitty.conf \

TARGET_HEADER_TITLE = Alex' Monokai Color Scheme: AX-Monokai
TARGET_HEADER_FILE = Generated file ($(SOURCE) -> %s), do not edit!

all: $(TARGETS) 

check: all

clean:
	rm -fv $(TARGETS)
	rm -frv out

distclean: clean

maintainer-clean: distclean

.PHONY: all check clean distclean maintainer-clean

# Generators

out/kitty.conf: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	grep "^[a-z]" AX-Monokai.conf >>"$@"
