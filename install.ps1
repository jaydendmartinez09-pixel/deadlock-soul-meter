# Deadlock Soul Meter v14 installer (econ HUD vs the Eternus average for Shiv, Wraith and Holliday).
# Run in PowerShell:  irm https://raw.githubusercontent.com/jaydendmartinez09-pixel/deadlock-soul-meter/main/install.ps1 | iex
# Finds Deadlock through Steam, downloads the mod, checks its SHA-256, and copies it into
# game\citadel\addons as a free pakNN_dir.vpk (or over an older copy, including the old Wraith Soul Meter).
# Uninstall: delete that file.
function Install-SoulMeter {
    $ErrorActionPreference = 'Stop'
    $zipUrl  = 'https://raw.githubusercontent.com/jaydendmartinez09-pixel/deadlock-soul-meter/main/SoulMeter_v14.zip'
    $zipHash = '4F0E26FE43CA55110CCD25666695878A4798C25A56311DCBCE6982C820F200E6'
    $vpkHash = 'FC6C923D96A0CDF631D09A7B2222107FC25A55C7BED7F17BCC1C64E7857CF0EF'
    try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072 } catch {}

    # 1. find game\citadel (Steam registry -> every Steam library in libraryfolders.vdf)
    $citadel = $env:WSM_CITADEL
    if (-not $citadel) {
        $roots = @()
        foreach ($k in 'HKCU:\Software\Valve\Steam', 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam', 'HKLM:\SOFTWARE\Valve\Steam') {
            try {
                $p = Get-ItemProperty $k -ErrorAction Stop
                if ($p.SteamPath) { $roots += $p.SteamPath }
                if ($p.InstallPath) { $roots += $p.InstallPath }
            } catch {}
        }
        $roots += 'C:\Program Files (x86)\Steam'
        $libs = @()
        foreach ($r in ($roots | ForEach-Object { $_ -replace '/', '\' } | Select-Object -Unique)) {
            $libs += $r
            $vdf = Join-Path $r 'steamapps\libraryfolders.vdf'
            if (Test-Path $vdf) {
                foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) { $libs += ($m.Groups[1].Value -replace '\\\\', '\') }
            }
        }
        foreach ($l in ($libs | Select-Object -Unique)) {
            $c = Join-Path $l 'steamapps\common\Deadlock\game\citadel'
            if (Test-Path (Join-Path $c 'gameinfo.gi')) { $citadel = $c; break }
        }
    }
    if (-not $citadel -or -not (Test-Path (Join-Path $citadel 'gameinfo.gi'))) {
        Write-Host "Couldn't find Deadlock. Set the folder and run again, e.g.:" -ForegroundColor Red
        Write-Host '  $env:WSM_CITADEL = "D:\SteamLibrary\steamapps\common\Deadlock\game\citadel"'
        return
    }
    Write-Host "Deadlock: $citadel"

    # 2. mods must be enabled (gameinfo.gi searches citadel/addons; Deadlock Mod Manager sets this up)
    $gi = Get-Content (Join-Path $citadel 'gameinfo.gi') -Raw
    if ($gi -notmatch 'citadel/addons') {
        Write-Host "Heads up: mods aren't enabled in this Deadlock install (gameinfo.gi has no citadel/addons)." -ForegroundColor Yellow
        Write-Host "Install Deadlock Mod Manager (or add 'Game citadel/addons' to SearchPaths) or the mod won't load." -ForegroundColor Yellow
    }
    $addons = Join-Path $citadel 'addons'
    New-Item -ItemType Directory -Force $addons | Out-Null

    # 3. download + verify
    $tmp = Join-Path $env:TEMP ('dsm_' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Force $tmp | Out-Null
    try {
        $zip = Join-Path $tmp 'dsm.zip'
        Write-Host "Downloading Soul Meter v14..."
        Invoke-WebRequest -UseBasicParsing -Uri $zipUrl -OutFile $zip
        if ((Get-FileHash $zip -Algorithm SHA256).Hash -ne $zipHash) { Write-Host "Download is corrupt (hash mismatch), nothing installed." -ForegroundColor Red; return }
        Expand-Archive -Path $zip -DestinationPath $tmp -Force
        $vpk = Join-Path $tmp 'Soul Meter.vpk'
        if ((Get-FileHash $vpk -Algorithm SHA256).Hash -ne $vpkHash) { Write-Host "Mod file is corrupt (hash mismatch), nothing installed." -ForegroundColor Red; return }

        # 4. slot: reuse an older copy of this mod, else the first free pakNN (88 up, then down)
        $dest = $null
        foreach ($f in (Get-ChildItem $addons -Filter 'pak??_dir.vpk' -File)) {
            if ($f.Length -lt 5MB -and [IO.File]::ReadAllText($f.FullName).Contains('wraith_soul_meter')) { $dest = $f.FullName; break }
        }
        if (-not $dest) {
            $used = @{}
            foreach ($f in (Get-ChildItem $addons -File)) { foreach ($m in [regex]::Matches($f.Name, 'pak(\d\d)')) { $used[[int]$m.Groups[1].Value] = $true } }
            foreach ($n in (@(88..98) + @(87..10))) { if (-not $used[$n]) { $dest = Join-Path $addons ('pak{0:D2}_dir.vpk' -f $n); break } }
        }
        if (-not $dest) { Write-Host "No free pak slot in $addons." -ForegroundColor Red; return }
        Copy-Item $vpk $dest -Force
        Copy-Item (Join-Path $tmp 'README.txt') (Join-Path $addons 'Soul Meter README.txt') -Force
        Remove-Item (Join-Path $addons 'Wraith Soul Meter README.txt') -ErrorAction SilentlyContinue
        Write-Host "Installed Soul Meter v14 -> $dest" -ForegroundColor Green
        if (Get-Process deadlock -ErrorAction SilentlyContinue) { Write-Host "Restart Deadlock to load it." -ForegroundColor Yellow }
        Write-Host "Play Shiv, Wraith or Holliday: the meter sits right of SOULS (bottom-left). To remove it, delete $dest"
    } finally {
        Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Install-SoulMeter
