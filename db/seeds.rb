def get_random_usa_state_short_name
  st = Faker::AddressUS.state
  state_hash = Address.country_state_list[0][:usa].select { |x| x.values[0] == st }[0]
  state_hash.keys[0].downcase
end

PaperTrail.enabled = false
if Rails.env.staging? || Rails.env.development?
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  require_relative "seeds_production"
  require_relative "seeds_development"
else
  require_relative "seeds_production"
end