# Sessielogboek — Concerten

> Eén entry per Claude Code-sessie. Nieuwste boven. Lees de laatste 3 entries aan het begin van elke sessie om context te herstellen.

---

## 2026-05-12 — Sessie 2: Fase 0 / Stap 5 — Xcode-project staat, eerste PR-cyclus voltooid

**Wat gedaan:**
- Sessiestart-protocol gevolgd na 2 weken pauze (CLAUDE.md + PROGRESS.md gelezen, status gecheckt).
- Xcode 15.4 staat geïnstalleerd; macOS' active developer directory omgeschakeld van Command Line Tools naar Xcode (`xcode-select -p` wijst nu naar `/Applications/Xcode.app/Contents/Developer`); `xcodebuild -version` werkt.
- iOS Simulator-runtime: Cas gestart in App Store / Xcode Settings; in mijn checks nog niet bevestigd zichtbaar onder `/Library/Developer/CoreSimulator/Profiles/Runtimes/`. Openstaande verificatie voor Sessie 3.
- Eerste echte feature-branch aangemaakt: `chore/setup-xcode-project`.
- Xcode-project `Concerten` aangemaakt via de wizard:
  - Template: iOS App
  - Bundle Identifier: `nl.casdenbraber.Concerten`
  - Interface: SwiftUI (volgens ADR-001)
  - Language: Swift
  - Storage: None (Supabase komt later — ADR-002)
  - Tests ingeschakeld (unit- + UI-testtargets)
- Xcode-project staat in submap `Concerten/` binnen de werkmap; documentatie blijft op rootniveau.
- "Create Git repository on my Mac"-checkbox bewust uitgezet om geen tweede git-repo te krijgen.
- Commit `ef6b21d` op de feature-branch: 12 nieuwe bestanden, 788 toevoegingen.
- PR #1 geopend, beoordeeld door Cas, gemerged via squash naar `main`, branch verwijderd: https://github.com/cas-sudo/concerten/pull/1
- Eerste volledige git-workflow-cyclus volgens werkafspraak 7 voltooid (branch → commit → push → PR → akkoord → squash-merge → branch verwijderd).
- Sessie-einde-PROGRESS-update zelf ook via een tweede mini-PR (`chore/update-progress-sessie-2`) — om werkafspraak 7 te respecteren.

**Bestanden aangemaakt/gewijzigd:**
- `Concerten/Concerten.xcodeproj/` (Xcode-projectbestanden, inclusief `project.pbxproj`)
- `Concerten/Concerten/ConcertenApp.swift` (app entry point)
- `Concerten/Concerten/ContentView.swift` (eerste scherm)
- `Concerten/Concerten/Assets.xcassets/` (asset catalog)
- `Concerten/Concerten/Preview Content/` (SwiftUI previews)
- `Concerten/ConcertenTests/` (unit-testtarget)
- `Concerten/ConcertenUITests/` (UI-testtarget)
- `PROGRESS.md` (deze entry — via PR #2)

**Openstaande vragen / acties:**
- **iOS Simulator-runtime:** in deze sessie nog niet zichtbaar in mijn checks. Bij sessiestart Sessie 3 opnieuw verifiëren — als de download in de tussentijd is afgerond, kunnen we direct door naar bouwen.
- **App nog niet gebouwd en niet gedraaid.** Doel voor Sessie 3.
- **Cas:** Supabase-account aanmaken — gebeurt samen in een latere sessie (Stap 6).
- **Cas + ik:** Apple Developer Program-enrollment ($99/jaar) — alleen wanneer we naar TestFlight willen, niet nu.
- **Architectuur:** authenticatieflow definitief vaststellen wanneer we Supabase opzetten (huidige aanname: e-mail + magic link).

**Volgende sessie (Sessie 3 — Stap 5b: app draaien):**
- Verifieer iOS Simulator-runtime status. Als klaar: door naar bouwen.
- Bouw de app en draai hem in de simulator (vereist de runtime).
- Als runtime nog niet klaar: wachten of overschakelen naar build-test op fysieke iPhone (vereist Apple Developer-setup — eventueel "Personal Team" voor lokaal testen zonder enrollment).
- Daarna in een aparte sessie: Supabase-account aanmaken en Supabase iOS SDK toevoegen aan het project (Stap 6 in `ROADMAP.md`).

---

## 2026-04-30 — Sessie 1: Fase 0 / Stap 1–4 — fundering gelegd

**Wat gedaan:**
- Werkomgeving van Cas geverifieerd: macOS 14.3.1 ✅, Apple ID ✅, Command Line Tools ✅, Homebrew 5.1.8 ✅, Git 2.52.0 ✅.
- Xcode bleek niet geïnstalleerd; Cas heeft de download via App Store gestart (loopt op de achtergrond, ~15 GB).
- Git globaal geconfigureerd: `Cas den Braber <casdenbraber@gmail.com>`.
- GitHub-repo verkregen: `https://github.com/cas-sudo/concerten` (privé, leeg).
- Werknaam gekozen: **`concerten`** (definitieve productnaam parkeren tot vlak voor App Store-publicatie).
- Supabase-account: nog niet aangemaakt — staat op de planning voor de volgende sessie.
- `gh` (GitHub CLI) geïnstalleerd via Homebrew, eenmalig ingelogd via browser-flow voor authenticatie bij toekomstige push/PR-acties.
- Project root geïnitialiseerd: `git init`, `main` als hoofdbranch, remote `origin` gekoppeld aan GitHub-repo.
- Documentatie-bestanden aangemaakt: `CLAUDE.md`, `ARCHITECTURE.md`, `ROADMAP.md`, `DECISIONS.md`, `PROGRESS.md`, `README.md`, `.gitignore`.
- Vier ADRs vastgelegd: ADR-001 (SwiftUI), ADR-002 (Supabase), ADR-003 (Setlist.fm + Spotify, géén Bandsintown), ADR-004 (Git workflow).
- Eerste commit op `main` gepusht naar GitHub.

**Bestanden aangemaakt:**
- `CLAUDE.md`
- `ARCHITECTURE.md`
- `ROADMAP.md`
- `DECISIONS.md`
- `PROGRESS.md` (dit bestand)
- `README.md`
- `.gitignore`

**Openstaande vragen / acties:**
- **Cas:** Xcode-installatie afronden (download loopt). Daarna eenmalig Xcode openen om "Additional Components" binnen te halen.
- **Cas:** Supabase-account aanmaken — gebeurt samen in volgende sessie wanneer we het Supabase-project opzetten.
- **Cas + ik:** Apple Developer Program-enrollment ($99/jaar). Pas wanneer we naar TestFlight willen — *niet* nu.
- **Architectuur:** authenticatieflow definitief vaststellen wanneer we Supabase opzetten (huidige aanname: e-mail + magic link).

**Volgende sessie:**
- Fase 0 — **Stap 5: Xcode-project aanmaken**.
- Voorwaarden: Xcode klaar met installeren en eenmalig geopend voor componenten.
- Doel: lege SwiftUI-app die start in de Xcode-simulator op de Mac. Fysieke iPhone komt in de stap erna.
- Eerste echte feature-branch (`chore/setup-xcode-project`) — niet meer direct op `main`.
