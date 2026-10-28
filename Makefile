# Alex' Monokai Color Scheme: AX-Monokai
#
# AX-Monokai Makefile
#

VERSION = $(shell grep -F '"version":' package.json | cut -d'"' -f4)

SHELL = bash

SOURCE = AX-Monokai.conf

TARGETS = \
	out/ax-monokai.csv \
	out/ax-monokai.inc.sh \
	out/AX-Monokai.itermcolors \
	out/ghostty.conf \
	out/kitty.conf \
	out/vivaldi.zip \

ENVSUBST_TARGETS = \
	out/vscode-color-theme.json \
	out/vscode-terminal.json \

ENVSUBST_TARGETS_INI = \
	out/foot.ini \

OPTIONAL_TARGETS = \
	out/ax-monokai-$(VERSION).vsix \

ALL_TARGETS = $(TARGETS) $(ENVSUBST_TARGETS) $(ENVSUBST_TARGETS_INI) \
	tmp/vivaldi/settings.json \

TARGET_HEADER_TITLE = Alex' Monokai Color Scheme: AX-Monokai
TARGET_HEADER_FILE = Generated file ($(SOURCE) -> %s), do not edit!

VSCE_OPTIONS = --readme-path VSCode.md

# iTerm2 color keys ("_" becomes " ") and their AX-Monokai.conf variables.
ITERM2_COLORS = \
	Ansi_0_Color:color0 \
	Ansi_1_Color:color1 \
	Ansi_2_Color:color2 \
	Ansi_3_Color:color3 \
	Ansi_4_Color:color4 \
	Ansi_5_Color:color5 \
	Ansi_6_Color:color6 \
	Ansi_7_Color:color7 \
	Ansi_8_Color:color8 \
	Ansi_9_Color:color9 \
	Ansi_10_Color:color10 \
	Ansi_11_Color:color11 \
	Ansi_12_Color:color12 \
	Ansi_13_Color:color13 \
	Ansi_14_Color:color14 \
	Ansi_15_Color:color15 \
	Background_Color:background \
	Bold_Color:foreground \
	Cursor_Color:cursor \
	Cursor_Text_Color:cursor_text_color \
	Foreground_Color:foreground \
	Link_Color:color12 \
	Selected_Text_Color:selection_foreground \
	Selection_Color:selection_background \

all: $(ALL_TARGETS)

optional: $(OPTIONAL_TARGETS)

everything: all optional

check: all
	grep -Fq 'color15, #f5f4f1, f5, f4, f1, 245, 244, 241' out/ax-monokai.csv
	grep -Fq 'export cursor="ff5820"' out/ax-monokai.inc.sh
	grep -Fq 'palette = 13=#fb87ff' out/ghostty.conf
	grep -Fq '<real>0.17254902</real>' out/AX-Monokai.itermcolors
	grep -Fq 'selection_background #0a5d78' out/kitty.conf
	unzip -l out/vivaldi.zip | grep -Fq 'settings.json'
	grep -Fq '#fd971f' out/vscode-terminal.json
	grep -Fq '"colorWindowBg": "#1e1f1c",' tmp/vivaldi/settings.json
	grep -Fq '"badge.background": "#f92672",' out/vscode-color-theme.json
	grep -Fq '"foreground": "#e6db74",' out/vscode-color-theme.json
	! grep -Fq 'syntax' out/kitty.conf out/ghostty.conf
	@printf "\n\e[32;1mAll tests passed.\e[m\n\n"

clean:
	rm -fv $(ALL_TARGETS)
	rm -fr $(OPTIONAL_TARGETS)

distclean: clean
	rm -frv tmp out

maintainer-clean: distclean

.PHONY: all check clean distclean maintainer-clean palette

# Generators

out/ax-monokai.csv: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	echo "name, #hex_rgb, hex_r, hex_g, hex_b, dec_r, dec_g, dec_b" >"$@"
	grep -E "^[a-z]" $(SOURCE) | grep -Fv . | \
		while read name color; do \
			r=$$(echo $$color | cut -c2-3); g=$$(echo $$color | cut -c4-5); b=$$(echo $$color | cut -c6-7); \
			echo "$$name, $$color, $$r, $$g, $$b, $$((16#$$r)), $$((16#$$g)), $$((16#$$b))"; \
		done >>"$@"

out/ax-monokai.inc.sh: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	sed -En -e 's/^([_[:alnum:]]*) #?(.*)$$/export \1="\2"/p' "$(SOURCE)" >>"$@"

out/AX-Monokai.itermcolors: $(SOURCE) Makefile out/ax-monokai.inc.sh
	mkdir -p "$(@D)"
	. out/ax-monokai.inc.sh && { \
		printf '<?xml version="1.0" encoding="UTF-8"?>\n'; \
		printf '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n'; \
		printf "<!-- $(TARGET_HEADER_TITLE) -->\n"; \
		printf "<!-- $(TARGET_HEADER_FILE) -->\n" "$@"; \
		printf '<plist version="1.0">\n<dict>\n'; \
		for map in $(ITERM2_COLORS); do \
			key="$${map%%:*}"; var="$${map#*:}"; hex="$${!var}"; \
			printf '\t<key>%s</key>\n\t<dict>\n' "$${key//_/ }"; \
			LC_ALL=C awk -v r=$$((16#$${hex:0:2})) -v g=$$((16#$${hex:2:2})) -v b=$$((16#$${hex:4:2})) 'BEGIN { \
				printf "\t\t<key>Alpha Component</key>\n\t\t<real>1</real>\n"; \
				printf "\t\t<key>Blue Component</key>\n\t\t<real>%.8f</real>\n", b / 255; \
				printf "\t\t<key>Color Space</key>\n\t\t<string>sRGB</string>\n"; \
				printf "\t\t<key>Green Component</key>\n\t\t<real>%.8f</real>\n", g / 255; \
				printf "\t\t<key>Red Component</key>\n\t\t<real>%.8f</real>\n", r / 255; \
			}'; \
			printf '\t</dict>\n'; \
		done; \
		printf '</dict>\n</plist>\n'; \
	} >"$@"

out/ghostty.conf: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	grep -E "^[a-z]" "$(SOURCE)" | grep -Ev "^(gray|syntax_)" | sed -E \
		-e 's/^([_[:alnum:]]*) (.*)$$/\1 = "\2"/' \
		-e 's/_/-/g' -e 's/"//g' \
		-e 's/^cursor /cursor-color /' -e 's/cursor-text-color/cursor-text/' \
		-e 's/^color([[:digit:]]+) = (.*)/palette = \1=\2/' \
		>>"$@"

out/kitty.conf: $(SOURCE) Makefile
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	grep -E "^[a-z]" "$(SOURCE)" | grep -Ev "^(gray|syntax_)" >>"$@"

tmp/vivaldi/settings.json: $(SOURCE) Makefile out/ax-monokai.inc.sh
	mkdir -p "$(@D)"
	sh -c '. out/ax-monokai.inc.sh && cat assets/vivaldi.json | envsubst' >"$@"

out/vivaldi.zip: tmp/vivaldi/settings.json Makefile
	mkdir -p "$(@D)"
	zip -j out/vivaldi.zip tmp/vivaldi/settings.json

images/palette.svg: $(SOURCE) palette-svg.sh
	./palette-svg.sh "$(SOURCE)" >"$@"

palette: images/palette.svg

# Generic Generators

$(ENVSUBST_TARGETS): $(SOURCE) Makefile out/ax-monokai.inc.sh
	mkdir -p "$(@D)"
	bash -eu -o pipefail -c '. out/ax-monokai.inc.sh && cat assets/$(@F) | schema='\\\$$schema' envsubst' >"$@"

$(ENVSUBST_TARGETS_INI): $(SOURCE) Makefile out/ax-monokai.inc.sh
	mkdir -p "$(@D)"
	printf "# $(TARGET_HEADER_TITLE)\n" >"$@"
	printf "# $(TARGET_HEADER_FILE)\n\n" "$@" >>"$@"
	bash -eu -o pipefail -c '. out/ax-monokai.inc.sh && cat assets/$(@F) | envsubst' >>"$@"

out/vscode-color-theme.json: assets/vscode-color-theme.json
out/vscode-terminal.json: assets/vscode-terminal.json

out/foot.ini: assets/foot.ini

# VS Code

vscode: out/ax-monokai-$(VERSION).vsix

out/ax-monokai-$(VERSION).vsix: out/vscode-color-theme.json
	mkdir -p "$(@D)"
	vsce package $(VSCE_OPTIONS) -o out/ax-monokai-$(VERSION).vsix

vscode-install: out/ax-monokai-$(VERSION).vsix
	code --install-extension out/ax-monokai-$(VERSION).vsix

vscode-publish: out/vscode-color-theme.json
	vsce publish $(VSCE_OPTIONS)

.PHONY: vscode-install vscode-publish
