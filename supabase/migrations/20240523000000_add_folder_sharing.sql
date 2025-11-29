-- Add owner_id and shared_with columns to folders table
ALTER TABLE folders 
ADD COLUMN owner_id UUID REFERENCES auth.users(id),
ADD COLUMN shared_with UUID[] DEFAULT '{}';

-- Update existing folders to have the creator as owner
UPDATE folders SET owner_id = user_id;

-- Create a function to append to shared_with array
CREATE OR REPLACE FUNCTION append_shared_with(folder_id UUID, user_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE folders
  SET shared_with = array_append(shared_with, user_id)
  WHERE id = folder_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
