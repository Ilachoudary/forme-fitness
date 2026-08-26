-- Starter Supabase schema for Forme
create extension if not exists "uuid-ossp";
create table if not exists profiles (user_id uuid primary key references auth.users(id) on delete cascade, age int, sex text, height_cm numeric, starting_weight_kg numeric, goal text, activity_level text, gym_access boolean, experience text, workout_minutes text, diet_preference text, calorie_target int, protein_target int, carb_target int, fat_target int, water_target_l numeric, step_target int, created_at timestamptz default now());
create table if not exists daily_targets (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, target_date date not null, calories int, protein_g int, carbs_g int, fat_g int, water_l numeric, steps int, unique(user_id,target_date));
create table if not exists meals (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, weekday int, name text, meal_time time, sort_order int);
create table if not exists meal_items (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, meal_id uuid references meals(id) on delete cascade, food_name text, portion_text text, calories int, protein_g numeric, carbs_g numeric, fat_g numeric);
create table if not exists food_alternatives (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, category text, food_name text, calories_per_unit numeric, protein_per_unit numeric, carbs_per_unit numeric, fat_per_unit numeric, unit text);
create table if not exists meal_logs (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, meal_id uuid references meals(id) on delete cascade, log_date date, eaten boolean default false, overrides jsonb default '{}'::jsonb, unique(user_id,meal_id,log_date));
create table if not exists workout_days (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, weekday int, name text);
create table if not exists exercises (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, name text, category text);
create table if not exists workout_exercises (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, workout_day_id uuid references workout_days(id) on delete cascade, exercise_id uuid references exercises(id), sets int, rep_range text, rest_seconds int, sort_order int);
create table if not exists workout_logs (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, workout_day_id uuid references workout_days(id), log_date date, completed boolean default false, notes text);
create table if not exists set_logs (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, workout_log_id uuid references workout_logs(id) on delete cascade, workout_exercise_id uuid references workout_exercises(id), set_number int, weight_kg numeric, reps int, completed boolean default false, rIR numeric);
create table if not exists daily_water_logs (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, log_date date, amount_ml int, logged_at timestamptz default now());
create table if not exists daily_step_logs (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, log_date date, steps int, source text default 'manual', unique(user_id,log_date,source));
create table if not exists weekly_checkins (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, week_start date, weight_kg numeric, waist_cm numeric, hips_cm numeric, thigh_cm numeric, energy text, hunger text, sleep text, workout_performance text, diet_adherence numeric, notes text);
create table if not exists progress_photos (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, checkin_id uuid references weekly_checkins(id) on delete cascade, view text check (view in ('front','side','back')), storage_path text);
create table if not exists reminders (id uuid primary key default uuid_generate_v4(), user_id uuid references auth.users(id) on delete cascade, title text, reminder_time time, notification_type text, repeat_days int[], enabled boolean default true);

-- Enable RLS and restrict every row to its owner.
do $$ declare t text; begin
  foreach t in array array['profiles','daily_targets','meals','meal_items','food_alternatives','meal_logs','workout_days','exercises','workout_exercises','workout_logs','set_logs','daily_water_logs','daily_step_logs','weekly_checkins','progress_photos','reminders'] loop
    execute format('alter table %I enable row level security',t);
    execute format('drop policy if exists owner_all on %I',t);
    execute format('create policy owner_all on %I for all using (auth.uid() = user_id) with check (auth.uid() = user_id)',t);
  end loop;
end $$;
