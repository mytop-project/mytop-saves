#!/usr/bin/env bash
# Runs a cargo command in a program that uses mytop-saves, with mytop-saves taken from this checkout instead of the version the
# program's Cargo.lock holds, so a library change is built and tested where it is used (mytop-project/tracker#867 D2).
#
#   scripts/with-this-library.sh <the program's Cargo folder> <cargo subcommand and arguments...>
#
# Only the crates the program's Cargo.lock has are patched in, and `cargo update -p` moves them to this checkout
# first: a patch whose version differs from the locked one is otherwise dropped with a warning, and the program
# would build the old release instead (mytop-project/tracker#798). Any "was not used in the crate graph" fails the run.
# A program that does not use mytop-saves at all is skipped with a notice.
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
user="$1"; shift
url="https://github.com/mytop-project/mytop-saves"
sync=""
[ -n "${SYNC_DIR:-}" ] && sync="$(cd "$SYNC_DIR" && pwd)"
games=""
[ -n "${GAMES_DIR:-}" ] && games="$(cd "$GAMES_DIR" && pwd)"
cd "$user"
[ -f Cargo.lock ] || cargo generate-lockfile
if ! grep -q "$url" Cargo.lock; then
    echo "::notice::$(basename "$(pwd)") does not use mytop-saves; nothing to build against it"
    exit 0
fi
args=(); names=()
for spec in saves-locate:crates/locate; do
    name="${spec%%:*}"; path="${spec#*:}"
    grep -q "^name = \"$name\"$" Cargo.lock || continue
    args+=(--config "patch.\"$url\".$name.path=\"$here/$path\"")
    names+=(-p "$name")
done
# CI-only sibling checkouts keep shared types on one source during a coordinated release.
patch_sibling() {
    local base="$1" source="$2" dir name version
    [ -n "$base" ] || return 0
    for dir in "$base"/crates/*/; do
        name="$(sed -n 's/^name = "\(.*\)"$/\1/p' "$dir/Cargo.toml" | head -1)"
        grep -q "^name = \"$name\"$" Cargo.lock || continue
        args+=(--config "patch.\"$source\".$name.path=\"$dir\"")
        for version in $(awk -v n="$name" '$0 == "name = \"" n "\"" { getline; sub(/^version = "/, ""); sub(/"$/, ""); print }' Cargo.lock); do
            names+=(-p "$name@$version")
        done
    done
}
patch_sibling "$sync" https://github.com/mytop-project/mytop-sync
patch_sibling "$games" https://github.com/mytop-project/mytop-games
log="$(mktemp)"
cargo "${args[@]}" update "${names[@]}" 2>&1 | tee "$log"
cargo "${args[@]}" "$@" 2>&1 | tee -a "$log"
if grep -q "was not used in the crate graph" "$log"; then
    echo "::error::a patch of mytop-saves was not used: the program did not build against this commit" >&2
    exit 1
fi
