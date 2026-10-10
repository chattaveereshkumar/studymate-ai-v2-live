-- StudyMate AI V2 starter schema for Supabase PostgreSQL.
-- Run in Supabase SQL Editor for real cloud accounts and data.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  college text not null default '',
  course text not null default '',
  year text not null default '',
  semester text not null default '',
  study_hours_per_day numeric not null default 3 check (study_hours_per_day between 0 and 18),
  preferred_time text not null default 'Evening',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  code text not null default '',
  description text not null default '',
  progress integer not null default 0 check (progress between 0 and 100),
  created_at timestamptz not null default now()
);

create table if not exists public.exams (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  subject text not null default '',
  exam_date date,
  notes text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.study_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  subject text not null default '',
  due_label text not null default 'Today',
  is_done boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.study_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  subject text not null default '',
  minutes integer not null check (minutes > 0 and minutes <= 1440),
  session_date date not null default current_date,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.subjects enable row level security;
alter table public.exams enable row level security;
alter table public.study_tasks enable row level security;
alter table public.study_sessions enable row level security;

drop policy if exists "profiles are private to owner" on public.profiles;
create policy "profiles are private to owner" on public.profiles for all to authenticated using (auth.uid() = id) with check (auth.uid() = id);
drop policy if exists "subjects are private to owner" on public.subjects;
create policy "subjects are private to owner" on public.subjects for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "exams are private to owner" on public.exams;
create policy "exams are private to owner" on public.exams for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "tasks are private to owner" on public.study_tasks;
create policy "tasks are private to owner" on public.study_tasks for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "sessions are private to owner" on public.study_sessions;
create policy "sessions are private to owner" on public.study_sessions for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();
