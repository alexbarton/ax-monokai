#!/usr/bin/env bash
#
# Alex' Monokai Color Scheme: AX-Monokai
# palette-svg.sh: Generate an SVG image showing all colors of the scheme.

set -euo pipefail

if [[ $# -ne 1 ]]; then
	echo "$0 <AX-Monokai.conf>" >&2
	exit 1
fi

declare -A c
while read -r var val; do
	c[${var}]="${val}"
done < <(grep -E '^[a-z_0-9]+ #[0-9a-fA-F]{6}$' "$1")

# Special colors, not (yet) part of the master configuration file.
c[yellow]="#e6db74"
c[error]="#f44747"
c[purple]="#ae81ff"

cols=8
sw=104		# swatch width
sh=56		# swatch height
gap=8
margin=24
width=$(( 2 * margin + cols * sw + (cols - 1) * gap ))
y=0

# Return a readable text color for the given background color.
text_color() {
	local hex="${1#\#}"
	local r=$(( 16#${hex:0:2} )) g=$(( 16#${hex:2:2} )) b=$(( 16#${hex:4:2} ))
	if (( 299 * r + 587 * g + 114 * b > 140000 )); then
		echo "${c[gray1]}"
	else
		echo "${c[gray15]}"
	fi
}

heading() {
	y=$(( y + 32 ))
	body+=$(printf '  <text x="%d" y="%d" class="h">%s</text>' "${margin}" "${y}" "$1")$'\n'
	y=$(( y + 12 ))
}

# Draw one row of swatches. Arguments: "<variable>:<label>" pairs.
row() {
	local i=0 x var label color fg
	for var in "$@"; do
		label="${var#*:}"; label="${label//_/ }"; var="${var%%:*}"
		color="${c[${var}]}"
		fg="$(text_color "${color}")"
		x=$(( margin + i * (sw + gap) ))
		body+=$(printf '  <rect x="%d" y="%d" width="%d" height="%d" rx="6" fill="%s" stroke="%s"/>\n' \
			"${x}" "${y}" "${sw}" "${sh}" "${color}" "${c[gray4]}"
		printf '  <text x="%d" y="%d" fill="%s" class="l">%s</text>\n' \
			$(( x + 8 )) $(( y + 20 )) "${fg}" "${label}"
		printf '  <text x="%d" y="%d" fill="%s" class="v">%s</text>' \
			$(( x + 8 )) $(( y + sh - 10 )) "${fg}" "${color}")$'\n'
		i=$(( i + 1 ))
	done
	y=$(( y + sh + gap ))
}

body=""
heading "ANSI colors (regular)"
row color0:0_black color1:1_red color2:2_green color3:3_yellow color4:4_blue color5:5_magenta color6:6_cyan color7:7_white
heading "ANSI colors (bright)"
row color8:8_br_black color9:9_br_red color10:10_br_green color11:11_br_yellow color12:12_br_blue color13:13_br_magenta color14:14_br_cyan color15:15_br_white
heading "Shades of gray"
row gray0:gray0 gray1:gray1 gray2:gray2 gray3:gray3 gray4:gray4 gray5:gray5 gray6:gray6 gray7:gray7
row gray8:gray8 gray9:gray9 gray10:gray10 gray11:gray11 gray12:gray12 gray13:gray13 gray14:gray14 gray15:gray15
heading "Special colors"
row background:bg foreground:fg cursor:cursor cursor_text_color:cursor_text \
	selection_background:sel_bg yellow:yellow error:error purple:purple
height=$(( y + margin - gap ))

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Alex' Monokai Color Scheme: AX-Monokai -->
<!-- Generated file (${1} -> palette.svg), do not edit! -->
<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
  <style>
    text { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
    .h { fill: ${c[foreground]}; font-size: 15px; font-weight: bold; }
    .l { font-size: 12px; opacity: 0.8; }
    .v { font-size: 13px; }
  </style>
  <rect width="100%" height="100%" rx="10" fill="${c[background]}"/>
${body}</svg>
EOF
