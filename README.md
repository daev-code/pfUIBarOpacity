# pfUI Bar Opacity

Companion addon for [pfUI](https://github.com/brues-code/pfUI) (WoW 1.12): out-of-combat
opacity for pfUI's action bars, set per bar. In combat, and while the mouse is over a bar,
the bar is fully opaque.

## Usage

pfUI config (`/pfui`) > **Actionbar** > **OOC Opacity**:

- **Full Opacity On Mouseover** (on by default)
- **Default Opacity (All Bars)**: 10% - 100%. 100% (the default) means no fading.
- one dropdown per bar (Main, Top, Left, Right, Vertical, Paging, Stance 1-4, Shapeshift,
  Pet): **Default** (follow the value above, the default) or its own 10% - 100%.

Bars with pfUI's own **Autohide** enabled are left alone, because Autohide sets their
opacity itself.

The settings are saved in pfUI's config, so they follow pfUI profiles. pfUI's own files
aren't changed, so its folder stays a clean git clone.

## Install

- **With a launcher or git:** add `https://github.com/daev-code/pfUIBarOpacity` as an addon, or
  `git clone` it into `Interface\AddOns`. Keep the `.git` folder: launchers that install
  from git use it to fetch updates.
- **By hand:** copy this folder to `Interface\AddOns\pfUIBarOpacity`. Updates are then manual too.
