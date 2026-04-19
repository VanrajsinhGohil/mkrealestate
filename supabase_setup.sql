-- 1. Create Properties Table
CREATE TABLE public.properties (
    id UUID DEFAULT extensions.uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    area TEXT NOT NULL,
    type TEXT NOT NULL,
    price TEXT NOT NULL,
    category TEXT DEFAULT 'Standard',
    description TEXT,
    images JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Enable Row Level Security (RLS) on the table
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;

-- 3. Create Policy: Allow public read access to properties
CREATE POLICY "Public Read Access" on public.properties FOR SELECT USING (true);

-- 4. Create Policy: Allow authenticated users to manage properties
CREATE POLICY "Admin Write Access" on public.properties FOR ALL USING (auth.role() = 'authenticated');

-- 5. Set up Storage Bucket for Images
INSERT INTO storage.buckets (id, name, public) VALUES ('properties', 'properties', true);

-- 6. Create Policy: Allow public read to the 'properties' bucket
CREATE POLICY "Public Storage Read" ON storage.objects FOR SELECT USING (bucket_id = 'properties');

-- 7. Create Policy: Allow authenticated users to upload and delete from bucket
CREATE POLICY "Admin Storage Insert" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'properties' AND auth.role() = 'authenticated');
CREATE POLICY "Admin Storage Delete" ON storage.objects FOR DELETE USING (bucket_id = 'properties' AND auth.role() = 'authenticated');
CREATE POLICY "Admin Storage Update" ON storage.objects FOR UPDATE USING (bucket_id = 'properties' AND auth.role() = 'authenticated');
