# pfUI Bar Opacity

Lets [pfUI](https://github.com/brues-code/pfUI)'s action bars fade out of combat, with a
separate setting per bar if you want one. In combat, or while your mouse is over a bar, the
bar is fully visible. For WoW 1.12.

## Usage

The settings are in pfUI's config (`/pfui`), under Actionbar > OOC Opacity.

- **Full Opacity On Mouseover** is on by default.
- **Default Opacity (All Bars)** goes from 10% to 100%. At 100%, the default, nothing fades.
- Each bar has its own dropdown (Main, Top, Left, Right, Vertical, Paging, Stance 1-4,
  Shapeshift, Pet). Leave it on **Default** to use the value above, or pick a percentage
  for that bar.

Bars that use pfUI's Autohide are skipped, since Autohide already controls their opacity.

Your choices are saved in pfUI's config, so they follow your pfUI profile. pfUI's own files
aren't modified.

## Install

Add `https://github.com/daev-code/pfUIBarOpacity` to your launcher, or `git clone` it into
`Interface\AddOns`. Leave the `.git` folder in place: launchers that install from git need
it to pull updates.

You can also copy the folder to `Interface\AddOns\pfUIBarOpacity` yourself, but then
you'll need to update it yourself too.
