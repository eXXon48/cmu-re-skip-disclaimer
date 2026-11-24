# Skip disclaimer

`cmu-re-skip-disclaimer` · Revised Store package · Mazda CMU150, firmware 74.00.324A

Answers the start-up safety disclaimer at once, so it is never painted and the Home screen comes sooner.

## Why

At every start MMUI shows the safety disclaimer and the GUI runs a fixed 3.5 s timer before it answers `Timeout`; the Home screen comes in the same millisecond as that answer. The 3.5 s are a pure wait. This package answers at once and never paints the template. The boot animation still ends properly (`DisposeIntroVideo` is still sent), and MMUI still drives the context: the GUI only answers sooner.

## What it changes

| File | How | Why |
|---|---|---|
| `/jci/gui/apps/system/js/systemApp.js` | 3way | answers the disclaimer at once and never paints it |

`xml-node` edits address single nodes by XPath; `3way` edits are small diffs against the stock file. The Store merges them with every other installed package, refuses a real clash, and takes them back out on uninstall. No stock file is replaced as a whole.

## Install and uninstall

Install from the Revised Store app on the unit, then restart. Uninstall the same way: after the restart the unit behaves as stock again.

Safety: every change is recorded in the Store's vanilla index, so the boot-loop tripwire reverts it on its own if the unit fails to boot several times in a row. No package edits the boot script above the tripwire line.

## Requires

- `cmu-re-store (>= 0.13.4)`

## Part of

- `cmu-re-speedup-boot`

## Develop

```sh
sh test/run.sh                                  # manifest and payload checks
sh tools/mkpkg.sh <version> <rvp-pack> out.rvp   # build the .rvp
```

Releases: a `dev/vN` tag on `develop` gives a dev prerelease, a `vN` tag on `main` a release; CI packs the `.rvp` and attaches it to the GitHub release.
