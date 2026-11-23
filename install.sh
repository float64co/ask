#!/bin/sh
# Install (symlink) or uninstall `ask` in ~/.local/bin.
#   ./install.sh              install
#   ./install.sh --uninstall  remove
# Override the target directory with BIN_DIR=/some/dir ./install.sh
set -eu

here=$(cd "$(dirname "$0")" && pwd -P)
src="$here/ask"
bin_dir=${BIN_DIR:-$HOME/.local/bin}
dest="$bin_dir/ask"

case "${1:-}" in
    ""|--install) mode=install ;;
    --uninstall|-u) mode=uninstall ;;
    -h|--help) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "usage: $0 [--uninstall]" >&2; exit 2 ;;
esac

if [ "$mode" = uninstall ]; then
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        rm "$dest"
        echo "removed $dest"
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "$dest exists but isn't a link to $src; leaving it alone" >&2
        exit 1
    else
        echo "nothing to remove ($dest not found)"
    fi
    echo "config in ${XDG_CONFIG_HOME:-$HOME/.config}/ask was left in place"
    exit 0
fi

[ -f "$src" ] || { echo "can't find $src" >&2; exit 1; }

if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ -L "$dest" ]; then
        rm "$dest"
    else
        echo "$dest already exists and isn't a symlink; refusing to overwrite" >&2
        exit 1
    fi
fi

mkdir -p "$bin_dir"
chmod +x "$src"
ln -s "$src" "$dest"
echo "installed $dest -> $src"

# Warn if the target directory isn't on PATH.
case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) echo "warning: $bin_dir is not on your PATH; add this to your shell rc:"
       echo "    export PATH=\"$bin_dir:\$PATH\"" ;;
esac

# Check Python dependencies.
if ! python3 -c 'import ollama, ddgs, httpx, bs4, rich' 2>/dev/null; then
    echo "warning: some Python dependencies are missing. Install them with:"
    flags=--user
    for f in /usr/lib/python3*/EXTERNALLY-MANAGED; do
        [ -e "$f" ] && flags="--user --break-system-packages" && break
    done
    echo "    python3 -m pip install $flags -r \"$here/requirements.txt\""
    echo "(or use a virtualenv / pipx if you'd rather not touch system Python)"
fi
