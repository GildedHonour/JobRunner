DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

320.times do
  Contact.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.us_state,
    zip: Faker::Address.zip_code
  )
end

120.times do
  Company.create(
    name: Faker::Company.name,
    website: Faker::Internet.domain_name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.us_state,
    zip: Faker::Address.zip_code
  )
end

User.create!(email: 'sean@engageyourcause.com', password: 'password')
