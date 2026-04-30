# Concerten — projecthandboek voor Claude Code

> Dit bestand lees jij (Claude) bij elke sessiestart. Het bevat de werkafspraken, de huidige fase, en de leesvolgorde voor toekomstige sessies. Cas is product owner en niet-technisch — hij stuurt op product, jij doet alle uitvoering.

## In één oogopslag

**Wat we bouwen:** een iOS-app voor het loggen van concerten en festivals. Kerngebruik in Fase 1: ik was hier, deze artiest zag ik, deze setlist hoorde ik, dit is mijn cijfer. Latere fases: diepe stats, social, mensen ontmoeten op concerten.

**Werknaam:** `concerten` (definitieve productnaam wordt vlak voor App Store-publicatie gekozen).

**Werkmap:** `/Users/casdenbraber/bezorgen Jan/concerten`

**GitHub-repo:** `https://github.com/cas-sudo/concerten` (privé)

---

## Werkafspraken — niet onderhandelbaar

1. **Taal.** Alle uitleg, commits en docs in plain Dutch. Code, bestandsnamen en variabelen in Engels.
2. **Autonomie.** Maak technische keuzes zelfstandig en log ze in `DECISIONS.md`. Vraag Cas alleen om input bij **productimpact**, **geld**, of **fysieke handeling** (Apple-portaal, telefoon aansluiten, betaling).
3. **Stop tussen fasen.** Nooit doorrazen. Aan einde van elke fase: stoppen, samenvatten, akkoord vragen.
4. **Bestaande patronen.** Refereer expliciet aan bestaande patronen wanneer je nieuwe code toevoegt. Bouw nooit een tweede manier om hetzelfde te doen.
5. **Documenteer onderweg.** Elke architecturale keuze direct in `DECISIONS.md` als ADR. Elke sessie eindigt met een `PROGRESS.md`-entry.
6. **Werkverdeling.** Jij doet alles wat in code, terminal of via een API kan. Cas doet alles wat fysiek of in een grafische interface buiten Xcode moet (Apple Developer-enrollment, App Store Connect, telefoon aansluiten, betaling). Voor Cas' taken: stap-voor-stap instructies in plain Dutch en wachten op bevestiging.
7. **Git workflow.** Nooit direct op `main`. Voor elke taak een nieuwe branch (`feature/...`, `fix/...`, `chore/...`), commits in plain Dutch, push, PR via `gh pr create`, merge na akkoord van Cas. Eénmalige uitzondering was de allereerste documentatie-commit op 2026-04-30.

---

## Tech stack

- **Frontend:** SwiftUI voor iOS 17+
- **Backend:** Supabase (Postgres + Auth + Storage + Realtime)
- **Externe API's:** Setlist.fm (setlists, venues), Spotify (artist-data, foto's)
- **Versiebeheer:** Git + GitHub (privé repo)
- **IDE:** Xcode + Claude Code (in aparte terminal)
- **Distributie:** TestFlight → App Store
- **CLI-tooling:** `gh` (GitHub CLI), Homebrew

Detail en motivering per keuze: zie `ARCHITECTURE.md` en `DECISIONS.md`.

---

## Huidige fase

**Fase 0 — Setup & fundering.**

**Status (2026-04-30):** Stap 1 (werkomgeving), Stap 2 (werknaam), Stap 3 (documentatie + git init + push) en Stap 4 (rapportage) afgerond. **Volgende stap: Stap 5 — Xcode-project aanmaken**, in een aparte sessie.

Voorwaarden voordat Stap 5 kan beginnen:
- Xcode klaar met installeren (download is gestart op 2026-04-30, ~15 GB).
- Cas heeft Xcode eenmalig geopend en de "Additional Components" laten installeren.

---

## Openstaande acties (lange termijn)

- **Cas:** Supabase-account aanmaken — gebeurt samen in een vervolgsessie van Fase 0.
- **Cas + ik:** Apple Developer Program-enrollment ($99/jaar). Alleen wanneer we naar TestFlight willen — dus niet nu.
- **Architectuur:** authenticatieflow definitief vaststellen wanneer we Supabase opzetten (huidige aanname: e-mail + magic link).
- **Naam:** definitieve productnaam kiezen vlak voor App Store-publicatie (Fase 1-eind).

Voor de meest actuele lijst: zie de laatste entry in `PROGRESS.md`.

---

## Sessiestart-protocol — vóór je iets anders doet

1. Lees dit bestand (`CLAUDE.md`) volledig.
2. Lees de laatste 3 entries van `PROGRESS.md`.
3. Lees de relevante secties van `ARCHITECTURE.md` voor de feature van deze sessie.
4. Vat in 3 zinnen plain Dutch samen waar we staan.
5. Vraag Cas wat de focus van deze sessie is.

Pas daarna ga je werken.

---

## Sessie-einde-protocol — vóór afsluiten

1. Schrijf nieuwe entry in `PROGRESS.md` (datum, wat gedaan, bestanden, openstaande vragen, volgende sessie).
2. Werk eventuele nieuwe ADRs bij in `DECISIONS.md`.
3. Commit & push (of merge PR) volgens git workflow.
4. Vat in plain Dutch samen wat er is gebeurd.

---

## Roadmap (kort)

- **Fase 0 — Setup.** DoD: lege app start op Cas' iPhone.
- **Fase 1 — Solo concertlogboek.** DoD: TestFlight met Cas + 5 vrienden, een maand.
- **Validatie-poort:** <3/5 actief = Fase 1 fixen, géén Fase 2.
- **Fase 2 — Diepe stats.** DoD: TestFlight 25 gebruikers.
- **Fase 3 — Social fundering.** DoD: App Store-launch.
- **Fase 4 — Mensen ontmoeten.** Voorwaarde: Fase 3 echte gebruikers.

Detail per fase: zie `ROADMAP.md`.

---

## Belangrijke documenten

| Bestand | Wat het is |
|---|---|
| `CLAUDE.md` | Dit bestand. Werkafspraken + sessieprotocollen + huidige fase. |
| `ARCHITECTURE.md` | Tech stack, datamodel, integraties, git workflow. |
| `ROADMAP.md` | Vier fases met definition of done en validatie-poort. |
| `DECISIONS.md` | Architecturale beslissingen in ADR-stijl. |
| `PROGRESS.md` | Sessielogboek. Eén entry per sessie. |
| `README.md` | Korte publieke beschrijving. |
| `.gitignore` | Wat git negeert. |
