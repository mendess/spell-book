#!/bin/bash

set -euo pipefail

INSTALL_DIR="/opt/nvim"
SYMLINK="/usr/local/bin/nvim"
TARBALL="nvim-linux-x86_64.tar.gz"
URL="https://github.com/neovim/neovim/releases/download/stable/${TARBALL}"

info() { printf '\033[1;34m--- %s ---\033[0m\n' "$*"; }
err()  { printf '\033[1;31merror: %s\033[0m\n' "$*" >&2; }

tmpdir="$(mktemp -d)"
trap 'rm -vrf "$tmpdir"' EXIT
cd "$tmpdir"

info "Downloading ${TARBALL}"
if ! wget -q --show-progress "$URL"; then
    err "failed to download ${URL}"
    err "check your network connection and that the release exists"
    exit 1
fi

info "Extracting"
if ! tar xzf "$TARBALL"; then
    err "failed to extract ${TARBALL} (corrupt download?)"
    exit 1
fi

extracted="nvim-linux-x86_64"
if [[ ! -x "${extracted}/bin/nvim" ]]; then
    err "expected binary not found at ${extracted}/bin/nvim"
    err "the release archive structure may have changed"
    exit 1
fi

info "Testing staged binary"
if ! "./${extracted}/bin/nvim" --version; then
    err "staged nvim binary failed to run"
    err "you may be missing a runtime dependency (try: ldd ${extracted}/bin/nvim)"
    exit 1
fi

info "Installing to ${INSTALL_DIR}"
if [[ -d "$INSTALL_DIR" ]]; then
    info "removing previous installation at $INSTALL_DIR"
    sudo rm -rf "$INSTALL_DIR"
fi
if ! sudo mv -v "$extracted" "$INSTALL_DIR"; then
    err "failed to install to ${INSTALL_DIR}"
    err "check permissions and that no process is using files in ${INSTALL_DIR}"
    exit 1
fi

info "Symlinking ${SYMLINK}"
if ! sudo ln -vsf "${INSTALL_DIR}/bin/nvim" "$SYMLINK"; then
    err "failed to create symlink at ${SYMLINK}"
    exit 1
fi

info "Done"
info "Installed: $(nvim --version | head -1)"
info "Location:  $(command -v nvim)"
