# Sessielogboek — Concerten

> Eén entry per Claude Code-sessie. Nieuwste boven. Lees de laatste 3 entries aan het begin van elke sessie om context te herstellen.

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
