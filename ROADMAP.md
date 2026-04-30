# Roadmap — Concerten

> Vier fases. We laten ons door dit document leiden om scope te bewaken. "Komt later" is hier expliciet om te voorkomen dat we Fase 1 vertroebelen met Fase 2/3-werk.

---

## Fase 0 — Setup & fundering

**Doel:** een werkende ontwikkelomgeving en een lege app die op Cas' iPhone start.

**Stappen:**
1. Werkomgeving verifiëren (Mac, Xcode, Homebrew, git, accounts). ✅ (2026-04-30)
2. Werknaam kiezen. ✅ (2026-04-30 — `concerten`)
3. Project root + documentatie + eerste git-push. ✅ (2026-04-30)
4. Stoppen en rapporteren. ✅ (2026-04-30)
5. Xcode-project aanmaken. *Volgende sessie.*
6. Supabase-project aanmaken + iOS SDK koppelen.
7. Apple Developer-enrollment ($99/jaar — pas wanneer we TestFlight willen).
8. Lege app op Cas' fysieke iPhone draaien.

**Definition of Done:** een lege SwiftUI-app start op Cas' iPhone, gekoppeld aan een leeg Supabase-project, broncode in GitHub-repo.

**Niet in deze fase:** features, schermen, content, gebruikers.

---

## Fase 1 — Solo concertlogboek

**Doel:** Cas en 5 vrienden kunnen een maand lang concerten loggen, cijfers geven, foto's uploaden, en een basis-overzicht zien.

**Features:**
- Inloggen (Supabase Auth, magic link).
- Concert toevoegen via Setlist.fm-zoektocht (artiest, venue, datum en setlist worden automatisch gevuld).
- Cijfer geven (1–10) voor optreden en geluid (apart).
- Optioneel: notitie + wie er meeging + foto's uploaden.
- Eenvoudig overzicht: aantal concerten, top artiesten, totaal nummers live gehoord, eerste/laatste keer per artiest, top venues.

**Definition of Done:** TestFlight-build die Cas + 5 vrienden een maand kunnen gebruiken voor concerten loggen en simpel terugkijken.

**Niet in deze fase:** diepe stats-pagina's (Fase 2), social features (Fase 3), aankomende-concerten-ontdekken.

---

## Validatie-poort tussen Fase 1 en Fase 2

> Dit is een **harde** poort, niet een suggestie.

**Criterium:** als minder dan **3 van de 5 testgebruikers** na een maand nog actief concerten loggen, gaan we **niet** door naar Fase 2. In plaats daarvan: terug naar Fase 1, achterhalen waarom mensen afhaken, en de basis-feature beter maken.

**Doel van de poort:** voorkomen dat we maandenlang stats-pagina's bouwen voor een product dat niemand gebruikt.

---

## Fase 2 — Diepe stats & ratings (stats.fm-stijl)

**Doel:** rijk uitgewerkte statistieken en deelbare overzichten.

**Features:**
- Aantal keer per artiest gezien (lijst, sortering, filter).
- Top venues met aantallen.
- Gemiddeld cijfer per artiest, per venue (optreden en geluid apart inzichtelijk).
- Totale tijd live muziek.
- Geografische spreiding op kaart.
- Meest gehoorde nummers live.
- "Jaar in concerten"-overzicht (Spotify Wrapped-stijl).
- Deelbare visuele kaarten voor Instagram en andere kanalen.

**Bron:** ruwe data is al vastgelegd in Fase 1 (cijfers, venues, attendances). In Fase 2 bouwen we de visuele stats-laag erbovenop.

**Definition of Done:** TestFlight uitgebreid naar 25 gebruikers met de stats-pagina's en deelfunctionaliteit.

**Niet in deze fase:** vrienden, feed, ontmoeten.

---

## Fase 3 — Social fundering

**Doel:** publieke launch in App Store met basis-social.

**Features:**
- Vriendschappen (verzoek + accepteren).
- Profielen (publiek of voor vrienden).
- Feed: wat hebben vrienden recent gelogd?
- "Ik ga ook"-knop op aankomende concerten van vrienden.
- Comments op attendances.

**Definition of Done:** App Store-launch met deze features actief.

**Niet in deze fase:** matching met onbekenden, chat, ontdekken van mensen.

---

## Fase 4 — Mensen ontmoeten

**Doel:** sociaal verbinden met onbekenden die naar dezelfde concerten gaan.

**Features:**
- Match-functionaliteit voor concerten waar je heen gaat.
- Chat tussen matches.

**Voorwaarde voor start:** Fase 3 heeft echte gebruikers (concrete drempel bepalen we wanneer Fase 3 live is).

**Definition of Done:** volgt later.
