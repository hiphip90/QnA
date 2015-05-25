ThinkingSphinx::Index.define :user, with: :active_record do
  # fields
  indexes email
  indexes name

  # attributes
  has created_at, updated_at
end