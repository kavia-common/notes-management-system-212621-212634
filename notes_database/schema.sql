-- Notes App PostgreSQL Schema
-- Idempotent definitions so the script can be safely re-run.

-- Enable useful extensions (idempotent)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Notes table
CREATE TABLE IF NOT EXISTS public.notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    user_id UUID NULL
);

-- Optional: simple trigger to keep updated_at current (safe to create if not exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'set_notes_updated_at'
    ) THEN
        CREATE OR REPLACE FUNCTION public.set_updated_at()
        RETURNS trigger AS $f$
        BEGIN
            NEW.updated_at := NOW();
            RETURN NEW;
        END
        $f$ LANGUAGE plpgsql;

        CREATE TRIGGER set_notes_updated_at
        BEFORE UPDATE ON public.notes
        FOR EACH ROW
        EXECUTE FUNCTION public.set_updated_at();
    END IF;
END
$$;
