-- Optional seed data for development/demo purposes.
-- Uses INSERT ... ON CONFLICT to avoid duplicate inserts if run multiple times.

-- Ensure the table exists before seeding (no-op if already exists)
CREATE TABLE IF NOT EXISTS public.notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    user_id UUID NULL
);

-- Insert sample notes with fixed IDs for idempotency
INSERT INTO public.notes (id, title, content, user_id)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'Welcome to Notes', 'This is your first note! Feel free to edit or delete it.', NULL),
    ('22222222-2222-2222-2222-222222222222', 'Second Note', 'Multi-container app ready: frontend, backend, and database.', NULL)
ON CONFLICT (id) DO NOTHING;
