# Architectuur — Concerten

> Tech stack, datamodel, folderstructuur, integraties en git workflow. Werk dit document bij wanneer er nieuwe patronen of beslissingen ontstaan. De motivering achter elke keuze staat in `DECISIONS.md`.

---

## Tech stack

| Laag | Keuze | Reden |
|---|---|---|
| Frontend | SwiftUI (iOS 17+) | Native iOS, modern Apple-pad, snelle iteratie. Zie ADR-001. |
| Backend | Supabase (Postgres + Auth + Storage + Realtime) | Echte SQL voor stats; Auth+Storage+Realtime in één pakket; iOS SDK aanwezig. Zie ADR-002. |
| Setlist-data | Setlist.fm API | Historische setlists per concert, venue-data, artiest-data via MusicBrainz. Zie ADR-003. |
| Muziek-metadata | Spotify API | Artiest-foto's, koppeling met luistergedrag, track-IDs. Zie ADR-003. |
| Versiebeheer | Git + GitHub (privé) | Cas leest geen code; PR is moment voor inhoudelijk akkoord. Zie ADR-004. |
| IDE | Xcode | Verplicht voor iOS-builds en TestFlight-uploads. |
| Distributie | TestFlight → App Store | Standaard Apple-pad. |
| CLI-tooling | `gh` (GitHub CLI), Homebrew | Eenvoudige authenticatie en PR-beheer vanuit terminal. |

---

## Folderstructuur

> Wordt ingevuld zodra het Xcode-project bestaat (Fase 0 / Stap 5 — volgende sessie).

---

## Datamodel — eerste schets

> Tabellen worden aangemaakt in Supabase wanneer we het project opzetten. Veldnamen zijn voorstellen — definitieve schema's komen in migratiebestanden.

### `auth.users` (Supabase-beheerd) + `public.profiles`
Supabase Auth beheert zelf de tabel `auth.users` met `id`, `email`, `created_at` etc. Daar mag je geen kolommen aan toevoegen. Voor extra user-data houden we een eigen tabel `public.profiles` aan met dezelfde `id` als foreign key naar `auth.users(id)`. Een database-trigger maakt automatisch een `profiles`-rij aan zodra er een nieuwe gebruiker in `auth.users` verschijnt.

**`public.profiles`:**
- `id` (uuid, primary key) — gelijk aan `auth.users.id`
- `display_name` (text, nullable)
- `spotify_user_id` (text, nullable) — koppeling met Spotify-account voor luistergedrag
- `created_at` (timestamp)

### `artists`
Een artiest of band. Eén entry per unieke artiest, herbruikt over alle concerten.
- `id` (uuid, primary key)
- `setlistfm_mbid` (text, unique) — MusicBrainz-ID die Setlist.fm gebruikt om artiesten uniek te identificeren
- `spotify_id` (text, nullable)
- `name` (text)
- `image_url` (text, nullable) — afkomstig uit Spotify

### `venues`
Een concertlocatie.
- `id` (uuid, primary key)
- `setlistfm_id` (text, unique)
- `name` (text)
- `city` (text)
- `country` (text)
- `latitude` (numeric, nullable)
- `longitude` (numeric, nullable)

### `concerts`
Een specifieke avond met één hoofdartiest in één venue. Eén entry, ook al hebben meerdere gebruikers er hetzelfde concert bezocht.
- `id` (uuid, primary key)
- `setlistfm_id` (text, unique)
- `artist_id` (uuid, foreign key → `artists.id`)
- `venue_id` (uuid, foreign key → `venues.id`)
- `date` (date)
- `tour_name` (text, nullable)

### `songs`
Een nummer.
- `id` (uuid, primary key)
- `title` (text)
- `artist_id` (uuid, foreign key → `artists.id`) — oorspronkelijke artiest (kan afwijken van uitvoerder bij covers)
- `spotify_track_id` (text, nullable)

### `setlists`
De volgorde van nummers tijdens een specifiek concert.
- `id` (uuid, primary key)
- `concert_id` (uuid, foreign key → `concerts.id`)
- `song_id` (uuid, foreign key → `songs.id`)
- `position` (integer) — volgorde binnen het concert
- `is_encore` (boolean)
- `is_cover` (boolean)
- `cover_artist_id` (uuid, foreign key → `artists.id`, nullable) — bij covers: wie deed het origineel

### `attendances`
"Ik was bij dit concert." Centrale tabel voor de logboek-feature.
- `id` (uuid, primary key)
- `user_id` (uuid, foreign key → `auth.users.id`)
- `concert_id` (uuid, foreign key → `concerts.id`)
- `rating_performance` (integer 1–10, nullable)
- `rating_sound` (integer 1–10, nullable)
- `notes` (text, nullable)
- `companions` (text, nullable) — vrije tekst over wie er meeging
- `created_at` (timestamp)

### `concert_photos`
Foto's die de gebruiker bij een attendance uploadt.
- `id` (uuid, primary key)
- `attendance_id` (uuid, foreign key → `attendances.id`)
- `storage_path` (text) — pad in Supabase Storage
- `created_at` (timestamp)

### `friendships`
Vriendschap tussen twee gebruikers. Pas actief vanaf Fase 3 — schema vast neerleggen zodat we later niet hoeven te migreren.
- `id` (uuid, primary key)
- `requester_id` (uuid, foreign key → `users.id`)
- `addressee_id` (uuid, foreign key → `users.id`)
- `status` (enum: `pending` / `accepted` / `blocked`)
- `created_at` (timestamp)

---

## API-integraties

### Setlist.fm
- **Wat we eruit halen:** artist-search (per naam), setlists per concert (compleet met nummers en encore-markering), venue-data (naam, plaats, land), tour-namen.
- **Hoe:** REST API met API-key. Vereist registratie op api.setlist.fm.
- **Beperking:** rate limit. We cachen veel server-side in Supabase om herhaalde calls te vermijden.

### Spotify
- **Wat we eruit halen:** artist-foto's, artist-IDs voor links, optioneel later: koppeling met luistergedrag van gebruiker (welke nummers heb ik live gehoord en daarna teruggeluisterd).
- **Hoe:** Spotify Web API. Voor publieke data: OAuth client-credentials flow. Voor user-data: aparte Spotify-login per gebruiker (relevant in Fase 2).
- **Beperking:** OAuth client-credentials werkt niet voor user-data; daar hebben we een aparte Spotify-login per gebruiker voor nodig.

---

## Authenticatieflow

> Definitieve flow wordt vastgesteld wanneer we Supabase opzetten in een latere sessie.

**Definitieve flow (vanaf 2026-05-13, zie ADR-006):** Supabase Auth met **e-mail + magic link**. Geen wachtwoord. Apple Sign In overwegen we vlak voor App Store-publicatie (Apple verplicht het zodra er sociale login is, maar bij magic-link-only blijft het optioneel).

---

## Secrets en configuratie

**Drie soorten "geheimen" rond Supabase, met elk hun eigen plek:**

| Wat | Mag in repo? | Mag in chat? | Waar opgeslagen |
|---|---|---|---|
| **Project URL** (`https://<ref>.supabase.co`) | Ja | Ja | `Concerten/Concerten/Config.swift` (ingecheckt) |
| **`anon public` key** | Ja | Ja | `Concerten/Concerten/Config.swift` (ingecheckt) |
| **Database wachtwoord** | Nee | Nee | Cas' wachtwoordmanager |
| **`service_role` key** | Nee | Nee | Alleen op de server (later Edge Functions / Supabase dashboard) |

**Waarom mogen URL en anon key in de repo?** De anon key is by design publiek. Zodra de iOS-app op een telefoon staat, kun je hem uit de binary halen — dat is geen aanvalsvector die we proberen tegen te houden. De data wordt beschermd door **Row Level Security** op de database (regels die zeggen "alleen rijen waar `auth.uid() = user_id`"). De `service_role` key omzeilt RLS volledig — die mag dus nooit in de client of in de repo.

**Wanneer dit pijn gaat doen:** zodra de repo publiek wordt (open-source), is het netter om de anon key naar een `xcconfig`-bestand te verplaatsen dat per omgeving wisselt (staging vs productie). Voor nu — privé-repo, één project — is hardcoden in `Config.swift` de eenvoudigste route. Bij open-sourcing een nieuwe ADR.

---

## Regels voor nieuwe schermen / features

> Wordt ingevuld zodra de eerste schermen bestaan en patronen ontstaan.

---

## Git workflow

Detail en argumenten: zie ADR-004.

**Korte versie:**
- Geen werk direct op `main`. Eénmalige uitzondering was de allereerste documentatie-commit op 2026-04-30.
- Voor elke taak een nieuwe branch:
  - `feature/<korte-omschrijving>` — nieuwe functionaliteit (bijvoorbeeld `feature/concert-logging`).
  - `fix/<korte-omschrijving>` — bug fix (bijvoorbeeld `fix/login-crash`).
  - `chore/<korte-omschrijving>` — onderhoud, refactor, build-config, deps (bijvoorbeeld `chore/setup-supabase`).
- Commits in plain Dutch, beschrijvend. Niet *"update form"*, wél *"Voeg cijfer voor geluid toe aan attendance-formulier"*.
- Aan einde taak: push branch, PR via `gh pr create`, Cas beoordeelt inhoud (titel + omschrijving + eventueel screenshots), merge na akkoord.
- `main` blijft altijd in werkende staat.
