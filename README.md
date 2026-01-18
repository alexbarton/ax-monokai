# AX-Monokai Color Scheme

The *AX‑Monokai* project defines a unified color scheme inspired by various
*Monokai*, *Molokai*, and related theme variants.

All colors are specified in a single configuration file (`AX-Monokai.conf`).
Based on this file, the project provides a `Makefile` that can automatically
generate configuration files for a wide range of applications, including
terminal emulators, text editors, web browsers, and more.

## Colors

### Color palette

The following 16 colors are used for the standard ANSI palette, 8 regular/dark
colors, and 8 bright variants:

| Dark    | Bright  | Comments
|---------|---------|---------------------------------------------------------
| #1e1f1c | #6a6d63 | Monokai Pro Classic / +33%
| #f92672 | #fb6ea1 | Monokai Pro Classic + Base16 Monokai / +33%
| #a6e22e | #c3ec73 | Monokai Pro Classic + Base16 Monokai / +33%
| #fd971f | #feb969 | Base16 Monokai / +33%
| #2c64e0 | #7297ea | Alex / +33%
| #f94cff | #fb87ff | Alex / +33%
| #16b1cf | #66d9ef | -33% / Monokai Pro Classic + Base16 Monokai
| #c2c2bf | #f5f4f1 | Monokai Pro Classic / Base16 Monokai

### Shades of grey

The following 16 grayscale levels are defined:

| Color   | Comment
|---------|-------------------------------------------------------------------
| #090906 | -
| #1e1f1c | color0
| #272822 | background
| #3e3d32 | -
| #414339 | -
| #51584e | -
| #6a6d63 | color8
| #787b72 | -
| #868981 | -
| #969791 | -
| #a4a5a0 | -
| #b2b3af | -
| #c2c2bf | foreground
| #d3d2cf | -
| #e4e3e0 | -
| #f5f4f1 | color15

### Special colors

These colors are derived from other projects and used in some themes:

| Color   | Comment
|---------|-------------------------------------------------------------------
| #e6db74 | Derived from the VS Code "Monokai Operator" syntax theme
| #f44747 | Derived from the VS Code "Monokai Operator" syntax theme
| #ae81ff | Derived from the VS Code "Monokai Operator" syntax theme

## Installation

1. All core definitions of the *AX-Monokai* theme are stored in a somewhat
   generic format in the `AX-Monokai.conf` file.
2. A `Makefile` for the `make` command is used to generate all theme files in
   the `out/` directory.
3. You *manually* install the themes or theme snippets from the `out/` directory
   into your local configuration files and folders as you like.

Therefore you have to:

1. Get the code :-)
2. Run `make`
3. Find the generated files from the `out/` directory
4. Copy the ones you need into your local configuration.

More detailed notes for some targets are outlined below.

### VS Code

Prerequisites:

- [VS Code Extension Manager](https://github.com/microsoft/vscode-vsce)

```bash
npm install -g @vscode/vsce
```

Build and package the extension:

```bash
# Update the version number in "package.json" as needed. Then:
make check
vsce package -o out/
```

Install the VS Code extension locally on your machine:

```bash
code --install-extension out/ax-monokai-${version}.vsix
```
