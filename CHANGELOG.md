# Changelog

All notable changes to mytop-saves. Versions follow [Semantic Versioning](https://semver.org/)
(in 0.x, only a new minor version may break the interface; CI's `semver` job enforces it).

## [0.3.2]

### Changed
- Use mytop-sync v0.2.3 and mytop-games v0.4.2 so saves, discovery and cancellable pairing share one set of core types.
  Consumer CI resolves the coordinated released siblings together before testing older application pins.

## [0.3.1]

### Changed
- The manifest names mytop-project and moves its pins to the renamed libraries (mytop-sync v0.2.2, mytop-games v0.4.1), so a
  program that pins this tag finds one source for each library. Same code otherwise.

## [0.3.0]

### Changed
- Rust 1.91 is the oldest these crates build with (`rust-version` 1.85 -> 1.91), as mytop-sync 0.2.1 needs: Ubuntu's newest
  versioned rustc in noble-updates and jammy-updates, which Pythia builds with (owner, 2026-11-12). The lock takes the
  newest compatible version of every dependency.
- Pins mytop-sync v0.2.1 (was v0.1.6) and mytop-games 0.4.0, its mytop-sync 0.2 release (was games-scan 0.3.1 by rev). saves-locate
  works with sync-core's and games-scan's types, so this is a new minor version. droidtop, droidtop-agent, mytop-games and
  mytop-plugins move to mytop-sync 0.2 together (mytop-project/tracker#573).

## [0.2.1]

### Changed
- Builds with Rust 1.85 (`rust-version` 1.89 → 1.85), the oldest Pythia builds with (Ubuntu's rustc-1.85, as
  Launchpad does; mytop-project/tracker#867). A new `msrv` CI job checks the workspace with 1.85, resolving dependencies
  to versions 1.85 can build, as a consumer's lock would.
- On mytop-sync v0.1.6 and games-scan 0.3.1, the releases that build with 1.85.

## [0.2.0]

### Changed
- **Breaking:** built on games-scan 0.3.0 (mytop-games, mytop-project/tracker#871 and #870), whose `Found` and `Scan` appear in
  this crate's interface (`Saves::restore`, `roots_for`), so a program moves to games-scan 0.3.0 with it. games-scan
  0.3.0 keys Epic games by catalog id and title-keyed games by `title2:`, and makes `Found` with `Found::new`.

## [0.1.3]

### Added
- CI's `semver` job: `cargo-semver-checks` against the last release, so a breaking change fails unless its version and
  this CHANGELOG say so (mytop-project/tracker#867).

### Changed
- `saves-locate`: built on mytop-sync v0.1.2 (cross-store links, mytop-project/tracker#798) and mytop-games v0.1.3, so
  droidtop-agent can take mytop-sync v0.1.2 and link one sync-core.

## [0.1.2]

### Changed
- Built on mytop-sync v0.1.1 and mytop-games v0.1.2, as 0.1.1 meant to be. 0.1.1 was released with its pins unchanged (still mytop-sync
  v0.1.0), so it is the same as 0.1.0; use 0.1.2.

## [0.1.1]

### Changed
- Built on mytop-sync v0.1.1 and mytop-games v0.1.1 (sync-core 0.1.1: a forgotten device is told it is not paired), so a program
  using this library and mytop-sync links one copy of sync-core.

## [0.1.0]

### Added
- `saves-locate`: save locations (the person's entries, Ludusavi's data, engine rules, Wine and Proton prefixes) and kept copies. Moved from droidtop-agent `0ec4110` `crates/saves` unchanged but for its package name (mytop-project/tracker#867 step 1).
