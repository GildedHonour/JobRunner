[
    "Internal",
    "Agency",
    "Supplier/Service Provider",
    "Nonprofit",
    "Commercial",
    "Media"
].each { |company_type| CompanyType.find_or_create_by!(name: company_type) }

User.create!(email: 'sean@engageyourcause.com', password: 'password')
User.create!(email: 'projects@akshay.cc', password: 'password')
User.create!(email: 'lori@mmidirect.com', password: 'password')

%w(PMG MMI TEG MSL).each do |internal_company|
  Company.create!(
    name: internal_company,
    website: Faker::Internet.domain_name,
    company_type: CompanyType.internal,
    addresses: [
      Address.new(
        address_line_1: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.us_state,
        zip: Faker::Address.zip_code
      )
    ]
  )
end