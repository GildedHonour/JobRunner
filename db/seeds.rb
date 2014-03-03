if ENV['DEVELOPMENT'] || Rails.env.development?
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  require_relative "seeds-production"
  require_relative "seeds-development"
else
  require_relative "seeds-production"
end

