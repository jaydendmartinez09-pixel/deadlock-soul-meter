# Deadlock Soul Meter (Shiv, Wraith, Holliday)

An econ HUD that compares you to the average **Eternus** player of the hero you're on. It shows next to
**SOULS** (bottom-left):

- **Soul rank D to SSS**: your net worth (souls + items) vs the Eternus average at this match time. Same as Eternus = **A**.
- **AHEAD +1.2k (108%)  1,480/min**: how far ahead or behind you are, your % of Eternus, and your souls/min over the last 60 s
- **You 15,200 / Eternus Wraith 15,715 @15:00**: your net worth next to the Eternus average right now
- Unsecured-souls timer, **FARM!** alarm (big blinking pill + alarm sound after 20 s without souls), **SPEND** reminder, +souls popups

| Rank | Your net worth vs Eternus |
|---|---|
| D | under 70% |
| C | 70-85% |
| B | 85-95% |
| A | 95-110% |
| S | 110-125% |
| SS | 125-145% |
| SSS | 145%+ |

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

It finds Deadlock through Steam, downloads `SoulMeter_v14.zip` from this repo, checks its SHA-256, and copies the mod
into `game\citadel\addons` as a free `pakNN_dir.vpk`. It replaces an older copy, including the old Wraith Soul Meter,
in the same slot. Restart Deadlock afterwards. Mods must be enabled (Deadlock Mod Manager does that). To update, run
the same command again. To uninstall, delete the `pakNN_dir.vpk` the installer printed.

Manual install: unzip `SoulMeter_v14.zip` and copy `Soul Meter.vpk` to `Deadlock\game\citadel\addons\pak88_dir.vpk`
(any free number).

Notes: the rank/FARM!/spend sounds come from a separate Shiv mod, so on its own the meter is silent. Bot matches give
passive souls, so FARM! only shows when you really stop earning (Sandbox mode is the easy place to see it). The meter
loads through the game's match-start layout, so a big Deadlock HUD patch may need an updated build.
