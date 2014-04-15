PaperTrail.enabled = false
if Rails.env.staging? || Rails.env.development?
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  require_relative "seeds_production"
  require_relative "seeds_development"
else
  require_relative "seeds_production"
end