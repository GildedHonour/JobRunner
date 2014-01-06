DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

100.times do |i|
  company = Company.create(
    name: Faker::Company.name,
    website: Faker::Internet.domain_name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.us_state,
    zip: Faker::Address.zip_code,
    internal: (i % 20).zero?
  )
  company.client_affiliates << Company.order("RANDOM()").where("id <> ?", company.id).limit(5)
  company.prospect_affiliates << Company.order("RANDOM()").where("id <> ?", company.id).limit(5)
end

1500.times do
  Contact.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.us_state,
    zip: Faker::Address.zip_code,
    company_id: Company.order("RANDOM()").first.id
  )
end

User.create!(email: 'sean@engageyourcause.com', password: 'password')
User.create!(email: 'projects@akshay.cc', password: 'password')
