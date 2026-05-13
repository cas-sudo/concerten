# Architecturale beslissingen — Concerten

> Format: ADR (Architecture Decision Record — een korte notitie waarin je een belangrijke keuze vastlegt). Per beslissing: nummer, datum, status, context, beslissing, argumenten, consequenties. Bij wijziging van een eerdere beslissing: nieuwe ADR die de oude vervangt of aanvult — *nooit* een ADR retroactief aanpassen.

---

## ADR-001 — SwiftUI in plaats van UIKit of React Native

**Datum:** 2026-04-30
**Status:** geaccepteerd

### Context
We bouwen een iOS-app als persoonlijk project. Drie realistische opties:
- **SwiftUI** — Apple's moderne UI-framework (sinds 2019).
- **UIKit** — Apple's klassieke UI-framework, sinds 2008.
- **React Native** — cross-platform JavaScript/TypeScript, voor zowel iOS als Android.

### Beslissing
We kiezen **SwiftUI**.

### Argumenten
- **Native iOS-look-and-feel.** SwiftUI levert direct het Apple-design-patroon dat gebruikers verwachten.
- **Modern pad.** Apple investeert primair in SwiftUI; UIKit krijgt nauwelijks nog nieuwe features.
- **Snelle iteratie.** Live previews in Xcode versnellen het ontwerpwerk, vooral relevant nu we klein bouwen.
- **iOS-only is bewust.** Cas richt zich op iOS-publiek; cross-platform-compromis (React Native) levert geen waarde op nu Android niet in scope is.
- **Cas is niet-technisch.** SwiftUI's declaratieve stijl ("zo ziet het scherm eruit", in plaats van "zo bouw ik het op") sluit aan bij hoe Cas over schermen denkt.

### Consequenties
- Geen Android-versie zonder een tweede codebase. Acceptabel zolang doelpubliek iOS is.
- iOS 17+ als minimum (om alle moderne SwiftUI-features te kunnen gebruiken). Dat sluit oudere iPhones uit (vóór iPhone XS).
- Toekomstige animaties en complexe layouts kunnen UIKit-bridges nodig hebben, maar dat lossen we per geval op.

---

## ADR-002 — Supabase in plaats van eigen backend of Firebase

**Datum:** 2026-04-30
**Status:** geaccepteerd

### Context
We hebben een backend nodig voor: gebruikersaccounts (auth), datatabellen (concerten, attendances, ratings, vriendschappen), file-opslag (foto's), en realtime updates (later voor de feed in Fase 3).

Drie realistische opties:
- **Supabase** — gehoste Postgres-database + Auth + Storage + Realtime, met iOS SDK.
- **Firebase** — Google's backend-as-a-service, met NoSQL-database (Firestore) + Auth + Storage.
- **Eigen backend** — bijvoorbeeld Node.js + Postgres op een eigen server.

### Beslissing
We kiezen **Supabase**.

### Argumenten
- **Echte SQL (Postgres).** Voor de stats-pagina's in Fase 2 hebben we gegroepeerde queries nodig (*"aantal keer per artiest gezien"*, *"gemiddeld cijfer per venue"*). Dat is in een echte SQL-database triviaal en in NoSQL (Firebase) moeizaam.
- **All-in-one.** Auth + Storage + Realtime + Database in één pakket scheelt integratiewerk en koppelingen tussen meerdere services.
- **iOS SDK.** Officiële Swift-bibliotheek beschikbaar — geen handmatig REST-werk.
- **Cas is niet-technisch.** Hoe minder bewegende delen ik moet uitleggen, hoe beter. Eén dashboard voor alle backend-zaken.
- **Geen vendor lock-in op datalaag.** Postgres-data kan altijd worden geëxporteerd naar elke andere Postgres-host.
- **Gratis tot ~50.000 maandelijkse gebruikers.** Geen kosten in Fase 1–3.

### Consequenties
- Supabase is het centrale punt; downtime van Supabase = downtime van de app. Geen direct probleem in Fase 1, wel iets om te monitoren.
- Realtime in Fase 3 vergt aparte aandacht; we leren het ter plekke.
- Bij hyper-groei naar miljoenen gebruikers moeten we de Supabase-tier opwaarderen of de database verhuizen — geen blocker, wel een toekomstige beslissing.

---

## ADR-003 — Setlist.fm + Spotify als externe data, geen Bandsintown

**Datum:** 2026-04-30
**Status:** geaccepteerd

### Context
We hebben externe data nodig voor: setlists, artiest-data, venue-data, foto's. Drie kandidaten:
- **Setlist.fm API** — historische setlists per concert, venues, artiest-IDs via MusicBrainz.
- **Spotify Web API** — artiest-foto's, track-IDs, koppeling met luistergedrag.
- **Bandsintown API** — aankomende concerten en tour-data.

### Beslissing
We integreren **Setlist.fm + Spotify**. **Bandsintown laten we voorlopig vallen.**

### Argumenten
- **Setlist.fm is uniek.** Historische setlist-data per concert (welke nummers, in welke volgorde, encores apart) is op geen enkele andere bron op deze schaal beschikbaar. Onmisbaar voor de kern van Fase 1.
- **Spotify levert de visuele en muzikale laag.** Artist-foto's, track-IDs, later koppeling met "wat heb ik live gehoord en hoe luister ik daarna".
- **Bandsintown is voor "ontdekken van aankomende concerten".** Die feature staat *niet* in onze roadmap (Fase 1–4 gaat over loggen + stats + social, niet over concert discovery). Bandsintown integreren zou scope-creep zijn.

### Consequenties
- Geen "kom je dit concert ook?" als suggestie aan de gebruiker — wel als Fase 3-feature ("vriend gaat hierheen") via eigen data.
- Twee externe afhankelijkheden, twee API-keys om te beheren. Beheersbaar.
- Mocht Bandsintown later toch waarde hebben (bijvoorbeeld in een Fase 5 rond aankomende concerten), revisiteren we deze beslissing met een nieuwe ADR.

---

## ADR-004 — Git workflow met feature-branches en pull requests

**Datum:** 2026-04-30
**Status:** geaccepteerd

### Context
Cas leest geen code, maar wil wél kunnen sturen op wat er in `main` belandt. Twee modellen:
- **Direct op `main`.** Sneller, minder ceremonie, geen PR-workflow.
- **Feature-branches + PR's.** Elke taak een eigen branch, merge na review.

### Beslissing
We werken met **feature-branches en pull requests**. Eénmalige uitzondering: de allereerste documentatie-commit op 2026-04-30 ging direct op `main` om de basis te leggen.

### Argumenten
- **PR is Cas' moment voor inhoudelijk akkoord.** Hij ziet titel, beschrijving en eventueel screenshots in plain Dutch en kan goedkeuren of bijsturen zonder de code te lezen.
- **`main` blijft altijd werkend.** Een mislukt experiment op een feature-branch raakt `main` niet.
- **Helder spoor.** Per feature één branch + PR + merge — makkelijk terug te lezen wie wat wanneer wijzigde.
- **Standaardpraktijk.** Toekomstige collaborateurs (of toekomstige Cas) verwachten dit.

### Naamgeving
- **Branches:**
  - `feature/<korte-omschrijving>` — nieuwe functionaliteit (bijvoorbeeld `feature/concert-logging`).
  - `fix/<korte-omschrijving>` — bug fix (bijvoorbeeld `fix/login-crash`).
  - `chore/<korte-omschrijving>` — onderhoud, refactor, build-config, deps (bijvoorbeeld `chore/setup-supabase`).
- **Commits:** plain Dutch, beschrijvend. *"Voeg cijfer voor geluid toe aan attendance-formulier"*, niet *"update form"*.

### Consequenties
- Iedere taak vergt een paar extra git-stappen. Acceptabel in ruil voor de stabiliteit van `main`.
- Cas moet elke PR akkoord geven voordat deze gemerged wordt — verlengt cycle time, maar past bij zijn rol als product owner.
- We gebruiken **`gh` (GitHub CLI)** voor PR-aanmaak en -beheer vanuit de terminal — geïnstalleerd via Homebrew op 2026-04-30. Dat scheelt Cas handelingen in de browser.

---

## ADR-005 — Supabase-project in regio `eu-north-1` (Stockholm)

**Datum:** 2026-05-13
**Status:** geaccepteerd

### Context
Bij het aanmaken van het Supabase-project moet één regio worden gekozen. Die kan achteraf niet worden gewijzigd zonder data-migratie naar een nieuw project. Relevante regio's voor een Nederlands-gerichte iOS-app:
- `eu-central-1` (Frankfurt)
- `eu-west-1` (Ierland)
- `eu-north-1` (Stockholm)
- `us-east-1` (Virginia)

### Beslissing
Het project staat in **`eu-north-1` (Stockholm)** — gekozen door Cas bij projectaanmaak op 2026-05-13.

### Argumenten
- **GDPR.** Data van Nederlandse gebruikers binnen de EU bewaren is de eenvoudigste route om aan GDPR te voldoen — geen extra contractuele constructies (Standard Contractual Clauses, Data Privacy Framework) nodig zoals bij US-regio's.
- **Latency.** Stockholm zit op ~30–50ms van Nederland — niet zo dichtbij als Frankfurt (~10–20ms), maar voor de huidige use-case (lees-/schrijfacties bij concertloggen, geen realtime gaming) ruim binnen de comfortzone.
- **Beschikbaarheid.** AWS' `eu-north-1` is een volwaardige Supabase-regio met dezelfde features als de andere EU-regio's.
- **Geen heroverweging nu.** Frankfurt zou marginaal sneller zijn geweest, maar het verschil is niet merkbaar voor de eindgebruiker. Een project-migratie nu zou tijd kosten zonder concreet voordeel.

### Consequenties
- Alle backend-data (gebruikers, attendances, foto's) blijft binnen de EU.
- Bij eventuele uitbreiding naar Amerikaanse gebruikers (niet in roadmap) is regio-keuze geen blocker — Supabase ondersteunt later read-replicas in andere regio's.
- Mocht latency vanuit Nederland ooit een probleem worden (onwaarschijnlijk bij deze app), migreren we naar `eu-central-1` met een nieuwe ADR.

---

## ADR-006 — Authenticatie via e-mail + magic link, met `profiles`-tabel naast `auth.users`

**Datum:** 2026-05-13
**Status:** geaccepteerd

### Context
Het Supabase-project heeft een ingebouwde Auth-module die meerdere methodes aanbiedt: wachtwoord (e-mail + password), magic link (e-mail met inlog-knop), OTP per sms, en social providers (Google, Apple, GitHub, etc.). We moeten kiezen waarmee gebruikers inloggen en hoe we extra user-data (display name, Spotify-koppeling) opslaan — `auth.users` is namelijk Supabase-beheerd en niet uitbreidbaar.

### Beslissing
**Inlog:** e-mail + **magic link**. Geen wachtwoord. Apple Sign In houden we open voor vlak voor App Store-publicatie.

**User-data:** aparte tabel `public.profiles` met `id` als foreign key naar `auth.users(id)`. Een database-trigger (`on_auth_user_created`) maakt automatisch een lege `profiles`-rij aan bij elke nieuwe signup.

### Argumenten

**Voor magic link:**
- **Geen wachtwoord = minder frictie.** Cas' eerste testgroep (5 vrienden uit Fase 1) hoeft niets te onthouden of te resetten. Aanmelden = e-mailadres invullen, link in mail aanklikken, app opent automatisch.
- **iOS heeft sterke universal-link-ondersteuning.** Een magic link uit Supabase opent de app rechtstreeks zonder browser-tussenstop.
- **Geen wachtwoord = geen lekkage-risico bij hergebruik.** Testgebruikers gebruiken in praktijk hun e-mail-wachtwoord overal; een gestolen Concerten-wachtwoord zou ook elders schade doen.
- **Apple Sign In is optioneel zolang we geen andere sociale login hebben.** App Store-regel: zodra Google/Facebook/etc. login wordt aangeboden, *moet* Apple Sign In ook. Bij magic-link-only kunnen we Apple Sign In rustig later toevoegen wanneer er gevraagd wordt naar "een klik om in te loggen".

**Voor `profiles`-tabel:**
- **`auth.users` is niet uitbreidbaar.** Supabase beheert die tabel zelf en upgrades kunnen kolommen toevoegen of verwijderen. Eigen velden erop plakken = riskant.
- **Standaardpatroon in Supabase.** Bijna elke Supabase-app heeft een `public.profiles` (of `public.users`) met de extra kolommen. Documentatie en voorbeelden gaan ervan uit.
- **RLS-scheiding.** Op `profiles` kunnen we eigen Row Level Security-policies zetten zonder `auth.users` te raken.
- **Trigger zorgt voor consistentie.** `on_auth_user_created` maakt de `profiles`-rij in dezelfde transactie als de signup; geen "user zonder profiel"-edge cases.

### Consequenties

- **Geen wachtwoord-veld in de app.** Login-scherm vraagt alleen e-mail; gebruiker krijgt direct uitleg dat een link komt.
- **E-mail-deliverability is belangrijk.** Supabase verstuurt magic-link-mails standaard via hun eigen SMTP — werkt voor MVP, maar mocht ooit een mail in de spam belanden bij een testgebruiker, dan koppelen we onze eigen SMTP (bijvoorbeeld Resend of Mailgun) aan Supabase Auth.
- **Universal links moeten correct geconfigureerd worden.** Vereist Apple Developer-enrollment om de Associated Domains-capability aan te zetten. Daarvoor: tijdelijke fallback naar "open de link in Safari, daarna handmatig terug naar de app" totdat Apple Developer is geregeld. Voor nu (alleen in simulator) niet kritiek.
- **`profiles`-trigger draait `security definer`** — dat omzeilt RLS bij de insert. Dat moet zo, anders kan een net aangemaakte gebruiker zijn eigen rij niet toevoegen. Geen INSERT-policy nodig op `profiles` vanuit clients.
- **Apple Sign In als toekomstige uitbreiding:** ADR opnieuw bekijken zodra Apple Developer-enrollment loopt en we serieus richting App Store gaan.
