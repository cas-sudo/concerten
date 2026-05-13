-- Migratie 0001 — Initieel datamodel voor Concerten
--
-- Maakt de kern-tabellen aan voor Fase 1 (concert loggen):
--   - profiles    : extra user-data bovenop auth.users (Supabase Auth beheert die)
--   - artists     : artiest of band
--   - venues      : concertlocatie
--   - concerts    : specifieke avond (artist + venue + datum)
--   - attendances : "ik was hier" (centrale tabel voor de logboek-feature)
--
-- Songs/setlists, concert_photos en friendships volgen in latere migraties.
--
-- Conventies:
--   - UUID-primary keys met gen_random_uuid().
--   - created_at op alle user-facing tabellen.
--   - Row Level Security (RLS) staat aan op elke tabel.
--   - Lookups (artists/venues/concerts) zijn leesbaar voor ingelogde
--     gebruikers; schrijven gaat via service_role (later: Edge Functions
--     die data uit Setlist.fm halen).
--   - Attendances zijn strikt eigen-data: gebruiker leest en schrijft
--     alleen zijn eigen rijen.

-- ---------------------------------------------------------------------------
-- 1. profiles
-- ---------------------------------------------------------------------------
-- Supabase Auth beheert auth.users automatisch (id, email, created_at).
-- Daar mag je geen kolommen aan toevoegen. Voor extra user-data maken we
-- een aparte public.profiles-tabel met dezelfde id als foreign key.
-- Een trigger vult deze tabel automatisch bij een nieuwe signup.

create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  display_name    text,
  spotify_user_id text,
  created_at      timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Eigen profiel is leesbaar"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Eigen profiel is bij te werken"
  on public.profiles for update
  using (auth.uid() = id);

-- Trigger: maak automatisch een profiel aan bij elke nieuwe auth.users-rij.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- 2. artists
-- ---------------------------------------------------------------------------

create table public.artists (
  id              uuid primary key default gen_random_uuid(),
  setlistfm_mbid  text unique,
  spotify_id      text,
  name            text not null,
  image_url       text,
  created_at      timestamptz not null default now()
);

alter table public.artists enable row level security;

create policy "Artiesten zijn leesbaar voor ingelogde gebruikers"
  on public.artists for select
  to authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- 3. venues
-- ---------------------------------------------------------------------------

create table public.venues (
  id            uuid primary key default gen_random_uuid(),
  setlistfm_id  text unique,
  name          text not null,
  city          text,
  country       text,
  latitude      numeric,
  longitude     numeric,
  created_at    timestamptz not null default now()
);

alter table public.venues enable row level security;

create policy "Venues zijn leesbaar voor ingelogde gebruikers"
  on public.venues for select
  to authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- 4. concerts
-- ---------------------------------------------------------------------------

create table public.concerts (
  id            uuid primary key default gen_random_uuid(),
  setlistfm_id  text unique,
  artist_id     uuid not null references public.artists(id),
  venue_id      uuid not null references public.venues(id),
  date          date not null,
  tour_name     text,
  created_at    timestamptz not null default now()
);

create index idx_concerts_artist_date on public.concerts(artist_id, date desc);
create index idx_concerts_venue_date  on public.concerts(venue_id, date desc);

alter table public.concerts enable row level security;

create policy "Concerten zijn leesbaar voor ingelogde gebruikers"
  on public.concerts for select
  to authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- 5. attendances
-- ---------------------------------------------------------------------------
-- "Ik was bij dit concert" — de centrale tabel voor het logboek.
-- Eén gebruiker kan een concert maar één keer loggen (unique constraint).

create table public.attendances (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references auth.users(id) on delete cascade,
  concert_id          uuid not null references public.concerts(id) on delete cascade,
  rating_performance  smallint check (rating_performance between 1 and 10),
  rating_sound        smallint check (rating_sound between 1 and 10),
  notes               text,
  companions          text,
  created_at          timestamptz not null default now(),
  unique (user_id, concert_id)
);

create index idx_attendances_user    on public.attendances(user_id);
create index idx_attendances_concert on public.attendances(concert_id);

alter table public.attendances enable row level security;

create policy "Eigen attendances zijn leesbaar"
  on public.attendances for select
  using (auth.uid() = user_id);

create policy "Eigen attendances zijn aan te maken"
  on public.attendances for insert
  with check (auth.uid() = user_id);

create policy "Eigen attendances zijn bij te werken"
  on public.attendances for update
  using (auth.uid() = user_id);

create policy "Eigen attendances zijn te verwijderen"
  on public.attendances for delete
  using (auth.uid() = user_id);
