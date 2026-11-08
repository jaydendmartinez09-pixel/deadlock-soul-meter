# Deadlock Soul Meter (Shiv, Wraith, Holliday)

An econ HUD that compares you to the average **Eternus** player of the hero you're on. It shows next to
**SOULS** (bottom-left):

- **You 15,200 / Eternus Wraith 15,715 @15:00**: your net worth (souls + items) vs the Eternus average at the same match time
- **Soul rank D to SSS**: your souls/min over the last 60 s vs the Eternus pace
- Unsecured-souls timer, **FARM!** idle alarm, **SPEND** reminder, +souls popups

It detects your hero and hides on heroes it has no data for.

Eternus net worth (deadlock-api.com, ranked, Eternus average badge, last 30 days):

| Hero | 6:00 | 12:00 | 15:00 | 20:00 | 30:00 | 40:00 |
|---|---|---|---|---|---|---|
| Wraith | 4,184 | 11,389 | 15,715 | 22,912 | 37,751 | 52,449 |
| Shiv | 3,960 | 9,972 | 13,367 | 19,148 | 32,055 | 45,243 |
| Holliday | 3,965 | 9,679 | 13,074 | 18,826 | 31,950 | 44,526 |

## Install

Paste into PowerShell:

```powershell
irm https://raw.githubusercontent.com/jaydendmartinez09-pixel/deadlock-soul-meter/main/install.ps1 | iex
```

It finds Deadlock through Steam, downloads `SoulMeter_v13.zip` from this repo, checks its SHA-256, and copies the mod
into `game\citadel\addons` as a free `pakNN_dir.vpk`. It replaces an older copy, including the old Wraith Soul Meter,
in the same slot. Restart Deadlock afterwards. Mods must be enabled (Deadlock Mod Manager does that). To update, run
the same command again. To uninstall, delete the `pakNN_dir.vpk` the installer printed.

Manual install: unzip `SoulMeter_v13.zip` and copy `Soul Meter.vpk` to `Deadlock\game\citadel\addons\pak88_dir.vpk`
(any free number).

Notes: the rank/idle/spend sounds come from a separate Shiv mod, so on its own the meter is silent. The meter loads
through the game's match-start layout, so a big Deadlock HUD patch may need an updated build.
